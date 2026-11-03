#!/usr/bin/env bash
# Claude Code Stop hook: silent desktop notification when Claude finishes.
# Clicking it switches tmux to the pane and raises Konsole (KDE Wayland).
# Usage: notify-done.sh   (hook JSON arrives on stdin)
# Env:   CLAUDE_NOTIFY_FORCE=1  notify even if you're already looking at the pane

input="$(cat)"
cwd="$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)"
project="$(basename "${cwd:-$PWD}")"

target=""
topic=""
if [[ -n "$TMUX_PANE" ]]; then
    target="$(tmux display -p -t "$TMUX_PANE" '#S:#I.#P')"
    # Claude Code sets the pane title to a session summary, e.g. "✳ Fix login bug";
    # drop the leading status glyph.
    topic="$(tmux display -p -t "$TMUX_PANE" '#{pane_title}')"
    if [[ "$topic" =~ ^[^[:alnum:][:space:]]+[[:space:]]+(.*)$ ]]; then
        topic="${BASH_REMATCH[1]}"
    fi
    [[ "$topic" == "$(hostname)" ]] && topic=""

    # Skip if the pane is visible in a focused tmux client (tmux focus-events on).
    if [[ -z "$CLAUDE_NOTIFY_FORCE" ]]; then
        read -r pane_active window_active session <<<"$(tmux display -p -t "$TMUX_PANE" '#{pane_active} #{window_active} #S')"
        if [[ "$pane_active$window_active" == 11 ]] &&
            tmux list-clients -F '#{session_name} #{client_flags}' | grep -q "^$session .*focused"; then
            exit 0
        fi
    fi
fi

title="Claude done: ${topic:-$project}"

if [[ -z "$target" ]]; then
    notify-send -a "Claude Code" -i utilities-terminal \
        --hint="boolean:suppress-sound:true" "$title" "$project (not in tmux)"
    exit 0
fi

# Pick the tmux client to use: one already showing the window, else one on the
# same session, else the most recently active client. Prints "tty pid".
pick_client() {
    local session="${target%%:*}" window="${target%.*}"
    window="${window#*:}"
    tmux list-clients -F '#{client_activity} #{session_name} #{window_index} #{client_tty} #{client_pid}' |
        awk -v s="$session" -v w="$window" '{
            score = ($2 == s && $3 == w) ? 2 : ($2 == s) ? 1 : 0
            print score, $1, $4, $5
        }' | sort -k1,1nr -k2,2nr | head -1 | cut -d' ' -f3-
}

# Raise the Konsole window (and tab) whose shell is an ancestor of the given pid.
raise_konsole_for() {
    local pid="$1" ancestors=() svc sid kpid="" win
    while [[ -n "$pid" && "$pid" -gt 1 ]]; do
        ancestors+=("$pid")
        pid="$(ps -o ppid= -p "$pid" | tr -d ' ')"
    done

    for svc in $(qdbus6 | grep -o 'org\.kde\.konsole-[0-9]*'); do
        for win in $(qdbus6 "$svc" | grep -oP '^/Windows/\K\d+$'); do
            for sid in $(qdbus6 "$svc" "/Windows/$win" org.kde.konsole.Window.sessionList); do
                local spid
                spid="$(qdbus6 "$svc" "/Sessions/$sid" org.kde.konsole.Session.processId)"
                if [[ " ${ancestors[*]} " == *" $spid "* ]]; then
                    qdbus6 "$svc" "/Windows/$win" org.kde.konsole.Window.setCurrentSession "$sid"
                    kpid="${svc##*-}"
                    break 3
                fi
            done
        done
    done

    local js
    js="$(mktemp --suffix=.js)"
    cat >"$js" <<EOF
const konsoles = workspace.windowList().filter(
    w => w.resourceClass === "konsole" || w.resourceClass === "org.kde.konsole");
const win = konsoles.find(w => w.pid === ${kpid:-0})
    || konsoles.find(w => w.caption.includes("tmux")) || konsoles[0];
if (win) workspace.activeWindow = win;
EOF
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript claude-notify >/dev/null 2>&1
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "$js" claude-notify >/dev/null
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.start >/dev/null
    sleep 0.5
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript claude-notify >/dev/null
    rm -f "$js"
}

focus_pane() {
    local tty pid
    read -r tty pid <<<"$(pick_client)"
    [[ -z "$tty" ]] && return
    tmux switch-client -c "$tty" -t "$target" \; select-window -t "$target" \; select-pane -t "$TMUX_PANE"
    raise_konsole_for "$pid"
}

# One notification per pane: replace the previous one and stop its waiting process.
# The x-claude-pane hint is just a marker so pkill can find that process.
state="${XDG_RUNTIME_DIR:-/tmp}/claude-notify"
mkdir -p "$state"
key="${TMUX_PANE#%}"
marker="string:x-claude-pane:$key"
old_id="$(cat "$state/$key.id" 2>/dev/null)"
pkill -f -- "--hint=$marker" 2>/dev/null

# Detach so the hook returns immediately while the notification waits for a click.
# With -p, notify-send prints the notification id first, then the chosen action.
(
    notify-send -p ${old_id:+-r "$old_id"} -a "Claude Code" -i utilities-terminal \
        --hint="string:desktop-entry:org.kde.konsole" \
        --hint="boolean:suppress-sound:true" \
        --hint="$marker" \
        -A default="Go to pane" \
        "$title" "$project · tmux $target"$'\n'"tmux switch-client -t $target" |
        {
            read -r id && echo "$id" >"$state/$key.id"
            read -r action
            [[ "$action" == default ]] && focus_pane
        }
) </dev/null >/dev/null 2>&1 &
disown

exit 0

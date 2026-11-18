#!/usr/bin/env bash
# Claude Code status line: user@host  cwd  context  plan usage (5h / 7d)
input=$(cat)
j() { jq -r "$1" <<<"$input"; }

cwd=$(j '.workspace.current_dir // .cwd')
pct=$(j '(.context_window.used_percentage // 0) | floor')
used=$(j '.context_window.total_input_tokens // 0')
size=$(j '.context_window.context_window_size // 0')

printf '\033[32m%s@%s\033[0m \033[36m%s\033[0m \033[33mctx %s%% (%sk/%sk)\033[0m' \
  "$(whoami)" "$(hostname -s)" "${cwd/#$HOME/\~}" "$pct" "$((used/1000))" "$((size/1000))"

# color by usage: green <50, yellow <80, red >=80
color() { (( $1 >= 80 )) && echo 31 || { (( $1 >= 50 )) && echo 33 || echo 32; }; }

h5=$(j '.rate_limits.five_hour.used_percentage // empty | floor')
h5r=$(j '.rate_limits.five_hour.resets_at // empty')
d7=$(j '.rate_limits.seven_day.used_percentage // empty | floor')
d7r=$(j '.rate_limits.seven_day.resets_at // empty')

if [[ -n $h5 ]]; then
  printf ' \033[%sm5h %s%%\033[0m' "$(color "$h5")" "$h5"
  [[ -n $h5r ]] && printf '\033[2m (↻%s)\033[0m' "$(date -d "@$h5r" +%H:%M)"
fi
if [[ -n $d7 ]]; then
  printf ' \033[%sm7d %s%%\033[0m' "$(color "$d7")" "$d7"
  [[ -n $d7r ]] && printf '\033[2m (↻%s)\033[0m' "$(date -d "@$d7r" '+%a %H:%M')"
fi

# Disable default file completions globally unless specified
complete -c claude -f

# Dynamic session IDs for --resume: newest first, /rename title > AI title
function __claude_sessions
    set -l dir ~/.claude/projects/(string replace -ra '[^a-zA-Z0-9]' '-' -- $PWD)
    test -d $dir; or return
    for f in (command ls -t $dir/*.jsonl 2>/dev/null | head -n 50)
        set -l titles (command grep -hE '"type":"(custom-title|ai-title)"' $f | jq -rs '
            ([.[] | .customTitle // empty] | last) // ([.[] | .aiTitle // empty] | last) // "(untitled)"' 2>/dev/null)
        printf '%s\t%s\n' (path basename -E $f) $titles[1]
    end
end

# Main Options / Flags
complete -c claude -s d -l debug -d "Enable debug logging"
complete -c claude -l verbose -d "Enable verbose output"
complete -c claude -s p -l print -d "Print text/json output"
complete -c claude -l dangerously-skip-permissions -d "Skip permission checks"
complete -c claude -l allowedTools -d "List of allowed tools"
complete -c claude -l disallowedTools -d "List of disallowed tools"
complete -c claude -l mcp-config -d "Path to MCP configuration file"
complete -c claude -s c -l continue -d "Continue previous session"
complete -c claude -s r -l resume -x -k -a "(__claude_sessions)" -d "Resume previous session"
complete -c claude -l model -d "Specify the model to use"
complete -c claude -l fallback-model -d "Specify fallback model"
complete -c claude -s v -l version -d "Show version information"
complete -c claude -s h -l help -d "Show help menu"

# Subcommands
complete -c claude -n "__fish_use_subcommand" -a "config" -d "Manage Claude Code configuration"
complete -c claude -n "__fish_use_subcommand" -a "mcp" -d "Manage Model Context Protocol servers"
complete -c claude -n "__fish_use_subcommand" -a "doctor" -d "Check environment and troubleshoot"
complete -c claude -n "__fish_use_subcommand" -a "update" -d "Update Claude Code"
complete -c claude -n "__fish_use_subcommand" -a "install" -d "Install specific versions"

# Subcommand specific arguments (e.g., config / mcp actions)
complete -c claude -n "__fish_seen_subcommand_from config" -a "set get list reset"
complete -c claude -n "__fish_seen_subcommand_from mcp" -a "list add remove enable disable"


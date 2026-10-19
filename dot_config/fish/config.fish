source /usr/share/cachyos-fish-config/cachyos-config.fish

# # overwrite greeting
# function fish_greeting
#    # do nothing hehe
# end

function fish_greeting
    # Set text colors using Fish's set_color feature
    set_color cyan
    echo "--- ようこそ、ユーザードド。 ---" # "Welcome, user Dodo."
    set_color normal
    echo "現在の時刻: $(date '+%Y年%m月%d日 %H:%M:%S')" # "Current time: [Date/Time]"
    echo ""
end

## Aliases
# Safe rm
alias rmi='rm -i'
alias vim='nvim'
alias ??='fabric -s'
alias gp='git push'
alias cls="clear && tmux clear-history"
# Typo lol
alias claer='clear'

# Swap CachyOS aliases
alias ll='eza -al --color=always --group-directories-first --icons=always'
alias ls='eza -l --color=always --group-directories-first --icons=always'

# Tab not working for this command
complete --command chezmoi_modify_manager --force-files

# opencode
fish_add_path /home/jozefk/.opencode/bin

set -gx EDITOR "nvim"


source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

## Aliases
# Safe rm
alias rmi='rm -i'
alias vim='nvim'
alias ??='fabric -s'
alias gp='git push'
# Typo lol
alias claer='clear'

# Swap CachyOS aliases
alias ll='eza -al --color=always --group-directories-first --icons=always'
alias ls='eza -l --color=always --group-directories-first --icons=always'

# Tab not working for this command
complete --command chezmoi_modify_manager --force-files

# opencode
fish_add_path /home/jozefk/.opencode/bin


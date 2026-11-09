#!/bin/bash
# Clone side projects that ~/.local/bin symlinks point into (see dot_local/bin/symlink_*).
# Existing clones are left untouched. Clone over HTTPS (works before an SSH key exists), push over SSH.
set -e

clone() {
    local repo="$1" dir="$2"
    [ -d "$dir/.git" ] && return 0
    mkdir -p "$(dirname "$dir")"
    git clone "https://github.com/$repo.git" "$dir"
    git -C "$dir" remote set-url --push origin "git@github.com:$repo.git"
}

clone dodokr/tmux-claude-tasks "$HOME/Projects/side-projects/tmux-claude-tasks"

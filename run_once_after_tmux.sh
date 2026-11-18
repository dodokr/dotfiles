#!/bin/bash

set -xe

# Idempotent: safe on machines where tmux was already set up by hand.

# tmux plugin manager (tpm)
[ -d ~/.config/tmux/plugins/tpm ] ||
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# tms command
yay -S --needed --noconfirm tmux-sessionizer-bin

[ -d ~/.config/tmux/plugins/catppuccin/tmux ] ||
    git clone -b v2.3.1 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

# Run `tmux`
# Ctrl + Leader, Shift + I to install plugins

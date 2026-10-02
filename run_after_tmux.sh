#!/bin/bash

# tmux plugin manager (tpm)
mkdir -p ~/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# tms command
yay -S --noconfirm tmux-sessionizer-bin

mkdir ~/.config/tmux/plugins/catppuccin
git clone -b v2.3.1 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

# Run `tmux`
# Ctrl + Leader, Shift + I to install plugins


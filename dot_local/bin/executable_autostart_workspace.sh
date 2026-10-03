#!/bin/bash

# Ensure the ydotool daemon (ydotoold) is running
if ! pgrep -x "ydotoold" > /bin/blank; then
    ydotoold &
    sleep 0.5
fi

# KWin pushes it to D1
google-chrome-stable &

qdbus6 org.kde.KWin /KWin org.kde.KWin.setCurrentDesktop 2
sleep 0.1
# Konsole with Tmux profile
konsole --profile tmux-session &

# Wait for Konsole to launch and hook into Tmux
sleep 1.5

# 3. Inject Tmux Restore Bindings via ydotool
# Assuming your Leader key is Ctrl+B, followed by Ctrl+R.
# Keycodes used: 29 = Ctrl, 57 = Space, 19 = R
# All keycodes in: /usr/include/linux/input-event-codes.h
ydotool key 29:1 57:1 19:1    # Hold Down Ctrl, Space, and R together
sleep 0.1
ydotool key 19:0 57:0 29:0    # Release all three keys

# Launch D3 Apps (KWin pushes them to D3)
spotify &
nohup super-productivity > /dev/null 2>&1 &


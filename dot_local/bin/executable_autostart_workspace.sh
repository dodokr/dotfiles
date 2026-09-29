#!/bin/bash

# Ensure the ydotool daemon (ydotoold) is running
if ! pgrep -x "ydotoold" > /bin/blank; then
    ydotoold &
    sleep 0.5
fi

# 1. Launch Chrome (KWin pushes it to D1)
google-chrome-stable &

# 2. Launch Konsole with your Tmux profile (KWin pushes it to D2)
konsole --profile tmux-session &

# Wait for Konsole to launch and hook into Tmux
sleep 2

# 3. Inject Tmux Restore Bindings via ydotool
# Assuming your Leader key is Ctrl+B, followed by Ctrl+R.
# Keycodes used: 29 = Ctrl, 57 = Space, 19 = R
ydotool key 29:1 57:1 19:1    # Hold Down Ctrl, Space, and R together
sleep 0.1
ydotool key 19:0 57:0 29:0    # Release all three keys

# 4. Launch D3 Apps (KWin pushes them to D3)
spotify &
super-productivity &

# Wait for D3 apps to render
sleep 2.5

# 5. Snap Apps on Desktop 3 using Native Plasma 6 D-Bus and KWin shortcuts
# Switch to Desktop 3
qdbus6 org.kde.KWin /KWin org.kde.KWin.setCurrentDesktop 3
sleep 0.2

# Activate Spotify and snap Left (Default Meta/Super keycode is 125, Left is 105)
qdbus6 org.kde.KWin /KWin org.kde.KWin.activateWindow "$(qdbus6 org.kde.KWin /Windows org.kde.KWin.shownOnDesktop 3 | grep -i spotify | head -n 1)"
sleep 0.1
ydotool key 125:1 105:1 105:0 125:0   # Meta + Left Arrow

# Activate Super Productivity and snap Right (Right arrow keycode is 106)
qdbus6 org.kde.KWin /KWin org.kde.KWin.activateWindow "$(qdbus6 org.kde.KWin /Windows org.kde.KWin.shownOnDesktop 3 | grep -i super-productivity | head -n 1)"
sleep 0.1
ydotool key 125:1 106:1 106:0 125:0   # Meta + Right Arrow


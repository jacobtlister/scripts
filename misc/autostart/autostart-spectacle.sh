#!/bin/bash
# File: autostart-spectacle.sh

: <<'info'
    required packages
        systemctl
        spectacle
        ydtool
        wmctrl

    description
        starts the ydotool systemd service to enable the use of ydotool
        starts a custom systemd service to passively run spectacle in the background
        simulates key presses to disable the compositor. we disable the compositor to improve performance of spectacle
        this script is meant to be used as an autostart login script on kde
info

# starts the ydotool systemd service (this is needed to use ydotool)
systemctl --user enable --now ydotool

# starts the custom spectacle systemd service
systemctl --user enable --now spectacle.service

sleep 1;

# code below focuses on the desktop, presses alt + shift + f12 to disable the compositor, then focuses back on the open windows
# focus to the desktop before pressing the shortcut because if you press it in something like a terminal it won't work right

# focus on the desktop
# -k flag of wmctrl apparently doesn't work in most window managers, but it works for me! winning
wmctrl -k on

sleep 0.05

# press alt + shift + f12 to disable the compositor
# 56 = lalt
# 42 = lshift
# 88 = f12
ydotool key 56:1 42:1 88:1 88:0 42:0 56:0

sleep 0.05

# focus back onto the open windows
# -k flag of wmctrl apparently doesn't work in most window managers, but it works for me! winning
wmctrl -k off

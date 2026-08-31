#!/bin/bash
# File: autostart-spectacle.sh

: <<'info'
    required packages
        systemctl
        spectacle
        ydotool

    description
        starts the ydotool systemd service to enable the use of ydotool
        starts a custom systemd service that ensures spectacle is always running in the background
        we start the ydotool service because when i want to use spectacle i plan to use a script which
        disables the compositor before starting spectacle
        we disable the compositor to improve performance of spectacle after taking a screenshot/capturing video
        this script is meant to be used as a login autostart script on kde
info

# starts the ydotool systemd service (this is needed to use ydotool)
systemctl --user enable --now ydotool

# starts the custom spectacle systemd service
systemctl --user enable --now spectacle.service

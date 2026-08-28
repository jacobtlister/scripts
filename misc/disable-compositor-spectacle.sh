#!/bin/bash
# File: disable-compositor-spectacle.sh

: <<'info'
    required packages
        ydotool
        spectacle

    description
        disables the compositor by typing the shortcut "alt + shift + f12" and
        launches spectacle to take a screenshot of a rectangular region and
        copy the screenshot to the clipboard
info

# so that i can run aliases in ~/.jaliases in scripts
shopt -s expand_aliases
source ~/.jaliases

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

ydo "alt + shift + f12"

spectacle --dbus --nonotify --region --copy-image --background

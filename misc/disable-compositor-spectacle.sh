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

# NOTE: you only need to source function scripts and jaliases in
# the highest-level script. all child processes of thehighest level
# script calls will have access to what it sources unless the child
# is ran in a new/different shell instance

# to allow calling aliases from ~/.jaliases in the script
shopt -s expand_aliases
source "${HOME}/.jaliases"

# to allow calling functions from the scripts repo in the script
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

ydo "alt + shift + f12"

spectacle --dbus --nonotify --region --copy-image --background

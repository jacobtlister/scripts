#!/bin/bash
# File: focus-window.sh

: <<'info'
    required packages
        kdotool

    description
        for use on kde wayland
        focuses on a window with a certain string in it's title (if it exists)
info

# search for instances of windows with containing $1 in it's title and save the first
windowsearch=$(kdotool search --name --class --limit 1 "${1}")

# if there are no windows found, exit silently
[[ -z "${windowsearch}" ]] && exit 0

kdotool windowactivate "${windowsearch}"
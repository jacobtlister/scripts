#!/bin/bash
# File: FILENAME.sh

: <<'info'
    description
        DESCRIPTION

    required packages
        PACKAGE_NAME (REPO OR WEBPAGE LINK)

    additional notes
        EXTRA INFO IF NEEDED
info

# sources all scripts in the utils directory of scripts
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "$HOME/scripts/utils"/*.sh; do source "${f}"; done


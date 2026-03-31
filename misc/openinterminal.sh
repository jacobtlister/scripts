#!/bin/bash
# File: openinterminal.sh

: <<'info'
    required packages
        thunar

    description
        a script that will open a terminal in the present working directory

        intended to be used as a custom action in the thunar file manager

        in the edit action menu, the command to be run should be the following:
            bash /path/to/scripts/misc/openinterminal.sh
info

exo-open --working-directory "$(pwd)" --launch TerminalEmulator

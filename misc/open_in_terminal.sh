#!/bin/bash
# File: open_in_terminal.sh

: <<'info'
    description
        a script that will open a terminal in the currently selected folder

    required packages
        thunar

    additional notes
        intended to be used as a custom action in the thunar file manager.

        in the edit action menu, the command to be run should be the following:
            bash /path/to/script/open_in_terminal.sh
info

exo-open --working-directory "$(pwd)" --launch TerminalEmulator
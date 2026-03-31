#!/bin/bash
# File: error.sh

: <<'info'
    required packages
        none

    description
        prints an error message and kills the script
info

# $1 - script name where error was called from
# $2 - error message to display
error() {
    echo "${1}.sh: ${2}"
    exit 1
}
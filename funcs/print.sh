#!/bin/bash
# File: print.sh

: <<'info'
    description
        a custom function for word - wrapped, indented printing

    required packages
        none

    additional notes
        function format is:
            print string [leadingspaces]
        prints string to the terminal with leadingspaces (default 0) leading spaces
info

# $1 - string to print
# $2 - number of leading spaces to insert on each line
print() {
    if [ $# == 2 ]; then
        leadingspaces="${2}"
    else
        leadingspaces=0
    fi

    # string containing leadingspaces " " characters
    spaces=""

    for i in $(seq 1 1 "${leadingspaces}"); do
        spaces+=" "
    done

    # i know printf directly with variables is poor form (SC2059), but I want to retain newlines so i must
    printf "${spaces}${1}" | fold -s | awk -v spaces="${spaces}" '{ if ( NR == 1 ) { print $0 } else { print spaces $0 } }'
}
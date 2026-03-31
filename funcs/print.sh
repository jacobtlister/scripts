#!/bin/bash
# File: print.sh

: <<'info'
    required packages
        awk

    description
        a custom function for word-wrapped, indented printing

        there are different behaviors depending on the amount of command line arguments:
            print string
            print string lead

        prints string to the terminal with lead (optional, default 0) leading spaces
info

# $1 - string to print
# $2 - number of leading spaces to insert on each line
print() {
    if [[ $# == 2 ]]; then
        leadingspaces="${2}"
    else
        leadingspaces=0
    fi

    # string containing leadingspaces " " characters
    spaces=""

    for (( i = 1; i <= "${leadingspaces}"; i++ )); do
        spaces+=" "
    done

    # i know printf directly with variables is poor form (SC2059), but I want to retain newlines so i must
    printf "${spaces}${1}" | fold -s | awk -v spaces="${spaces}" '{ if ( NR == 1 ) { print $0 } else { print spaces $0 } }'
}
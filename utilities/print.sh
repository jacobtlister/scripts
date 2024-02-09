#!/bin/bash
# File: print.sh
# a custom function for word - wrapped, indented printing

<<'notes'
    required packages
        none

    inputs : string to print, amounts of spaces to additionally indent (optional, final argument)
    outputs: none
notes

print() {
    # leadingSpaces=-1 and use check later to make sure to not reassign value
    leadingSpaces=-1
    spaces=""

    if [ "${leadingSpaces}" == -1 ]; then
        # this line get the number of leading spaces for the string
        leadingSpaces=$(echo "${1}" | head -n 1 | awk '{ match($0, /^ */); printf("%d", RLENGTH) }')
    fi

    if [ "${leadingSpaces}" != 0 ]; then
        if [ "${#}" == 1 ]; then
            (( leadingSpaces=leadingSpaces+4 ))

        else
            (( leadingSpaces=leadingSpaces+"${2}" ))
        fi
    fi

    for i in $(seq 1 1 "${leadingSpaces}"); do
        spaces+=" "
    done

    # i know printf directly with variables is poor form (SC2059), but I want to retain newlines so i must
    printf "${1}" | fold -s | awk -v spaces="${spaces}" '{ if ( NR == 1 ) { print $0 } else { print spaces $0 } }'
}
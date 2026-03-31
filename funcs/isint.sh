#!/bin/bash
# File: isint.sh

: <<'info'
    required packages
        none

    description
        checks that a string can be type-cast to an integer
info

# $1 - string to check
isint() {
    if [[ "${1}" =~ ^[+-]?[0-9]+$ ]]; then
        return 0
    fi

    return 1
}
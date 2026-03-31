#!/bin/bash
# File: isnumeric.sh

: <<'info'
    required packages
        none

    description
        checks that a string can be type-cast to an integer or float
info

# $1 - string to check
isnumeric() {
    if [[ "${1}" =~ ^[+-]?[0-9]+(\.[0-9]+)?$ ]]; then
        return 0
    fi

    return 1
}
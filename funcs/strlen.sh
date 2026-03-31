#!/bin/bash
# File: strlen.sh

: <<'info'
    required packages
        awk

    description
        returns the length of a string
info

# $1 - string to find the length of
strlen() {
    echo "${1}" | awk "{print length}"
}
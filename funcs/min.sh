#!/bin/bash
# File: min.sh

: <<'info'
    required packages
        none

    description
        returns the minimum element in a list
info

# $1 - list to find minimum element of
min() {
    read -r -a arr <<< "${1}"

    printf "%s\n" "${arr[@]}" | sort -n | head -n 1
}
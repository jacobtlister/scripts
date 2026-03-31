#!/bin/bash
# File: max.sh

: <<'info'
    required packages
        none

    description
        returns the maximum element in a list
info

# $1 - list to find maximum element of
max() {
    read -r -a arr <<< "${1}"

    printf "%s\n" "${arr[@]}" | sort -n | tail -n 1
}
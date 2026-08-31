#!/bin/bash
# File: padzeros.sh

: <<'info'
    required packages
        none

    description
        pads leading zeros onto an integer $1 until the string is of length $2
info

# $1 - integer to prepend zeros to
# $2 - desired length of output string
padzeros() {
    if (( ${#1} > ${2} )); then    # if input integer too long, error out of function
        echo "input integer (${1}) longer than desired output string length (${2})"
        exit 1
    elif (( ${#1} == ${2} )); then # if input integer is desired length, do nothing
        echo "${1}"
    elif (( ${#1} < ${2} )); then  # if input integer is too short, prepend 0s to desired length
        echo "$(printf "%0${2}d" $(( ${1} + 0 )))"
    fi

    return 0
}

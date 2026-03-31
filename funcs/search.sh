#!/bin/bash
# File: search.sh

: <<'info'
    required packages
        none

    description
        searches a list arr for string str. if str is found in arr, return
        the indices where str was found in arr. if not, return -1
info

# $1 - string to search for
# $2 - list to search
search() {
    read -r -a arr <<< "${2}"

    # indices where ${1} was found in ${2}
    indices=("-1")

    for (( i = 0; i < ${#2}; i++ )); do
        if [[ "${arr[$i]}" == "${1}" ]]; then
            indices+=("$i")
        fi
    done

    if (( "${#indices[*]}" > 1 )); then
        indices=("${indices[@]:1}")
    fi

    echo "${indices[*]}"
    return "$(( "${indices[0]}" == -1 ))"
}
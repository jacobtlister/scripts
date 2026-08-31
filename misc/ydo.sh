#!/bin/bash
# File: ydo.sh

: <<'info'
    required packages
        ydotool

    description
        a wrapper of ydotool to make it more convenient to use by
        making it so that you can input a string containing your
        (modified) keystroke to perform

        accepts at most 4 key presses in a modified keystroke

        $1: string which is the modified keystroke to press
        $2: key delay (default 12msec, matching ydotool defaults)
info

# NOTE: you only need to source function scripts and jaliases in
# the highest-level script. all child processes of thehighest level
# script calls will have access to what it sources unless the child
# is ran in a new/different shell instance

# to allow calling aliases from ~/.jaliases in the script
shopt -s expand_aliases
source "${HOME}/.jaliases"

# to allow calling functions from the scripts repo in the script
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

mkey_in="${1// /}"

# key press delay, default value is 12msec to match ydotool
delay=$(( ${2:-12} ))

# variables to store each keycode as an integer
code1=$(( 0 ))
code2=$(( 0 ))
code3=$(( 0 ))
code4=$(( 0 ))

declare -a keys

# i do the < <(...) at the end instead of <<< "${mkey_in}"
# to stop a newline from being appended to keys
readarray -d '+' -t keys < <(printf '%s' "${mkey_in}")

if [[ ${#keys[@]} == 1 ]]; then
    code1=$(( $(keycode "${keys[0]}") + 0 ))

    ydotool key --key-delay $delay $code1:1 $code1:0

elif [[ ${#keys[@]} == 2 ]]; then
    code1=$(( $(keycode "${keys[0]}") + 0 ))
    code2=$(( $(keycode "${keys[1]}") + 0 ))

    ydotool key --key-delay $delay $code1:1 $code2:1 $code1:0 $code2:0

elif [[ ${#keys[@]} == 3 ]]; then
    code1=$(( $(keycode "${keys[0]}") + 0 ))
    code2=$(( $(keycode "${keys[1]}") + 0 ))
    code3=$(( $(keycode "${keys[2]}") + 0 ))

    ydotool key --key-delay $delay $code1:1 $code2:1 $code3:1 $code1:0 $code2:0 $code3:0

elif [[ ${#keys[@]} == 4 ]]; then
    code1=$(( $(keycode "${keys[0]}") + 0 ))
    code2=$(( $(keycode "${keys[1]}") + 0 ))
    code3=$(( $(keycode "${keys[2]}") + 0 ))
    code4=$(( $(keycode "${keys[3]}") + 0 ))

    ydotool key --key-delay $delay $code1:1 $code2:1 $code3:1 $code4:1 $code1:0 $code2:0 $code3:0 $code4:0

else
    echo "invalid number of key presses in the modified keystroke"
    echo "modified keystrokes must have at least 1 and no more than 4 keys pressed simultaneously"
    exit 1
fi
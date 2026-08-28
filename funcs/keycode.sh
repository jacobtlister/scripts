#!/bin/bash
# File: keycode.sh

: <<'info'
    required packages
        none

    description
        Given an inputted key, output the associated keycode as defined in:
            /usr/include/linux/input-event-codes.h

        this function was made to make using the ydotool command easier, as this allows you
        to not have to memorize/dig through the header file to find a given keycode

        only standard labels on a us english keyboard are defined in the dictionary
info

# because this lives in /funcs/, cannot just source all in
# scripts/funcs/, else recursion. instead, just source what's needed
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
source "${SCRIPTS_PATH}/funcs/search.sh"

# declare the associative array (dictionary)
declare -A keycodes

keycodes["0"]=11
keycodes["1"]=2
keycodes["2"]=3
keycodes["3"]=4
keycodes["4"]=5
keycodes["5"]=6
keycodes["6"]=7
keycodes["7"]=8
keycodes["8"]=9
keycodes["9"]=10

keycodes["kp0"]=82
keycodes["kp1"]=79
keycodes["kp2"]=80
keycodes["kp3"]=81
keycodes["kp4"]=75
keycodes["kp5"]=76
keycodes["kp6"]=77
keycodes["kp7"]=71
keycodes["kp8"]=72
keycodes["kp9"]=73

keycodes["kpminus"]=74
keycodes["kpplus"]=78
keycodes["kpplusminus"]=118
keycodes["kpequal"]=117
keycodes["kpasterisk"]=55
keycodes["kpslash"]=98
keycodes["kpdot"]=83
keycodes["kpperiod"]=83
keycodes["kpenter"]=96

keycodes["a"]=30
keycodes["b"]=48
keycodes["c"]=46
keycodes["d"]=32
keycodes["e"]=18
keycodes["f"]=33
keycodes["g"]=34
keycodes["h"]=35
keycodes["i"]=23
keycodes["j"]=36
keycodes["k"]=37
keycodes["l"]=38
keycodes["m"]=50

keycodes["n"]=49
keycodes["o"]=24
keycodes["p"]=25
keycodes["q"]=16
keycodes["r"]=19
keycodes["s"]=31
keycodes["t"]=20
keycodes["u"]=22
keycodes["v"]=47
keycodes["w"]=17
keycodes["x"]=45
keycodes["y"]=21
keycodes["z"]=44

keycodes["space"]=57

keycodes["grave"]=41
keycodes["minus"]=12
keycodes["equals"]=13
keycodes["lbrace"]=26
keycodes["rbrace"]=27
keycodes["backslash"]=43
keycodes["semicolon"]=39
keycodes["apostrophe"]=40
keycodes["comma"]=51

keycodes["dot"]=52
keycodes["period"]=52

keycodes["slash"]=53

keycodes["up"]=103
keycodes["down"]=108
keycodes["left"]=105
keycodes["right"]=106

keycodes["ctrl"]=29
keycodes["lctrl"]=29
keycodes["rctrl"]=97

keycodes["fn"]=464

keycodes["shift"]=42
keycodes["lshift"]=42
keycodes["rshift"]=54

keycodes["meta"]=125
keycodes["lmeta"]=125
keycodes["rmeta"]=126

keycodes["alt"]=56
keycodes["lalt"]=56
keycodes["ralt"]=100

keycodes["esc"]=1
keycodes["escape"]=1

keycodes["print"]=210
keycodes["prtsc"]=210

keycodes["sysrq"]=99

keycodes["home"]=102
keycodes["end"]=107

keycodes["ins"]=110
keycodes["insert"]=110

keycodes["del"]=111
keycodes["delete"]=111

keycodes["pgup"]=104
keycodes["pgdn"]=109

keycodes["backspace"]=14
keycodes["numlock"]=69
keycodes["scrolllock"]=70
keycodes["tab"]=15

keycodes["caps"]=58
keycodes["capslock"]=58

keycodes["enter"]=28

keycodes["f1"]=59
keycodes["f2"]=60
keycodes["f3"]=61
keycodes["f4"]=62

keycodes["f5"]=63
keycodes["f6"]=64
keycodes["f7"]=65
keycodes["f8"]=66

keycodes["f9"]=67
keycodes["f10"]=68
keycodes["f11"]=87
keycodes["f12"]=88

keycodes["f13"]=183
keycodes["f14"]=184
keycodes["f15"]=185
keycodes["f16"]=186

keycodes["f17"]=187
keycodes["f18"]=188
keycodes["f19"]=189
keycodes["f20"]=190

keycodes["f21"]=191
keycodes["f22"]=192
keycodes["f23"]=193
keycodes["f24"]=194

# $1 - string with a key we want the keycode of
keycode() {
    # if lowercase version of $1 is not a valid key label exit with error
    if ! search "${1,,}" "${!keycodes[*]}" &> /dev/null; then
        echo "${1,,} is an invalid key label"
        exit 1
    fi

    echo "${keycodes["${1,,}"]}"
    return 0
}
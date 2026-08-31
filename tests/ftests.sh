#!/bin/bash
# File: ftests.sh

: <<'info'
    required packages
        varies depending on test

    description
        function definitions for each test i've made

        this script has no real purpose other than for me to experiment. this isn't really meant
        to be used, more so to run and see the outputs for me to learn about certain shell features.
        this is also for me to experiment with fixes that shellcheck recommends.

        each test is made into its own function, what tests you run are based on input arguments

        if i am testing a shellcheck recommmendation / fix, I will include the specific SC
        number in the comment above the code
info

# messing with https://www.shellcheck.net/wiki/SC2219
test000() {
    b=10

    printf "%s " $b

    # adds 5 to b and always succeeds
    (( b=b+5 )) || true

    printf "%s " $b

    # adds 5 to b and always succeeds
    (( b=b+5 )) || true

    printf "%s " $b

    echo
}

# messing with https://www.shellcheck.net/wiki/SC2045
test001() {
    # prints all files (with or without extensions) and directories in present working directory
    for file in *; do
        [[ -e "$file" ]] || break  # handle the case of no files

        echo "$file"
    done

    echo

    # prints all .doc* files in pwd
    for file in *.doc*; do
        [[ -e "$file" ]] || break  # handle the case of no files

        echo "$file"
    done

    echo

    # prints all .ppt* files in pwd
    for file in *.ppt*; do
        [[ -e "$file" ]] || break  # handle the case of no files

        echo "$file"
    done
}

# printing certain lines from a file using sed
test002() {
    # how to print out a single line from a file
    sed -n "1,1p" template.sh

    # how to print out one range of lines from a file
    sed -n "1,3p" template.sh

    # how to print out multiple ranges of lines from a file
    sed -n "1,3p; 15,18p" template.sh
}

# testing how to print newlines with echo
test003() {
    nl=$'\n'

    echo "using variable with newline character stored in it"
    echo "a${nl}a"

    echo "using echo -e"
    echo -e "a\na"

    echo "using ANSI-C quoting"
    echo $'a\na'

    echo "using printf"
    printf "a\na\n"

    echo "using custom print function"
    print "a\na"
}


test004() {
    # get number of spaces in a string
    # also a little experiment i did with piping
    # referenced https://unix.stackexchange.com/a/246904 for the command in numberOfSpaces
    # inputs: 1 string
    # outputs: 1, the value of how many spaces were in the inputted string
    numberOfSpaces() {
        echo "$1" | head -n 1 | tr -cd " " | wc -m
    }

    # has 9 spaces in it
    string="hj sjfd hjdfsj hk df hjk g hk jkh a"

    num=$(numberOfSpaces "${string}")

    echo "${num}"
    numberOfSpaces "one two  three"

    # unset locally defined function because this is not done when leaving a function
    unset -f numberOfSpaces
}

# messing with for loops
test005() {
    a=""
    b=5

    echo "${a}"

    for i in $(seq 1 1 ${b}); do
        a+="${i}"
        echo "${a}"
    done
}

# /dev/null outputting (into the void he goes)
test006() {
    echo hi >  /dev/null
}

# get application that is the default FileManager in exo-open
test007() {
    filemanager="$(xdg-mime query default inode/directory)"
    filemanager="${filemanager%.*}"
    filemanager="${filemanager##*.}"

    echo "${filemanager}"
}

# # placeholder
# test008() {
#     echo "placeholder"
# }

# # placeholder
# test009() {
#     echo "placeholder"
# }

# brief explanation of test
# test0() {
    # echo "placeholder"
# }
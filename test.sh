#!/bin/bash
# File: test.sh
# this script has no real purpose other than for me to experiment
# this isn't really meant to be used, more so to run and see the outputs for me to learn about certain shell features
# this is also for me to experiment with fixes that shellcheck recommends

<<'notes'
    required packages
        various (in comments above each experiment if needed)

    additional notes
        if i am testing a shellcheck recommmendation / fix, I will include the specific SC number in the comment above the code
notes

# code starts here --------------------------------------------------------------------------------

# messing with https://www.shellcheck.net/wiki/SC2219
b=15
echo "$b"

(( b=b+5 )) || true
echo "$b"
echo

# messing with https://www.shellcheck.net/wiki/SC2045

# prints all files (with or without extensions) and directories in current directory
for file in *; do
    [[ -e "$file" ]] || break  # handle the case of no files

    echo "$file"
done

# how to print out a single line from a file
sed -n "1,1p" test.sh

# how to print out one range of lines from a file
sed -n "1,3p" test.sh

# how to print out multiple ranges of lines from a file
sed -n "1,3p; 7,9p" test.sh

# newline
nl=$'\n'

echo "a$nl""a"

# to get final line in a file or command output, pipe it into tail -1, ie command | tail -1
# simalarly, piping something into head -1 shows the first line

# check whether a certain string appears in a file or string, returns true if there is a match
# [[ -n $(grep -n "forawdawdwadawd" makealiases.sh) ]]

# get number of spaces in a string
# also a little experiment i did with piping
# referenced https://unix.stackexchange.com/a/246904 for the command in numberOfSpaces
numberOfSpaces() {
    # i know printf directly with variables is poor form, but I want to retain newlines
    echo "$(printf "${@}" | head -n 1 | tr -cd " " | wc -m)"
}

string="hj sjfd hjdfsj hk df hjk g hk jkh a"
num=5
numberOfSpaces ${string} >> num
echo "${num}"

# messing with for loops
a=""
b=5

echo $a

for i in $(seq 1 1 ${b}); do
    a+="${i}"
    echo $a
done

# /dev/null outputting (into the void he goes)
echo hi >  /dev/null
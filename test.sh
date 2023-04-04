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
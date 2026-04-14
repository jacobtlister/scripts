#!/bin/bash
# File: setupjaliases.sh

: <<'info'
    required packages
        mlocate

    description
        copies .jaliases to ~/ and has the copy be sourced in ~/.bashrc

        elevated privileges are needed to run updatedb

        by default, updatedb does not search anywhere in /media, to fix this, remove
        /media from the PRUNEPATHS variable in /etc/updatedb.conf

        once you run this script, you should reload/reopen any open terminals for
        effects to fully take place
info

# update file database for locate command
echo "updating file database..."
sudo updatedb

# get path to scripts repository
path="$(locate /scripts/setup/setup | head -n 1)"
path="${path%/setup/*}"

echo "scripts repository path is: ${path}"

# inserts \ before any / in path for use in a sed command
sedpath="${path//\//\\/}"

# make a copy of .jaliases in ~/
# update ~/.jaliases if it already exists
cp "${path}/setup/.jaliases_template" ~/.jaliases
sed -i "5s/\/path\/to\/scripts/${sedpath}/" ~/.jaliases

# check if .jaliases is already sourced in ~/.bashrc. do this to check exit
# code later; grep returns 1 if the inputted string is not found, 0 if found
grep "\. ~/.jaliases" ~/.bashrc > /dev/null

# source .jaliases in ~/.bashrc if its not already
if [ $? == 1 ]; then
    cat "${path}/setup/bashrc_jaliases_append.txt" >> ~/.bashrc
    echo "placed .jaliases source statement in ~/.bashrc"
    echo "copied .jaliases to ~/"
else
    echo ".jaliases already sourced in ~/.bashrc"
    echo "updated ~/.jaliases"
fi

# reload shell in the current terminal to save you a bit of time
# shellcheck source=/dev/null
. ~/.bashrc

#!/bin/bash
# File: setupjaliases.sh

: <<'info'
    required packages
        mlocate

    description
        sets up .jaliases file (sets path variable) and adds this file to
        the .bashrc in the home directory

        elevated privileges are needed to run updatedb

        by default, updatedb does not add anything in /media to the database,
        to fix this, remove /media from the PRUNEPATHS variable in /etc/updatedb.conf

        once you run this script you should reload/reopen any open terminals
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

# make a version of .jaliases in home directory
# update it if the file is already there
cp "${path}/setup/.jaliases_template" ~/.jaliases
sed -i "5s/\/path\/to\/scripts/${sedpath}/" ~/.jaliases

# check if .jaliases is already added to .bashrc. do this to check exit code
# late. grep returns 1 if the inputted string is not found, 0 if found
grep "alias definitions for jacob's scripts repository" ~/.bashrc > /dev/null

# add .jaliases to .bashrc if its not already in .bashrc
if [ $? == 1 ]; then
    cat "${path}/setup/bashrc_jaliases_append.txt" >> ~/.bashrc
    echo "placed .jaliases include statement in ~/.bashrc"
    echo "placed .jaliases in the home directory"
else
    echo ".jaliases already included in ~/.bashrc"
    echo "updated ~/.jaliases"
fi

# reload shell
exec "$BASH"

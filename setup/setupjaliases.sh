#!/bin/bash
# File: setupjaliases.sh

: <<'info'
    required packages
        mlocate

    description
        places .jaliases     in ~/ and has the copy be sourced in ~/.bashrc

        places .shellcheckrc in ~/

        while elevated privileges are needed to run updatedb, **do not run the entire
        script with elevated priveleges**, or it will not work correctly!

        by default, updatedb does not search anywhere in /media, to fix this, remove
        /media from the PRUNEPATHS variable in /etc/updatedb.conf

        once you run this script, you should reload/reopen any open terminals for
        effects to fully take place
info

if [ "$SCRIPTS_PATH" == "" ]; then
    # update file database for locate command
    echo "updating file database..."
    sudo updatedb

    # get path to each repository
    path1="$(locate /scripts/setup/setup | head -n 1)"
    path1="${path1%/setup/*}"
    path2="$(locate /latex-projects/jatex | head -n 1)"
    path2="${path2%/setup/*}"
    path3="$(locate /jatexstudio/reup | head -n 1)"
    path3="${path3%/setup/*}"

    echo "scripts        repository path is: ${path1}"
    echo "latex-projects repository path is: ${path2}"
    echo "jatexstudio    repository path is: ${path3}"

    # inserts \ before any / in path for use in a sed command
    sedpath1="${path1//\//\\/}"
    sedpath2="${path2//\//\\/}"
    sedpath3="${path3//\//\\/}"

    # place .jaliases in ~/
    # update ~/.jaliases if it already exists
    cp "${path1}/setup/.jaliases_template" ~/.jaliases
    sed -i "5s/\/path\/to\/scripts/${sedpath1}/" ~/.jaliases
    sed -i "6s/\/path\/to\/latex-projects/${sedpath2}/" ~/.jaliases
    sed -i "7s/\/path\/to\/jatexstudio/${sedpath3}/" ~/.jaliases

    # place .shellcheckrc in ~/
    cp "${path1}/setup/.shellcheckrc_template" ~/.shellcheckrc

# if ${SCRIPTS_PATH} is defined (ie .jaliases exists or existed some point recently)
# just use the pre-existing ${SCRIPTS_PATH} value instead of updating the database
# and searching for the path to the scripts repo
else
    # inserts \ before any / in path for use in a sed command
    sedpath1="${SCRIPTS_PATH//\//\\/}"
    sedpath2="${LATEX_PROJECTS_PATH//\//\\/}"
    sedpath3="${JATEXSTUDIO_PATH//\//\\/}"

    # make a copy of .jaliases in ~/
    # update ~/.jaliases if it already exists
    cp "${SCRIPTS_PATH}/setup/.jaliases_template" ~/.jaliases
    sed -i "5s/\/path\/to\/scripts/${sedpath1}/" ~/.jaliases
    sed -i "6s/\/path\/to\/latex-projects/${sedpath2}/" ~/.jaliases
    sed -i "7s/\/path\/to\/jatexstudio/${sedpath3}/" ~/.jaliases

    # place .shellcheckrc in ~/
    cp "${SCRIPTS_PATH}/setup/.shellcheckrc_template" ~/.shellcheckrc
fi

# check if .jaliases is already sourced in ~/.bashrc. do this to check exit
# code later; grep returns 1 if the inputted string is not found, 0 if found
grep "\. ~/.jaliases" ~/.bashrc > /dev/null

# source .jaliases in ~/.bashrc if its not already
if [ $? == 1 ]; then
    path1="$(locate /scripts/setup/setup | head -n 1)"
    path1="${path1%/setup/*}"

    cat "${path1}/setup/bashrc_jaliases_append.txt" >> ~/.bashrc
    echo "placed .jaliases source statement in ~/.bashrc"
    echo "placed .jaliases in ~/"
    echo "placed .shellcheckrc in ~/"
else
    echo ".jaliases already sourced in ~/.bashrc"
    echo "updated ~/.jaliases"
    echo "updated ~/.shellcheckrc"
fi

# reload shell in the current terminal to save you a bit of time
# shellcheck source=/dev/null
. ~/.bashrc

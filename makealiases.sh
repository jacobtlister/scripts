#!/bin/bash
# File: makealiases.sh

: <<info
    description
        creates aliases for ALL .sh scripts in the current working directory

    required packages
        sed (apt)

    additional notes
        this script assumes you have a .bashrc file in your home directory

        if used in the future it will make sure not to add duplicate aliases and keep old aliases

        this script assumes that the name of the file will also be the alias name (name your scripts well!)
info

# code starts here --------------------------------------------------------------------------------

endline=$(sed -n "\$,\$p" "$HOME"/.bashrc)

if [[ "$endline" != "# Aliases created by makealiases.sh" ]]; then
    # this inserts a blank line at the end of .bashrc
    # why does this work, this is disgusting
    sed -i "$ a
" "$HOME/.bashrc"

    sed -i "$ a # Aliases created by makealiases.sh" "$HOME/.bashrc"

    for sh in *.sh; do
        [[ -e "$sh" ]] || break  # handle the case of no scripts

        # format for an alias is
        #     alias name="command"
        sed -i "\$ a alias ${sh%.*}=\"$(pwd)/$sh\"" "$HOME/.bashrc"
    done

    sed -i "$ a # Aliases created by makealiases.sh" "$HOME/.bashrc"

else
    # assumes that you have not typed this string anywhere else in your .bashrc file
    alias_start=$(grep -n "# Aliases created by makealiases.sh" "$HOME"/.bashrc | head -1 | cut -d":" -f1)
    (( start=alias_start+1 ))

    alias_end=$(grep -n "# Aliases created by makealiases.sh" "$HOME"/.bashrc | tail -1 | cut -d":" -f1)
    (( end=alias_end-1 ))

    # put already stored aliases in a temporary text file
    sed -n "$start,$end p" "$HOME"/.bashrc >> aliases.txt

    # delete aliases and end line from .bashrc
    sed -i "$start,$alias_end d" "$HOME"/.bashrc

    for sh in *.sh; do
        if [[ -z $(grep -n "alias ${sh%.*}=\"$(pwd)/$sh\"" aliases.txt) ]]; then
            sed -i "\$ a alias ${sh%.*}=\"$(pwd)/$sh\"" "$HOME/.bashrc"
        fi
    done

    # read through each line of aliases.txt (SC 2013, linked in resources.md)
    grep -v '^ *#' < "aliases.txt" | while IFS= read -r sh; do
        sed -i "\$ a $sh" "$HOME/.bashrc"
    done

    rm -f aliases.txt

    sed -i "$ a # Aliases created by makealiases.sh" "$HOME/.bashrc"
fi
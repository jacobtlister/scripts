#!/bin/bash
# File: pdfmerge.sh
#

: <<info
    description
        merges pdfs using ghostscript and deletes original pdfs afterwards

    required packages
        ghostscript (apt)

    additional notes
        there are different behaviors depending on the amount of command line arguments included,
            0 - merges and deletes all pdfs in the current working directory into merged.pdf
            1 - merges and deletes all pdfs in the current working directory into a pdf named based on the argument provided*
                    an example is
                        pdfmerge custom_name.pdf
            n - merges and deletes pdf files in the first n - 1 arguments into a pdf named based on the nth argument provided
                    an example is
                        pdfmerge file1.pdf file2.pdf ... filen-1.pdf output.pdf


        *if -h or --help is the command line argument then this explanation and extra info will be printed instead
info

# sources all scripts in the utils directory of scripts
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "$HOME/scripts/utils"/*.sh; do source "${f}"; done

if [ $# == 0 ]; then
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=merged.pdf ./*.pdf
    cp merged.pdf /tmp
    rm -f ./*.pdf
    cp /tmp/merged.pdf ./
    rm -f /tmp/merged.pdf

elif [ $# == 1 ]; then
    if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
        print "this script merges pdfs using ghostscript and deletes original pdfs afterwards\n\n"

        print "there are different behaviors depending on the amount of command line arguments included\n\n"

        print "    0 - merges and deletes all pdfs in the current working directory into merged.pdf\n\n"

        print "    1 - merges and deletes all pdfs in the current working directory into a pdf named based on the argument provided\n"
        print "            an example is\n"
        print "                pdfmerge custom_name.pdf\n\n"

        print "    n - merges and deletes pdf files in the first n - 1 arguments into a pdf named based on the nth argument provided\n"
        print "            an example is\n"
        print "                pdfmerge file1.pdf file2.pdf ... filen-1.pdf output.pdf\n"

    else
        gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite "-sOutputFile=${1}" ./*.pdf
        cp "${1}" /tmp
        rm -f ./*.pdf
        cp "/tmp/${1}" ./
        rm -f "/tmp/${1}"
    fi

else
    # make an array from command line args and remove final entry
    args=("${@}")
    unset "args[(($#-1))]"

    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite "-sOutputFile=${!#}" "${args[@]}"
    cp "${!#}" /tmp
    rm -f "${args[@]}"
    cp "/tmp/${!#}" ./
    rm -f "/tmp/${!#}"
fi

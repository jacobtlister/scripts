#!/bin/bash
# File: pdfmerge.sh

: <<'info'
    required packages
        ghostscript

    description
        merges pdfs using ghostscript and deletes original pdfs afterwards

        there are different behaviors depending on the amount of command line arguments:
            0 - merges into merged.pdf and deletes all pdf files in the pwd
            1 - merges into a pdf and deletes all pdf files in the pwd. output filename
                based on the argument provided
            n - merges into a pdf and deletes pdf files based on the last n-1 arguments.
                output name based on the 1st argument provided

        some examples of running this script are shown below:
            bash pdfmerge.sh
            bash pdfmerge.sh outname.pdf
            bash pdfmerge.sh outname.pdf file1.pdf file2.pdf file3.pdf
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

if [[ $# == 0 ]]; then
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=merged.pdf ./*.pdf
    cp merged.pdf /tmp
    rm -f ./*.pdf
    cp /tmp/merged.pdf ./
    rm -f /tmp/merged.pdf
elif [[ $# == 1 ]]; then
    if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
        print "merges pdfs using ghostscript and deletes original pdfs afterwards\n\n"

        print "there are different behaviors depending on the amount of command line arguments:"
        print "0 - merges into merged.pdf and deletes all pdf files in the pwd" 4
        print "1 - merges into a pdf and deletes all pdf files in the pwd. output filename based on the argument provided" 4
        print "n - merges into a pdf and deletes pdf files based on the last n-1 arguments. output name based on the 1st argument provided\n\n" 4

        print "some examples of running this script are shown below:"
        print "bash pdfmerge.sh" 4
        print "bash pdfmerge.sh outname.pdf" 4
        print "bash pdfmerge.sh outname.pdf file1.pdf file2.pdf file3.pdf" 4
    else
        gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite "-sOutputFile=${1}" ./*.pdf
        cp "${1}" /tmp
        rm -f ./*.pdf
        cp "/tmp/${1}" ./
        rm -f "/tmp/${1}"
    fi
else
    args=("${@}")
    outname="${args[0]}"

    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite "-sOutputFile=${outname}" "${args[@]:1}"
    cp "${outname}" /tmp
    rm -f "${args[@]}"
    cp "/tmp/${outname}" ./
    rm -f "/tmp/${outname}"
fi

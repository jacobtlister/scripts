#!/bin/bash
# File: pdfmerge.sh
# merges pdfs using ghostscript and deletes original pdfs afterwards

<<'notes'
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
notes

# print() --------------------------------------------------------------------------------------------------------
#     print(): a custom function for word - wrapped, indented printing
#     inputs : string to print, amounts of spaces to additionally indent (optional, final argument)
#     outputs: none
#
#     example of different calls,
#         print "hello world"      => hello world
#
#         print "hello\nworld"     => hello
#                                     world
#
#         print "  hello world"    =>   hello world
#
#         print "  hello\nworld"   =>   hello
#                                           world
#
#         print "  hello\nworld" 2 =>   hello
#                                         world
#
#     extra notes
#       not using fmt because when you do fmt -t it indents only 3 spaces (bad and gross and mean)
#       the indent used is one of 2 things,
#           if the first line has no leading whitespace, the indent is 0
#           otherwise, the indent is 4 spaces + indent amount (default 4)
print() {
    # leadingSpaces=-1 and use check later to make sure to not reassign value
    leadingSpaces=-1
    spaces=""

    if [ "${leadingSpaces}" == -1 ]; then
        # this line get the number of leading spaces for the string
        leadingSpaces=$(echo "${1}" | head -n 1 | awk '{ match($0, /^ */); printf("%d", RLENGTH) }')
    fi

    if [ "${leadingSpaces}" != 0 ]; then
        if [ "${#}" == 1 ]; then
            (( leadingSpaces=leadingSpaces+4 ))

        else
            (( leadingSpaces=leadingSpaces+"${2}" ))
        fi
    fi

    for i in $(seq 1 1 "${leadingSpaces}"); do
        spaces+=" "
    done

    # i know printf directly with variables is poor form (SC2059), but I want to retain newlines so i must
    printf "${1}" | fold -s | awk -v spaces="${spaces}" '{ if ( NR == 1 ) { print $0 } else { print spaces $0 } }'
}

# print() end ----------------------------------------------------------------------------------------------------

# code starts here -----------------------------------------------------------------------------------------------

if [ $# == 0 ]; then
    echo hi
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

        print "hello world\n"
        print "hello\nworld\n"
        print "  hello world\n"
        print "  hello\nworld\n"
        print "  hello\nworld\n" 2

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
#!/bin/bash
# File: topdf.sh

: <<'info'
    description
        converts .doc* and .ppt* files to pdfs and deletes the original files (converted files keep their names)

    required packages
        libreoffice (apt)

    additional notes
        there are different behaviors depending on the amount of command line arguments included,
            0 - converts and deletes all valid files in the current working directory into pdfs (same filename)
            n - converts files from the command line arguments into pdfs (same filename)

        if -h or --help is the command line argument then this explanation and extra info will be printed instead
info

# sources all scripts in the utils directory of scripts
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "$HOME/scripts/utils"/*.sh; do source "${f}"; done

if [ $# == 0 ]; then
    libreoffice --convert-to pdf ./*.doc* ./*.ppt*
    rm -f ./*.doc* ./*.ppt*

# for why the elif is structured the way it is, reference SC1028 https://www.shellcheck.net/wiki/SC1028
# else if($# == 1 && ("${1}" == "-h" ] || [ "${1}" == "--help"))
elif [ $# == 1 ] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
    print "this script converts .doc* and .ppt* files to pdfs and deletes the original files (converted files keep their names)\n\n"

    print "there are different behaviors depending on the amount of command line arguments included\n\n"

    print "    0 - converts and deletes all valid files in the current working directory into pdfs (same filename)\n\n"

    print "    n - converts files from the command line arguments into pdfs (same filename)\n"
    print "            an example is\n"
    print "                topdf file1.docx file2.doc file3.pptx file4.doc ...\n"

else
    libreoffice --convert-to pdf "${@}"
    rm -f "${@}"
fi
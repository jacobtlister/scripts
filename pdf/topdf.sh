#!/bin/bash
# File: topdf.sh

: <<'info'

    required packages
        libreoffice

    description
        converts doc* and ppt* files to pdf files and deletes the original files;
        converted files keep their names

        there are different behaviors depending on the amount of command line arguments:
            0 - converts to pdf and deletes all valid files in the pwd
            n - converts and deletes files based on the arguments provided

        some examples of running this script are shown below:
            bash topdf.sh
            bash topdf.sh *.ppt
            bash topdf.sh *.doc*
            bash topdf.sh file1.docx file2.ppt file3.pptx file4.doc
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

if [ $# == 0 ]; then
    libreoffice --convert-to pdf ./*.doc* ./*.ppt*
    rm -f ./*.doc* ./*.ppt*
elif [ $# == 1 ] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
    print "converts doc* and ppt* files to pdf files and deletes the original files; converted files keep their names\n\n"

    print "there are different behaviors depending on the amount of command line arguments:"
    print "0 - converts to pdf and deletes all valid files in the pwd" 4
    print "n - converts and deletes files based on the arguments provided\n\n" 4

    print "some examples of running this script are shown below:"
    print "bash topdf.sh" 4
    print "bash topdf.sh *.ppt" 4
    print "bash topdf.sh *.doc*" 4
    print "bash topdf.sh file1.docx file2.ppt file3.pptx file4.doc" 4
else
    libreoffice --convert-to pdf "${@}"
    rm -f "${@}"
fi
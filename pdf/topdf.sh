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

# NOTE: you only need to source function scripts and jaliases in
# the highest-level script. all child processes of thehighest level
# script calls will have access to what it sources unless the child
# is ran in a new/different shell instance

# to allow calling aliases from ~/.jaliases in the script
shopt -s expand_aliases
source "${HOME}/.jaliases"

# to allow calling functions from the scripts repo in the script
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

if [[ $# == 0 ]]; then
    # shellcheck disable=SC2035
    libreoffice --convert-to 'pdf:writer_pdf_Export' *.doc*

    # shellcheck disable=SC2035
    libreoffice --convert-to 'pdf:impress_pdf_Export:{"ExportHiddenSlides":{"type":"boolean","value":"true"}}}' *.ppt*

    rm -f ./*.doc* ./*.ppt*
elif [[ $# == 1 ]] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
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
    for file in "${@}"; do
        extension="${file##*.}"    # gets everything after last '.' (normally the whole file extension)
        extension="${extension,,}" # converts the entire string to lower case (for easier comparisons)

        if [[ "${extension}" == "doc" ]] || [[ "${extension}" == "docx" ]]; then
            libreoffice --convert-to 'pdf:writer_pdf_Export' "${file}"
            rm -f "${file}"
        elif [[ "${extension}" == "ppt" ]] || [[ "${extension}" == "pptx" ]]; then
            libreoffice --convert-to 'pdf:impress_pdf_Export:{"ExportHiddenSlides":{"type":"boolean","value":"true"}}}' "${file}"
            rm -f "${file}"
        else
            libreoffice --convert-to pdf "${file}"
            rm -f "${file}"
        fi
    done
fi

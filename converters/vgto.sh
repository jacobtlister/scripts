#!/bin/bash
# File: vgto.sh

: <<'info'
    required packages
        inkscape
        poppler-utils
        imagemagick

    description
        converts vector graphics files to a variety of different filetypes; converted
        files keep their original filenames

        valid  input types are: [svg eps pdf]
        valid output types are: [svg eps pdf png jpg]

        there are different behaviors depending on the amount of command line arguments included,
            0 - converts all svg files in the pwd into eps files
            1 - converts all svg files in the pwd into a user-inputted filetype
            2 - if both arguments are image types, converts all arg1 files in the pwd into arg2 files
            n - converts the last n-1 argument vector graphics files into a user-inputted filetype

        some examples of running this script are shown below:
            bash vgto.sh
            bash vgto.sh png
            bash vgto.sh pdf png
            bash vgto.sh pdf file1.svg file2.svg file3.eps
            bash vgto.sh jpg file1.svg file2.eps file3.eps file4.pdf

        the following link was a very helpful resource when developing this script:
            https://wiki.inkscape.org/wiki/index.php/Using_the_Command_Line
info

# to-do
# if converting to .jpg, use pdftoppm if input is a pdf and convert if input is a svg/eps
# create command version that allows custom input filetype as well

# sources all functions in /scripts/funcs/
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

outputextensions=(".svg" ".eps" ".pdf" ".png" ".jpg")

if [[ $# == 0 ]]; then
    inkscape --export-type=eps --export-ignore-filters --export-background-opacity=0.0 --export-dpi=600 --export-text-to-path --export-margin=0 ./*.svg
elif [[ $# == 1 ]]; then
    if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
        print "converts vector graphics files to a variety of different filetypes; converted files keep their original filenames\n\n"

        print "valid input  types are: [svg eps pdf]\n"
        print "valid output types are: [svg eps pdf png jpg]\n\n"

        print "there are different behaviors depending on the amount of command line arguments:\n"
        print "0 - converts all .svg files in the pwd into .eps files\n" 4
        print "1 - converts all .svg files in the pwd into a user-inputted filetype\n" 4
        print "n - converts the last n-1 argument vector image files into a user-inputted filetype\n\n" 4

        print "some examples of running this script are shown below:\n"
        print "bash vgto.sh\n" 4
        print "bash vgto.sh png\n" 4
        print "bash vgto.sh png file1.svg file2.eps file3.svg file4.pdf" 4

    else
        # if output type is invalid (exit code of search = 1), end the script early
        if ! search "${1}" "${outputextensions[*]}" &> /dev/null; then
            print "invalid export type\n"
            print "valid export types are: [svg, eps, pdf, png, jpg]"
            exit 1
        fi

        if [[ "${1}" == "png" ]]; then
            # default export dpi is 96, which is 1:1 for pixel dims of svg to dims of png
            # so to make it look a little better, upscale by 6x (~600dpi)
            dpi=$(( 96 * 6 ))
            opacity=1
        else
            dpi=600
            opacity=0
        fi

        inkscape --export-type="${1}" --pdf-poppler --export-ignore-filters --export-background-opacity="${opacity}" --export-dpi="${dpi}" --export-text-to-path --export-margin=0 ./*.svg
    fi

else
    # if output type is invalid (exit code of search = 1), end the script early
    if ! search "${1}" "${outputextensions[*]}" &> /dev/null; then
        print "invalid export type\n"
        print "valid export types are: [svg, eps, pdf, png, jpg]"
        exit 1
    fi

    if [[ "${1}" == "png" ]]; then
        # default export dpi is 96, which is 1:1 for pixel dims of svg to dims of png
        # so to make it look a little better, upscale by 6x (~600dpi)
        dpi=$(( 96 * 6 ))
        opacity=1
    else
        dpi=600
        opacity=0
    fi

    for arg in "${@:2:$#}"; do
        inkscape --export-type="${1}" --pdf-poppler --export-ignore-filters --export-background-opacity="${opacity}" --export-dpi="${dpi}" --export-text-to-path --export-margin=0 "${arg}"
    done
fi

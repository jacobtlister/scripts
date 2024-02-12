#!/bin/bash
# File: pngtopdf.sh

: <<'info'
    description
        coverts all images (from a preset list) in the working directory into pdfs and afterwards deletes
        all the converted images

    required packages
        ghostscript (apt)

    additional notes
        to be able to use this program, you have to make sure ghostscript has permission to create / edit pdfs
        if the program returns the following error,
            attempt to perform an operation not allowed by the security policy 'PDF'

        use the following guide to fix it (need sudo to edit the policy.xml file)
            https://suay.site/?p=2369

        there are different behaviors depending on the amount of command line arguments included,
            0 - converts and deletes all valid files in the current working directory into pdfs (same filename)
            n - converts files from the command line arguments into pdfs (same filename)

        if -h or --help is the command line argument then this explanation and extra info will be printed instead
info

# sources all scripts in the utils directory of scripts
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "$HOME/scripts/utils"/*.sh; do source "${f}"; done

# array of most common image file extensions I see in daily / common use
imageExtensions=("png" "jpg" "jpeg" "jfif" "svg" "webp")

# Checks if the passed in string matches to one of the entries in image extensions
# ie checks if the string is a valid image file extension (out of most common extensions)
# returns 1 if the passed string is contained in imageExtensions, 0 otherwise
function validExtension {
    local i=0

    # while i < imageExtensions.length
    while [ ${i} -lt ${#imageExtensions[@]} ]; do
        if [ "$extension" = "${imageExtensions[${i}]}" ]; then
            return 1
        fi

        (( i++ )) || true
    done

    return 0
}

if [ $# == 0 ]; then
    for file in *.*; do
        [[ -e "$file" ]] || break  # handle the case of no files

        extension=${file##*.} # gets everything after last '.' (normally the whole file extension)
        extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

        validExtension

        # if exit code of validExtension = 1, perform the conversion
        if [ $? == 1 ]; then
            convert "$file" "${file%.*}.pdf"
            rm -f "$file"
        fi
    done

# for why the elif is structured the way it is, reference SC1028 https://www.shellcheck.net/wiki/SC1028
# else if($# == 1 && ("${1}" == "-h" ] || [ "${1}" == "--help"))
elif [ $# == 1 ] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
    print "this script converts a variety of image formats to pdfs and deletes the original files (converted files keep their names)\n\n"

    print "there are different behaviors depending on the amount of command line arguments included\n\n"

    print "    0 - converts and deletes all valid files in the current working directory into pdfs (same filename)\n\n"

    print "    n - converts files from the command line arguments into pdfs (same filename)\n"
    print "            an example is\n"
    print "                imagetopdf file1.png file2.png file3.jpg ...\n"

else
    for file in "${@}"; do
        extension=${file##*.} # gets everything after last '.' (normally the whole file extension)
        extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

        validExtension

        # if exit code of validExtension = 1, perform the conversion
        if [ $? == 1 ]; then
            convert "$file" "${file%.*}.pdf"
        fi
    done

    rm -f "${@}"

fi
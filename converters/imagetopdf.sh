#!/bin/bash
# File: pngtopdf.sh
# coverts all pngs in the working directory into pdfs and afterwards deletes all pngs

<<'notes'
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
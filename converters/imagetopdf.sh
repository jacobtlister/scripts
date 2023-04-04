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
notes

# code starts here --------------------------------------------------------------------------------

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
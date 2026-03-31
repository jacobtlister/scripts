#!/bin/bash
# File: imagetopdf.sh

: <<'info'
    required packages
        ghostscript

    description
        converts png and jpg files to pdf and deletes the original images; converted files
        keep their original filenames

        to be able to use this script, you have to make sure ghostscript has permission to
        create/edit pdfs. if the script returns the following error:
            attempt to perform an operation not allowed by the security policy 'PDF'

        use the following guide to fix it (need sudo to edit the policy.xml file):
            https://suay.site/?p=2369

        there are different behaviors depending on the amount of command line arguments:
            0 - converts to pdf and deletes all valid files in the pwd
            n - converts and deletes files based on the arguments provided

        some examples of running this script are shown below:
            bash imagetopdf.sh
            bash imagetopdf.sh file.png
            bash imagetopdf.sh file1.png file2.jpg file3.jpg
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

extensions=("png" "jpg" "jpeg")

if [[ $# == 0 ]]; then
    for file in *.*; do
        [[ -e "$file" ]] || break # handle the case of no files

        extension="${file##*.}"    # gets everything after last '.' (normally the whole file extension)
        extension="${extension,,}" # converts the entire string to lower case (for easier comparisons)

        # if extension is valid (exit code of search = 0),
        # perform the conversion and delete original file
        if search "${extension}" "${extensions[*]}" &> /dev/null; then
            convert "${file}" "${file%.*}.pdf"
            rm -f "${file}"
        fi
    done
elif [ $# == 1 ] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
    print "converts png and jpg files to pdf and deletes the original images; converted files keep their original filenames\n\n"

    print "to be able to use this script, you have to make sure ghostscript has permission to create/edit pdfs. if the script returns the following error:"
    print "attempt to perform an operation not allowed by the security policy \'PDF\'\n\n" 4

    print "use the following guide to fix it (need sudo to edit the policy.xml file):"
    print "https://suay.site/?p=2369\n\n" 4

    print "there are different behaviors depending on the amount of command line arguments:"
    print "0 - converts to pdf and deletes all valid files in the pwd" 4
    print "n - converts and deletes files based on the arguments provided\n\n" 4

    print "some examples of running this script are shown below:"
    print "bash imagetopdf.sh" 4
    print "bash imagetopdf.sh file.png" 4
    print "bash imagetopdf.sh file1.png file2.png file3.jpg" 4
else
    for file in "${@}"; do
        extension="${file##*.}"    # gets everything after last '.' (normally the whole file extension)
        extension="${extension,,}" # converts the entire string to lower case (for easier comparisons)

        # if extension is valid (exit code of search = 0),
        # perform the conversion and delete original file
        if search "${extension}" "${extensions[*]}" &> /dev/null; then
            convert "${file}" "${file%.*}.pdf"
            rm -f "${file}"
        fi
    done
fi

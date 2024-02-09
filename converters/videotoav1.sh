#!/bin/bash
# File: videotoav1.sh
# converts all video files in the working directory to AV1 video format

: <<info
    required packages
        ffmpeg (apt)

    additional notes
        referenced the following wikipedia page for the array of file extensions,
            https://en.wikipedia.org/wiki/Video_file_format

        there are different behaviors depending on the amount of command line arguments included,
            0 - converts and deletes all valid files in the current working directory into pdfs (same filename)
            n - converts files from the command line arguments into pdfs (same filename)

        if -h or --help is the command line argument then this explanation and extra info will be printed instead
info

# sources all scripts in the utils directory of scripts
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "$HOME/scripts/utils"/*.sh; do source "${f}"; done

# array which contains many types of video file extensions
videoExtensions=("3g2" "3gp" "amv" "asf" "avi" "drc" "flv" "f4v" "f4p" "f4a" "f4b" "m4v" "mng" "mov" "qt" "mp4" "m4p" "m4v" "mpg" "mpg2" "mpeg" "mpe" "mpv" "m2v" "mts" "m2ts" "ts" "mxf" "nsv" "ogv" "ogg" "rm" "rmvb" "roq" "svi" "viv" "vob" "webm" "wmv" "yuv")

# Checks if the passed in string matches to one of the entries in image extensions
# ie checks if the string is a valid video file extension (out of most common extensions)
# returns 1 if the passed string is contained in imageExtensions, 0 otherwise
function validExtension {
    local i=0

    # while i < imageExtensions.length
    while [ ${i} -lt ${#videoExtensions[@]} ]; do
        if [ "$extension" = "${videoExtensions[${i}]}" ]; then
            return 1
        fi

        (( i++ )) || true
    done

    return 0
}

if [ $# == 0 ]; then
    for file in *.*; do
        extension=${file##*.} # gets everything after last '.' (normally the whole file extension)
        extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

        validExtension

        # if exit code of validExtension = 1, perform the conversion
        if [ $? == 1 ]; then
            ffmpeg -i "$file" -c:v libaom-av1 "${file%.*}.mkv"
            rm -f "$file"
        fi
    done

# for why the elif is structured the way it is, reference SC1028 https://www.shellcheck.net/wiki/SC1028
# else if($# == 1 && ("${1}" == "-h" ] || [ "${1}" == "--help"))
elif [ $# == 1 ] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
    print "this script re - encodes a variety of formats formats to AV1 encoding and deletes the original files (converted files keep their names)\n\n"

    print "there are different behaviors depending on the amount of command line arguments included\n\n"

    print "    0 - re - encodes and deletes all valid files in the current working directory (same filename)\n\n"

    print "    n - re - encodes files from the command line arguments (same filename)\n"
    print "            an example is\n"
    print "                imagetopdf file1.mp4 file2.mp4 file3.mov ...\n"

else
    for file in "${@}"; do
        extension=${file##*.} # gets everything after last '.' (normally the whole file extension)
        extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

        validExtension

        # if exit code of validExtension = 1, perform the conversion
        if [ $? == 1 ]; then
            ffmpeg -i "$file" -c:v libaom-av1 "${file%.*}.mkv"
        fi
    done

    rm -f "${@}"

fi
#!/bin/bash
# File: videotoav1.sh
# converts all video files in the working directory to AV1 video format

<<'notes'
    required packages
        ffmpeg (apt)

    additional notes
        referenced the following wikipedia page for the array of file extensions,
            https://en.wikipedia.org/wiki/Video_file_format
notes

# code starts here --------------------------------------------------------------------------------

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
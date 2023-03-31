#!/bin/bash
# File: videotoav1.sh
# converts all video files in the working directory to AV1 video format

<<'notes'
    required packages
        ffmpeg (apt)

    additional notes
        additional notes go here
notes

videoExtensions=("3g2" "3gp" "amv" "asf" "avi" "drc" "flv" "f4v" "f4p" "f4a" "f4b" "m4v" "mng" "mov" "qt" "mp4" "m4p" "m4v" "mpg" "mpg2" "mpeg" "mpe" "mpv" "m2v" "mts" "m2ts" "ts" "mxf" "nsv" "ogv" "ogg" "rm" "rmvb" "roq" "svi" "viv" "vob" "webm" "wmv" "yuv")

# Checks if the passed in string matches to one of the entries in image extensions
# ie checks if the string is a valid video file extension (out of most common extensions)
# returns 1 if the passed string is contained in imageExtensions, 0 otherwise
function validExtension {
    local i=0

    # while i < imageExtensions.length
    while [ ${i} -lt ${#imageExtensions[@]} ]; do
        if [ "${extension}" = "${imageExtensions[${i}]}" ]; then
            return 1
        fi

        let i=$i+1
    done

    return 0
}

for filename in $(ls); do
    extension=${filename##*.} # gets everything after last . (normally the whole file extension)
    extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

    validExtension

    # if exit code of validExtension = 1, perform the conversion
    if [ $? == 1 ]; then
        ffmpeg -i "${filename}" -c:v libaom-av1 "${filename%.*}.mkv"
        rm -f "${filename}"
    fi

done
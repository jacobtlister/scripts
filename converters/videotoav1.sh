#!/bin/bash
# File: videotoav1.sh

: <<'info'
    required packages
        ffmpeg (apt)

    description
        this script re-encodes a variety of video formats to AV1 encoding and deletes the
        original files; re-encoded files keep their original filenames

        there are different behaviors depending on the amount of command line arguments included:
            0 - re-encodes and deletes all video files in the current working directory
            n - re-encodes argument files

        some examples of running this script are shown below:
            bash videotoav1.sh
            bash videotoav1.sh file.mp4
            bash videotoav1.sh file1.mp4 file2.mp4 file3.mov
info

# to-do
# set up hardware decoding/encoding for the script:
#     https://www.cyberciti.biz/faq/how-to-install-ffmpeg-with-nvidia-gpu-acceleration-on-linux/
# current solution just uses a fast software encoder (faster than default av1 encoder):
#     https://github.com/AliveTeam/SVT-AV1/blob/master/Docs/Build-Guide.md
# once cude support is implemented, add this to the description:
#     this script assumes that the user has a nvidia graphics card, so this script has
#     ffmpeg use cuda for hardware encoding

# sources all functions in /scripts/funcs/
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

# array which contains many types of video file extensions
videoextensions=("3g2" "3gp" "amv" "asf" "avi" "drc" "flv" "f4v" "f4p" "f4a" "f4b" "m4v" "mng" "mov" "qt" "mp4" "m4p" "m4v" "mpg" "mpg2" "mpeg" "mpe" "mpv" "m2v" "mts" "m2ts" "ts" "mxf" "nsv" "ogv" "ogg" "rm" "rmvb" "roq" "svi" "viv" "vob" "webm" "wmv" "yuv")

if [[ $# == 0 ]]; then
    for file in *.*; do
        extension=${file##*.} # gets everything after last '.' (normally the whole file extension)
        extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

        # if extension is valid (exit code of search = 0),
        # perform the conversion and delete original file
        if search "${extension}" "${videoextensions[*]}" &> /dev/null; then
            ffmpeg -y -i "$file" -c:a copy -c:v libsvtav1 "${file%.*}.mkv"
            rm -f "$file"
        fi
    done

elif [[ $# == 1 ]] && [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
    print "this script re-encodes a variety of video formats to AV1 encoding and deletes the original files (re-encoded files keep their original filenames)\n\n"

    print "there are different behaviors depending on the amount of command line arguments:\n"
    print "0 - re-encodes and deletes all video files in the pwd\n" 4
    print "n - re-encodes argument video files\n\n" 4

    print "some examples of running this script are shown below:\n"
    print "bash videotoav1.sh\n" 4
    print "bash videotoav1.sh file.mp4\n" 4
    print "bash videotoav1.sh file1.mp4 file2.mp4 file3.mov\n" 4
else
    for file in "${@}"; do
        extension=${file##*.} # gets everything after last '.' (normally the whole file extension)
        extension=${extension,,}  # converts the entire string to lower case (for easier comparisons)

        # if extension is valid (exit code of search = 0),
        # perform the conversion and delete original file
        if search "${extension}" "${videoextensions[*]}" &> /dev/null; then
            ffmpeg -y -i "$file" -c:a copy -c:v libsvtav1 "${file%.*}.mkv"
            rm -f "$file"
        fi
    done
fi
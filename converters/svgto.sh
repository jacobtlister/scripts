#!/bin/bash
# File: svgto.sh

: <<'info'
    description
        converts .svg files to a variety of different file types, default converts to eps, converted files keep their names

    required packages
        inkscape (apt)

    additional notes
        there are different behaviors depending on the amount of command line arguments included,
            0 - converts all valid files in the current working directory into eps files (same filename)
            1 - converts all valid files in the current working directory into filetypes based on user input
            n - converts files from the first n-1 command line arguments into filetypes based on last input

        if -h or --help is the command line argument then this explanation and extra info will be printed instead
info

# sources all scripts in the utils directory of scripts
# commenting this so ShellCheck doesn't freak out
# shellcheck source=/dev/null
for f in "$HOME/scripts/utils"/*.sh; do source "${f}"; done

if [ $# == 0 ]; then
    inkscape --export-type="eps" --export-ignore-filters --export-ps-level=3 --export-background-opacity=0.0 --export-dpi=1200 --export-margin=0 ./*.svg

# for why the elif is structured the way it is, reference SC1028 https://www.shellcheck.net/wiki/SC1028
# else if($# == 1 && ("${1}" == "-h" ] || [ "${1}" == "--help"))
elif [ $# == 1 ] && { [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; }; then
    print "converts .svg files to a variety of different file types, default converts to eps, converted files keep their names\n\n"

    print "there are different behaviors depending on the amount of command line arguments included\n\n"

    print "    0 - converts and deletes all valid files in the current working directory into pdfs (same filename)\n\n"

    print "    1 - converts all valid files in the current working directory into filetypes based on user input"
    print "        valid file types are [svg,png,ps,eps,pdf,emf,wmf,xaml]."
    print "        should be entered as comma-seperated list in quotes."
    print "        an example is"
    print "            svgto \"png,eps\"\n\n"

    print "    n - converts files from the command line arguments into pdfs (same filename)"
    print "            an example is"
    print "                topdf file1.svg file2.svg file3.svg ... filen-1.svg \"eps\""

else
    for arg in "${@:1:$#-1}"; do
        inkscape --export-type="${!#}" --export-ignore-filters --export-ps-level=3 --export-background-opacity=0.0 --export-dpi=1200 --export-margin=0 "$arg"
    done

fi

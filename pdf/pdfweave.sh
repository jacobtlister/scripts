#!/bin/bash
# File: pdfweave.sh

: <<'info'
    required packages
        pdftk

    description
        merges 2 pdf files, interleaving the pages

        of note, file1.pdf and file2.pdf need not be the same size. if file1.pdf and
        file2.pdf are not equal length, the output will be interleaved as much as possible,
        then the remainder of the output will simply be the remainder of the longer input pdf

        the output pdf is always named after the first input file in the command with
        "-weave" appended to its filename (before the extension)

        there are different behaviors depending on the amount of command line arguments:
            1 - merges file.pdf with fileb.pdf, interleaving the pages starting at
                page 1 of file.pdf
            2 - merges file1.pdf with file2.pdf, interleaving the pages starting at
                page 1 of file1.pdf
            3 - merges file1.pdf with file2.pdf, interleaving the pages starting at
                page start of file1.pdf

        for example, if have front.pdf is 6 pages and back.pdf is 3 pages, we would
        run pdfweave as the following and get:
            bash pdfweave.sh front.pdf back.pdf
            front1, back1, front2, back2, front3, back3, front4, front5, front6

        this time, if front.pdf and back.pdf are the same, but we specify the weave to
        start at page 4, we would run pdfweave as the following and get:
            bash pdfweave.sh front.pdf back.pdf 4
            front1, front2, front3, front4, back1, front5, back2, front6, back3

        this time if file.pdf and fileb.pdf (each 4 pages) exist and we run pdfweave
        with the argument file.pdf, we would run pdfweave as and get the following:
            bash pdfweave.sh file.pdf
            front1, frontb1, front2, frontb2, front3, frontb3, front4, frontb4

        note: when pdfweave is run with one argument file.pdf, it is equivalent to running
        pdfweave as the following:
            bash pdfweave.sh file.pdf fileb.pdf
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

if [[ $# == 1 ]]; then
    if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
        print "merges 2 pdf files, interleaving the pages\n\n"

        print "of note, file1.pdf and file2.pdf need not be the same size. if file1.pdf and file2.pdf are not equal length, the output will be interleaved as much as possible, then the remainder of the output will simply be the remainder of the longer input pdf\n\n"

        print "the output pdf is always named after the first input file in the command with \"-weave\" appended to its filename (before the extension)\n\n"

        print "there are different behaviors depending on the amount of command line arguments:"
        print "1 - merges file.pdf with fileb.pdf, interleaving the pages starting at page 1 of file.pdf" 4
        print "2 - merges file1.pdf with file2.pdf, interleaving the pages starting at page 1 of file1.pdf" 4
        print "3 - merges file1.pdf with file2.pdf, interleaving the pages starting at page start of file1.pdf\n\n" 4

        print "for example, if have front.pdf is 6 pages and back.pdf is 3 pages, we would run pdfweave as the following and get:"
        print "bash pdfweave.sh front.pdf back.pdf" 4
        print "front1, back1, front2, back2, front3, back3, front4, front5, front6\n\n" 4

        print "this time, if front.pdf and back.pdf are the same, but we specify the weave to start at page 4, we would run pdfweave as the following and get:"
        print "bash pdfweave.sh front.pdf back.pdf 4" 4
        print "front1, front2, front3, front4, back1, front5, back2, front6, back3\n\n" 4

        print "this time if file.pdf and fileb.pdf (each 4 pages) exist and we run pdfweave with the argument file.pdf, we would run pdfweave as and get the following:"
        print "bash pdfweave.sh file.pdf" 4
        print "front1, frontb1, front2, frontb2, front3, frontb3, front4, frontb4\n\n" 4

        print "note: when pdfweave is run with one argument file.pdf, it is equivalent to running pdfweave as the following:"
        print "bash pdfweave.sh file.pdf fileb.pdf" 4
    else
        pdftk A="${1}.pdf" B="${1}b.pdf" shuffle A B output "${1}-weave.pdf"
    fi
elif [[ $# == 2 ]]; then
    pdftk A="${1}" B="${2}" shuffle A B output "${1%.*}-weave.pdf"
elif [[ $# == 3 ]]; then
    pdftk "${1}" cat "1-$(("${3}" - 1))" output temp1.pdf
    pdftk "${1}" cat "${3}-end" output temp2.pdf

    pdftk A=temp2.pdf B="${2}" shuffle A B output temp3.pdf

    pdftk A=temp1.pdf B=temp3.pdf cat A B output "${1%.*}-weave.pdf"

    rm temp1.pdf temp2.pdf temp3.pdf
fi

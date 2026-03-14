#!/bin/bash
# File: pdfweave.sh

: <<'info'
    description
        merges 2 pdfs, interleaving the pages

    required packages
        pdftk

    additional notes
        command args format is the following:
            bash pdfweave.sh 1.pdf 2.pdf pdf1_pagestart
        
        the output of this script is 1.pdf and 2.pdf merged and interleaved, named 1-weave.pdf.
        
        1-weave.pdf is located in the current working directory.
        
        the pdf1_pagestart is an optional argument, and denotes where the interleaving should start.
        
        for example, if front.pdf is 6 pages, back.pdf is 3 pages, and we run pdfweave.sh as:
            bash pdfweave.sh front.pdf back.pdf 4
            
        then front-weave.pdf will be ordered as follows:
            front1, front2, front3, front4, back1, front5, back2, front6, back3
            
        also of note, 1.pdf and 2.pdf need not be the same size.
        
        for example, if we again have front.pdf is 6 pages, back.pdf is 3 pages, and we run pdfweave.sh as:
            bash pdfweave.sh front.pdf back.pdf
        
        then front-weave.pdf will be ordered as follows:
            front1, back1, front2, back2, front3, back3, front4, front5, front6
        
        there is also the option to run the script with 1 argument, as follows:
            bash pdfweave.sh filename_no_extension
        
        in the case above, this is equivalent to the following:
            bash pdfweave.sh "${filename_no_extension}.pdf" "${filename_no_extension}b.pdf"
        
        for example, if we run pdfweave.sh with the following argument:
            bash pdfweave.sh file1
        
        it will be equivalent to the following:
            bash pdfweave.sh file1.pdf file1b.pdf
info

if [ $# == 1 ]; then
    pdftk A="${1}.pdf" B="${1}b.pdf" shuffle A B output "${1}-weave.pdf"

elif [ $# == 2 ]; then
    pdftk A="${1}" B="${2}" shuffle A B output "${1%.*}-weave.pdf"

elif [ $# == 3 ]; then
    pdftk ${1} cat 1-$((${3} - 1)) output temp1.pdf
    pdftk ${1} cat ${3}-end output temp2.pdf
    
    pdftk A=temp2.pdf B=${2} shuffle A B output temp3.pdf
    
    pdftk A=temp1.pdf B=temp3.pdf cat A B output "${1%.*}-weave.pdf"
    
    rm temp1.pdf temp2.pdf temp3.pdf

fi

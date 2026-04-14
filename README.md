# scripts

## what is this repository?

i use linux mint as my daily driver, so over time i have created some scripts, and i store them in this repository (mostly so i can easily access them across devices)

i have chosen to make these scripts either because i cannot find a package that does exactly what i want, or i wanted to just make something for fun and to improve my linux and scripting skills

i am also using this as an opportunity to learn markdown as i am setting up and updating this readme

## what do these scripts do?

each script's function will be pretty self-explanatory by the filename and parent directory, but there will also be a list of required packages (if any) and a description of the script

in addition, each proper script will have a `-h/--help` call you can make to get info about the script and example usage

## script storage and aliases

you are able to store the scripts wherever you would like on your computer as you can easily generate aliases for the scripts in this repository

to setup aliases for the scripts in this repository, simply run `setupjaliases.sh` in the `setup/` directory (elevated priveleges required)

## repository organization

the repository is organized into different directories based on the functionality/purpose of the scripts within:

- `converters/` contains scripts that convert files from one type to another
- `funcs/` contains scripts that implement functions that are used by other scripts in the repository
- `misc/` contains scripts that don't fit into any of the other folders
- `pdf/` contains scripts that manipulate or create `.pdf` files
- `setup/` contains scripts and files related to getting aliases for the scripts in this repository set up and linked to your (yes, yours!) `.bashrc` file
- `templates/` contains template scripts
- `tests/` contains scripts developed for the purposes testing, exploration, or experimenting
- `resources.md` links to different resources i have used (and for what reason), which are usually links to stack overflow answers or tutorials on programming-oriented websites

## to-do

below is a list of tasks i would like to accomplish when working on this repository:

1. template-ize the contents of `/tests/testflags.sh` and put it in `/templates/template.sh`. now that i have learned to implement flag arguments via `getopt`, update all existing scripts to make use of flag arguments. this should provide far more robustness and flexibility to the scripts

2. make a script for batch re-encoding audio files based on the python script in fenway's ( my fren (: ) `audio_converter` repository i helped with a couple of years ago

3. add support for `jpg` as an output filetype for `converters/vgto.sh`

4. implement hardware encoding for `converters/videotoav1.sh`; mostly just need to get the `nvenc` encoders and decoders installed on my laptop

5. write a script for splitting a pdf into multiple children pdf files

6. write a script for extracting pages from a pdf

7. write a script to flatten and/or compress a pdf (possibly)

8. write a script that ocr's a pdf without blowing up the filesize

for audio re-encoding, base it off of fenway's python script:

<https://github.com/fenwaypowers/audio_converter>

for extracting a page range from a pdf, the command that would be used in the script would look something like the following:

`gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=start -dLastPage=end -sOutputFile=input_start-end.pdf input.pdf`

the above command can also be used in the script for splitting a pdf

the following link provides a way of flattening a pdf with ghostscript:

<https://unix.stackexchange.com/a/234330>

for the ocr scan script, i have messed around with `tesseract` in the past, but have found that it massively blows up the filesize of any ocr'ed pdf. maybe mess around with the options and see what can be done to reduce metadata size? i know that the website pdf24 has a really good ocr implementation that barely increases the filesize (a few MB increase for a 300+ page pdf scan of a book). maybe just figure out what set of commands they use to perform their ocr scan and make a script implementing those commands?

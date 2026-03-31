# scripts

## what is this repository?

i use linux mint as my daily driver, so over time i have created some scripts, and i store them in this repository (mostly so i can easily access them across devices)

i have chosen to make these scripts either because i cannot find a package that does exactly what i want, or i wanted to just make something for fun and to improve my linux and scripting skills

i am also using this as an opportunity to learn markdown as i am setting up and updating this readme

## what do these scripts do?

each script's function will be pretty self-explanatory by the filename, but there will also be a list of required packages (if any) and a description of the script

in addition, each proper script will have a `-h/--help` call you can make to get info about the script and example usage

## script storage and aliases

you are able to store the scripts wherever you would like on your computer as you can easily generate aliases for the scripts in this repository

to setup aliases for the scripts in this repository, simply run `setupjaliases.sh` in the `setup/` directory (elevated priveleges required)

## repository organization

the repository is organized into different directories based on the functionality/purpose of the scripts within:</br>
`converters/` contains scripts that convert files from one type to another</br>
`funcs/` contains scripts that implement functions that are used by other scripts in the repository</br>
`misc/` contains scripts that don't fit into any of the other folders</br>
`pdf/` contains scripts that manipulate or create `.pdf` files</br>
`setup/` contains scripts and files related to getting aliases for the scripts in this repository set up and linked to your (yes, yours!) `.bashrc` file</br>
`templates/` contains template scripts</br>
`tests/` contains scripts developed for the purposes testing, exploration, or experimenting</br>
`resources.md` links to different resources i have used (and for what reason), which are usually links to stack overflow answers or tutorials on programming-oriented websites

## to-do

1. now that i have learned to implement flag arguments via `getopt`, i plan on updating all of my scripts to make use of flag arguments. this should provide far more robustness and flexibility to the scripts

2. add support for `.jpg` as an output filetype for `converters/vgto.sh`. also add more support for custom input filetype

3. implement hardware encoding for `converters/videotoav1.sh`. mostly just need to get the `nvenc` encoders and decoders installed on my laptop

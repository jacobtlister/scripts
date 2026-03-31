# shell scripting resources

## shell check package for vs code (the goat)

shell check is a vs code extension and linux package that checks your shell scripts for errors and suggest fixes for broken or risky code. overall, this utility is incredibly helpful when making scripts.

you can install the package from your package manager or go to the github\
<https://github.com/koalaman/shellcheck>

the vs code extension goes by the same name as the package (the extension requires the package)\
<https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck>

## solid all - in - one bash scripting guide

as i have been working on this repository i have been looking for good resources to learn shell scripting. over time i have come across lots of stack exchange / overflow topics that cover one - off or niche topics, but this guide linked below is the best general guide / learning tool i have found for shell scripting. it starts from nothing and builds on the topics over time. it also provide good practice problems to go along with each topic introduced and covered, so it would be an especially good resource for beginners. it also links to other useful resources which is nice

<https://bash.cyberciti.biz/guide/Main_Page>

## another bash scripting guide

<https://tldp.org/LDP/abs/html/>

## bash scripting in jupyter notebooks

to make doing random tests of bash scripts more organized, i started doing my tests in a bash jupyter notebook. i ended finding the following website and guide to do this. i run my jupyter notebooks in vs code, and use the built in extension for their support.

<https://github.com/takluyver/bash_kernel>

<https://evodify.com/python-r-bash-jupyter-notebook/>

## command line arguments

command line arguments\
<https://linuxhint.com/command_line_arguments_bash_script/>

get last command line arg using `${!#}`\
<https://super-unix.com/unixlinux/bash-how-does-work-in-bash-to-get-the-last-command-line-argument/>

## print() function resources

when i was working on some of these scripts, i wanted to output text to the command line, but couldn't align the text like i wanted to just with packages like fold and fmt, so i dug around for a while and found these resources linked below and made my customized print function.

<https://unix.stackexchange.com/a/446153>

<https://stackoverflow.com/a/34690791>

<https://www.cyberciti.biz/faq/linux-unix-appleosx-bsd-bash-passing-variables-to-awk/>

post 2 (by Chubler_XL)\
<https://www.unix.com/shell-programming-and-scripting/253291-counting-leading-spaces-character.html>

## arrays and strings

array basics\
<https://www.tutorialspoint.com/unix/unix-using-arrays.htm>

how to append data to strings and arrays\
<https://stackoverflow.com/a/1951523>

get size of an array\
<https://stackoverflow.com/a/1886483>

removing an index from an array using unset\
<https://stackoverflow.com/a/47798640>

explanation of splitting strings\
<https://stackoverflow.com/a/59629043\>

## file io with sed

way to insert text at a certain line in a file with sed\
<https://stackoverflow.com/a/6537587>

append text to the end of a file with sed\
<https://stackoverflow.com/a/30219386>

printing lines from a file using sed (also see test.sh for more examples)\
<https://stackoverflow.com/a/83347>

while loop for each line of a text file\
<https://www.shellcheck.net/wiki/SC2013>

## word wrap using fmt and fold

fmt\
<https://www.geeksforgeeks.org/fmt-command-unixlinux/>

fold\
<https://www.geeksforgeeks.org/fold-command-in-linux-with-examples/>

another resource that gives a more in - depth explanation of fmt and fold\
<https://linuxhandbook.com/fold-fmt-commands/>

## printing newlines

<https://stackoverflow.com/a/13192701>

## about locating scripts

<https://mywiki.wooledge.org/BashFAQ/028>

## to ignore ShellCheck errors

<https://github.com/koalaman/shellcheck/wiki/ignore>

## multiline comments in bash (no ShellCheck warnings)

<https://stackoverflow.com/a/46049228>

## miscellaneous (not bash)

### markdown resources

markdown guide used for making the README\
<https://www.markdownguide.org/basic-syntax/>

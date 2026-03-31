#!/bin/bash
# testflags.sh

: <<'info'
    required packages
        util-linux

    description
        testing command flags using the enhanced getopt from util-linux

        script has no real function, was made just to get acquainted with
        command flags
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

# name of the script being run
scriptname=$(basename "$0" .sh)

# note about the design of flags
# on non-argumentative flags:
#     - non-argumentitive flags should always be optional, as flags like these
#       should either act as a switch in the script or be something like help
#     - non-argumentative flags should have "" in phvals, as these values are
#       specifically used in --help as a name for a placeholder argument value
# on argumentative flags:
#     - if an argumentitive flag is optional, it should always have a default
#       value, otherwise you may run the script with uninitialized variables
#     - if an argumentitive flag is required, it may have a default value, but
#       it is not needed

# define lists containing the following information:
#     - flag names; short- and long-hand names in seperate lists
#     - phvals list, whose entries are used in --help as placeholder argument values
#     - flag argument counts; should usually be 0 or 1
#     - flag argument default values; "" if no arguments or no default value
#     - whether or not the flag is required to be defined
# define all non-help flags first
snames=("s" "d" "e" "c" "b" "t" "p" "l")
lnames=("source" "destination" "ecc" "credentials" "bandwidth" "timeout" "port" "compression-level")
phvals=("src" "dst" "" "creds" "bw" "tout" "port" "clvl")
args=(":" ":" "" ":" ":" ":" ":" ":")
defaults=("." "" "0" "" "" "60" "1234" "0")
required=(0 0 1 0 0 0 0 0) # remember, 0 = true in bash
nflags=$(( "${#snames[*]}" + 1 ))

# because help is always there, add it flag info seperately
# to make updating/implementing the flags more convenient
snames+=("h")
lnames+=("help")
phvals+=("")
args+=("")
defaults+=("")
required+=(1)

# define variables for each flag
# if a flag is non-argumentitive, variable is boolean
# if a flag is     argumentitive, variable is the argument default value
source="${defaults[0]}"
destination="${defaults[1]}"
ecc="${defaults[2]}"
credentials="${defaults[3]}"
bandwidth="${defaults[4]}"
timeout="${defaults[5]}"
port="${defaults[6]}"
level="${defaults[7]}"

# calculate the number of arguments for each flag
nargs=()

for (( i = 0; i < nflags; i++ )); do
    nargs+=("$(echo "${args[$i]}" | awk "{print length}")")
done

help() {
    # list containing strings of long flag names coupled with its
    # default value (if applicable). an example string would be:
    # flag[=42]
    # the above string corresponds to the argument for flag which
    # has default value 42
    helps=()
    lenhelps=()

    for (( i = 0; i < nflags - 1; i++ )); do
        if (( "${nargs[$i]}" > 0 )); then
            helpstr="${lnames[$i]}=<${phvals[$i]}>"
        else
            helpstr="${lnames[$i]}"
        fi

        # using the following boolean algebra property: X + ~XY = X + Y
        # we can simplify:
        # ("${defaults[$i]}" != "") || ( ("${defaults[$i]}" == "") && ("${required[$i]}" == 0) )
        # into:
        # ("${defaults[$i]}" != "") || ("${required[$i]}" == 0)
        if [[ "${defaults[$i]}" != "" || "${required[$i]}" == 0 ]]; then
            helps+=("${helpstr}[${defaults[$i]}]")
        else
            helps+=("${helpstr}")
        fi

        lenhelps+=("$(echo "${helps[$i]}" | awk "{print length}")")
    done

    # independently add help to helps as it works different than other flags
    helps+=("help")

    maxlenhelps="$(max "${lenhelps[*]}")"

    # printf format string
    f="-%s | --%-${maxlenhelps}s --"

    print "usage: ${scriptname} [options] args\n\n"

    print "script options\n"
    printf "    ${f} set source directory\n"  "${snames[0]}" "${helps[0]}"
    printf "    ${f} set destination\n"       "${snames[1]}" "${helps[1]}"
    printf "    ${f} toggle ecc\n"            "${snames[2]}" "${helps[2]}"
    printf "    ${f} set credentials\n"       "${snames[3]}" "${helps[3]}"
    printf "    ${f} set maximum bandwidth\n" "${snames[4]}" "${helps[4]}"
    printf "    ${f} set timeout\n"           "${snames[5]}" "${helps[5]}"
    printf "    ${f} set port number\n"       "${snames[6]}" "${helps[6]}"
    printf "    ${f} set compression level\n" "${snames[7]}" "${helps[7]}"

    # print help independent of the others since it will always be at the end
    printf "    ${f} print this help message and exit\n" "${snames[$((nflags-1))]}" "${helps[$((nflags-1))]}"

    exit 1
}

# input is a list of all the script args in order
# checks that all args are validly defined, ie:
#     - makes sure required args are defined
#     - makes sure all args have valid definitions (if needed)
# $1 - list of argument values
validargs() {
    read -r -a args <<< "${@:0}"

    # to remove script name from the args list
    args=("${args[@]:1}")

    for (( i = 0; i < nflags - 1; i++ )); do
        if [[ "${required[$i]}" == 0 && "${args[$i]}" == "" ]]; then
            error "${scriptname}" "some required flags did not have arguments set"
        fi
    done
}

# code below is taken from the getopt example at:
#     /usr/share/doc/util-linux/examples/getopt-example.bash
# combined with the following stack overflow answer and blog post:
#     https://stackoverflow.com/a/64257864
#     https://linuxvox.com/blog/linux-getopt/

# define the short and long options strings for use in getopt
sopts=""
lopts=""

for (( i = 0; i < nflags; i++ )); do
    sopts+="${snames[$i]}${args[$i]}"
    lopts+="${lnames[$i]}${args[$i]},"
done

# remove uneeded extra comma from end of lopts
lopts="${lopts:0:$(( "${#lopts}" - 2 ))}"

# we need argsparsed as the 'eval set --' would nuke the return value of getopt
argsparsed=$(getopt -o "${sopts}" --long "${lopts}" -n "${scriptname}.sh" -- "${@}")

# kill program if getopt returned an error
if ! getopt -o "${sopts}" --long "${lopts}" -n "${scriptname}.sh" -- "${@}" &> /dev/null; then
    print "Terminating..."
    exit 1
fi

eval set -- "${argsparsed}"
unset argsparsed

while true; do
    # in the switch statement below, you will see the very cursed lines:
    #     "${1//-/}" &> /dev/null
    #     shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
    # these lines combined are a way of shifting dynamically, based on how many arguments
    # a given flag has. if the flag is non-argumentative, it shifts by 1 and
    # if the flag is argumentative, it shifts by # of args of the flag + 1

    # the first line performs a string substitution, removing any hyphens from the flag string,
    # then the second command uses the discarded output, _, from that command to perform another
    # string substitution. idea came from this unix stack exchange post:
    # https://unix.stackexchange.com/a/679846
    case "${1}" in
        ("-s"|"--source")
            source="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-d"|"--destination")
            destination="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-e"|"--ecc")
            ecc=$(( ! "${ecc}" ))
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-c"|"--credentials")
            credentials="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-b"|"--bandwidth")
            bandwidth="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-t"|"--timeout")
            timeout="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-p"|"--port")
            port="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-l"|"--compression-level")
            level="${2}"
            "${1//-/}" &> /dev/null
            shift $(( "${nargs[$(( $(search "${_:0:1}" "${snames[*]}") ))]}" + 1 ))
            continue;;
        ("-h"|"--help")
            help;;
        ("--")
            shift
            break;;
        (*)
            error "${scriptname}" "what did you do";;
    esac
done

vars=("${source}" "${destination}" "${ecc}" "${credentials}" "${bandwidth}" "${timeout}" "${port}" "${level}")
validargs "${vars[*]}"

echo "source is $source"
echo "destination is $destination"
echo "ecc toggle is set to $ecc"
echo "credentials are $credentials"
echo "bandwidth is $bandwidth"
echo "timeout is $timeout"
echo "port is $port"
echo "compression level is $level"

bonusargs=()

for arg; do
    bonusargs+=("${arg}")
done

print "additional arguments: ${bonusargs[*]}"
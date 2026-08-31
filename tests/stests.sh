#!/bin/bash
# File: stests.sh

: <<'info'
    required packages
        varies depending on test

    description
        executes test functions in ftests.sh based on command-line arguments

        this script has no real purpose other than for me to experiment. this isn't really meant
        to be used, more so to run and see the outputs for me to learn about certain shell features.
        this is also for me to experiment with fixes that shellcheck recommends.

        if i am testing a shellcheck recommmendation / fix, I will include the specific SC
        number in the comment above the code
info

# NOTE: you only need to source function scripts and jaliases in
# the highest-level script. all child processes of thehighest level
# script calls will have access to what it sources unless the child
# is ran in a new/different shell instance

# to allow calling aliases from ~/.jaliases in the script
shopt -s expand_aliases
source "${HOME}/.jaliases"

# to allow calling functions from the scripts repo in the script
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

# source the test functions
source "${SCRIPTS_PATH}/tests/ftests.sh"

# number of test functions defined in ftests.sh
numtests=$(( $(env -i bash --noprofile --norc -c 'source "./ftests.sh"; declare -F | wc -l') + 0 ))

echo "there are currently ${numtests} test functions defined in ftests.sh"

# execute test function corresponding to each valid input argument
for arg in "${@}"; do
    if isnumeric "${arg}" && (( $(( arg + 0 )) < numtests )); then
        echo "---------- test$(padzeros "${arg}" 3) ----------"
        eval "test$(padzeros "${arg}" 3)"
    fi
done

echo "-----------------------------"
#!/bin/bash
# File: FTEMPLATE.sh

: <<'info'
    required packages
        PACKAGE_NAME

    description
        DESCRIPTION
info

# because this lives in /funcs/, cannot just source all in
# scripts/funcs/, else recursion. instead, just source what's needed
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
# source "${SCRIPTS_PATH}/funcs/func.sh"

# $1 - description
# $2 - description
FTEMPLATE() {


    return 1
}
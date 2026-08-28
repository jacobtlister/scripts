#!/bin/bash
# File: TEMPLATE.sh

: <<'info'
    required packages
        PACKAGE_NAME

    description
        DESCRIPTION
info

# so that i can run aliases in ~/.jaliases in scripts
shopt -s expand_aliases
source ~/.jaliases

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done


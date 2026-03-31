#!/bin/bash
# File: TEMPLATE.sh

: <<'info'
    required packages
        PACKAGE_NAME

    description
        DESCRIPTION
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done


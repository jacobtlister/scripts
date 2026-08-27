#!/bin/bash
# File: krunner-autostart.sh

: <<'info'
    required packages
        krunner

    description
        starts krunner in the background
        this script is meant to be used as an autostart login script on kde
info

krunner --daemon

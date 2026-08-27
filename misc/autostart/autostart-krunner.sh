#!/bin/bash
# File: autostart-krunner.sh

: <<'info'
    required packages
        krunner

    description
        starts krunner in the background
        this script is meant to be used as a login autostart script on kde
info

krunner --daemon

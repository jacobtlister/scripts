#!/bin/bash
# File: setup-monitor-mode.sh

: <<'info'
    required packages
        iw
        airmon-ng

    description
        creates and enables a monitor mode interface

        monitor mode interface has channel and bandwidth corresponding
        to 1st and 2nd command line argument respectively
info

# sources all functions in /scripts/funcs/
# commenting this so shellcheck doesn't freak out
# shellcheck source=/dev/null
for f in "${SCRIPTS_PATH}/funcs"/*.sh; do source "${f}"; done

# get name of managed interface
interface=$(sudo iw dev | grep -i "Interface" | tail -n 1)
interface_name="${interface##* }"

# create monitor interface
sudo iw phy phy0 interface add mon0 type monitor

# kill wireless daemons
sudo airmon-ng check kill
sudo airmon-ng check kill

# turn off managed interface, turn on monitor interface, and set monitor interface channel and bandwidth
sudo ip link set "${interface_name}" down
sudo ip link set mon0 up
sudo iw dev mon0 set channel "${1}" "${2}"
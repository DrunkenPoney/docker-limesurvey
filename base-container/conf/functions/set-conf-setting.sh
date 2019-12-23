#!/usr/bin/env bash

function setConfSetting() {
    if [ $# -ne 3 ] || [ ! -e "$3" ]; then
        echo "Set a configuration setting in the given file."
        echo "Usage: setConfSetting <setting_name> <setting_value> <config_file>"

        return 1
    fi

    if [ -z "$(grep -m1 -Gi "^\s*${1}\s*=" "$3")" ]; then
        echo "${1}=${2}" >> "$3"
    else
        sed -i "s~^\s*${1}\s*=.*~${1}=${2}~" "$3"
    fi
}
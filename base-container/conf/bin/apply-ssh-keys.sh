#!/bin/bash

set -eu

(
    declare SSH_KEYS_DIR="$1"
    declare CONFIG_FILE="$2"
    declare USER_HOME

    if [[ -z "$SSH_KEYS_DIR" ]] || [[ ! -d "$SSH_KEYS_DIR" ]]; then
        echo "FATAL: invalid keys directory!"
        exit 1
    fi

    if [[ -z "$CONFIG_FILE" ]] || [[ ! -f "$CONFIG_FILE" ]]; then
        echo "FATAL: invalid configuration file!"
        exit 1
    fi

    rm -rf /root/.ssh
    find /home -mindepth 2 -maxdepth 2 -name .ssh -delete

    ( cat "$CONFIG_FILE" && echo ) |
        sed -En '/^\s*(\w|-)+\s*=\s*\w+\s*$/ { s/^\s*((\w|-)+)\s*=\s*(\w+)\s*$/\1=\3/ ; p }' |
        while IFS=$'\n=' read key user; do
            if [[ -f "${SSH_KEYS_DIR}/${key}.pub" ]]; then
                if id -u "$user" &>/dev/null; then
                    USER_HOME="$( eval echo "~$user" )"

                    if [[ -d "$USER_HOME" ]]; then
                        mkdir -p "${USER_HOME}/.ssh"
                        echo >> "${USER_HOME}/.ssh/authorized_keys"
                        cat "${SSH_KEYS_DIR}/${key}.pub" >> "${USER_HOME}/.ssh/authorized_keys"
                    else
                        echo "Error: home directory for user '$user' not found!" >&2
                    fi

                else
                    echo "Error: user '$user' does not exist!" >&2
                fi
            else
                echo "Error: public key not found! (${key}.pub)" >&2
            fi
        done
)

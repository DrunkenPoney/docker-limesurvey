#!/usr/bin/env bash

source /opt/docker/functions/set-folder-permissions.sh
source /opt/docker/functions/rand-name.sh

function createUser() {
    if [ $# -lt 1 ] || [ $# -gt 2 ]; then
        echo "Creates a system user (and group) from the given parameter if they don't exist."
        echo "Usage: createUser <id> [name] OR"
        echo "       createUser <name>"

        return 1
    fi

    username="$(getent passwd "$1")"

    # if a user exists already, lets get the username and make sure
    # the home directory exists with correct permissions.
    if [ ! -z "$username" ]; then
        # extract just the username portion
        username="$(echo $username | cut -d':' -f1)"

        # grab the user's home directory path
        homedir="$(getent passwd "$1" | cut -d':' -f6)"

        # make the home directory if it doesn't already exist
        if [ ! -z "$homedir" ] && [ ! -e "$homedir" ]; then
            mkdir -p "$homedir"
        fi

        setFolderPermissions "$username" "$homedir"
    else
        # no user exists with the given ID or name, so we need to create one.

        # check if we were given an ID
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            if [ ! -z "$2" ] && [ -z "$(getent passwd "$2")" ]; then
                username="$2"
            else
                username=$(randName)
            fi

            # check if a group with the given user ID exists and
            # create one if one does not exist.
            groupid="$(getent group "$1" | cut -d':' -f3)"
            if [ -z "$groupid" ]; then
                addgroup --system --gid "$1" "$username" > /dev/null
                groupid="$1"
            fi

            adduser --system --uid="$1" --gid="$groupid" "$username" > /dev/null
        else
            # we were given a name
            groupid="$(getent group "$1" | cut -d':' -f3)"
            if [ -z "$groupid" ]; then
                addgroup --system "$username" > /dev/null
                groupid="$(getent group "$username" | cut -d':' -f3)"
            fi

            # make sure a user does not exist with the given group ID before setting
            # that user's UID to be the same as the group ID. If one does exist, we
            # just create a user with an automatic UID but assign the GID to be the
            # same as the group ID we identified above.
            if [ ! -z "$(getent passwd "$groupid")" ]; then
                adduser --system --gid="$groupid" "$username" > /dev/null
            else
                adduser --system --uid="$groupid" --gid="$groupid" "$username" > /dev/null
            fi
        fi
    fi

    # write out the username to be captured
    echo "$username"
}
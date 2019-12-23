#!/usr/bin/env bash

function setFolderPermissions() {
    if [ $# -ne 2 ] || [ ! -e "$2" ] || [ -z "$(getent passwd $1)" ]; then
        echo "Set the permissions on a folder based on a user and it's associated group."
        echo "Usage: setfolderpermissions <username> <folder>"

        return 1
    fi

    # get the user's group to use when chowning the home directory
    usergroupid="$(getent passwd "$1" | cut -d':' -f4)"
    usergroup="$(getent group "$usergroupid" | cut -d':' -f1)"

    echo "Chown: $username:$usergroup $2"
    chown "$username:$usergroup" "$2"
}
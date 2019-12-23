#!/usr/bin/env bash

##
# Generate a random sixteen-character
# string of alphabetical characters
function randName() {
    local -x LC_ALL=C
    tr -dc '[:lower:]' < /dev/urandom |
        dd count=1 bs=16 2>/dev/null
}
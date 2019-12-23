#!/usr/bin/env bash

###
 # List environment variables (based on prefix)
 ##
function envListVars() {
    if (( $# > 1 )); then
        env | grep ${@:1} "^${1}" | cut -d= -f1
    elif (( $# == 1 )); then
        env | grep "^${1}" | cut -d= -f1
    else
        env | cut -d= -f1
    fi
}
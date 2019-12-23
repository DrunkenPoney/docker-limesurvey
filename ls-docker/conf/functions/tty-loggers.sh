#!/usr/bin/env bash

function logError() {
    [ -t 1 ] &&
        echo -e "\e[31m$@\e[m" ||
        echo "$@"
}

function logWarn() {
    [ -t 1 ] &&
        echo -e "\e[33m$@\e[m" ||
        echo "$@"
}

function logInfo() {
    [ -t 1 ] &&
        echo -e "\e[36m$@\e[m" ||
        echo "$@"
}

function logDebug() {
    [ -t 1 ] &&
        echo -e "\e[90m$@\e[m" ||
        echo "$@"
}

function logSuccess() {
    [ -t 1 ] &&
        echo -e "\e32m$@\e[m" ||
        echo "$@"
}

function logFail() {
    [ -t 1 ] &&
        echo -e "\e[31m$@\e[m" ||
        echo "$@"
}
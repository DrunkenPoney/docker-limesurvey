#!/usr/bin/env bash

function isYes() {
    case "${1,,}" in
        1|y|yes|true) return 0 ;;
    esac
    return 1
}

function isNo() {
    case "${1,,}" in
        0|n|no|false) return 0 ;;
    esac
    return 1
}
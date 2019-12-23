#!/usr/bin/env bash

###
 # Get environment variable (even with dots in name)
 ##
function envGetValue() {
    awk "BEGIN {print ENVIRON[\"$1\"]}"
}
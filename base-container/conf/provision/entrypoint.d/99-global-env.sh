#!/usr/bin/env bash
set -eu

source /opt/docker/functions/env-list-vars.sh

if [ ! -f /etc/environment.orig ]; then
    mv -Tn /etc/environment /etc/environment.orig
fi

cp -TLf /etc/environment.orig /etc/environment

declare key val
echo '' >> /etc/environment
for ENV_VAR in $(envListVars 'GLOBAL\.'); do
    key="${ENV_VAR#GLOBAL.}"
    val="$(typeset -p "$ENV_VAR" | cut -d= -f2-)"
    echo "${key}=${val}" >> /etc/environment
done
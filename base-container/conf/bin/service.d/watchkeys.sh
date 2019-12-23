#!/usr/bin/env bash

# Init vars
if [[ -z "$WATCHKEYS_CONFIG_PATH" ]] && [[ -z "$WATCHKEYS_DIRECTORY" ]]; then
    WATCHKEYS_CONFIG_PATH="/ssh-keys/keys-mapping.cfg"
fi
WATCHKEYS_CONFIG_PATH="${WATCHKEYS_CONFIG_PATH:-"${WATCHKEYS_DIRECTORY}/keys-mapping.cfg"}"
WATCHKEYS_DIRECTORY="${WATCHKEYS_DIRECTORY:-"$(dirname "$WATCHKEYS_CONFIG_PATH")"}"

source /opt/docker/bin/config.sh

includeScriptDir "/opt/docker/bin/service.d/watchkeys.d/"

set -e
mkdir -p "${WATCHKEYS_DIRECTORY}"
/opt/docker/bin/apply-ssh-keys.sh "${WATCHKEYS_DIRECTORY}" "${WATCHKEYS_CONFIG_PATH}"
exec watchmedo shell-command \
    -wp "$WATCHKEYS_CONFIG_PATH;$(dirname "$WATCHKEYS_CONFIG_PATH")/*.pub" \
    -c "/opt/docker/bin/apply-ssh-keys.sh '${WATCHKEYS_DIRECTORY}' '${WATCHKEYS_CONFIG_PATH}'" \
    "$(dirname "$WATCHKEYS_CONFIG_PATH")"
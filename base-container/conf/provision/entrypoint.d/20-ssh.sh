#!/usr/bin/env bash

set +e

if ! id -u "$SSH_USER" > /dev/null 2>&1; then
    # Add user
    useradd -Ums /bin/bash "$SSH_USER"
fi

# Set passwords to "dev"
echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

set -e

# Add user to groups specified in SSH_USER_GROUPS as comma seperated list
if [[ -n "${SSH_USER_GROUPS+x}" ]]; then
    echo -n "${SSH_USER_GROUPS}" | xargs -rd, -n1 groupadd -f
    usermod -G "${SSH_USER_GROUPS}" "${SSH_USER}"
fi

echo '' >> /etc/ssh/sshd_config
echo '### DOCKER SETTINGS ###' >> /etc/ssh/sshd_config

# Set sshd options
for ENV_VAR in $(envListVars "sshd\."); do
    key="${ENV_VAR#sshd.}"
    val="$(envGetValue "$ENV_VAR")"

    echo "$key $val" >> /etc/ssh/sshd_config
done

# Disable all sshd options specified in SSH_DISABLE_OPTS as comma seperated list
if [[ -n "${SSH_DISABLE_OPTS+x}" ]]; then
    sed -Ei "s~^(${SSH_DISABLE_OPTS//,/|}) ~#\1 ~" /etc/ssh/sshd_config
fi

set +e
{
    if [[ -z "$WATCHKEYS_CONFIG_PATH" ]] && [[ -z "$WATCHKEYS_DIRECTORY" ]]; then
        WATCHKEYS_CONFIG_PATH="/ssh-keys/keys-mapping.cfg"
    fi
    WATCHKEYS_CONFIG_PATH="${WATCHKEYS_CONFIG_PATH:-"${WATCHKEYS_DIRECTORY}/keys-mapping.cfg"}"
    WATCHKEYS_DIRECTORY="${WATCHKEYS_DIRECTORY:-"$(dirname "$WATCHKEYS_CONFIG_PATH")"}"

    mkdir -p "${WATCHKEYS_DIRECTORY}"
    /opt/docker/bin/apply-ssh-keys.sh "${WATCHKEYS_DIRECTORY}" "${WATCHKEYS_CONFIG_PATH}"
} 2>/dev/null
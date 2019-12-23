#!/usr/bin/env bash

# source /opt/docker/functions.sh

# for VARIABLE in $(env); do
#     if [[ "${VARIABLE}" =~ ^VSFTPD_USER_[[:digit:]]+=.*$ ]]; then

#         # remove VSFTPD_USER_:digit:= from beginning of variable
#         VARIABLE="$(echo ${VARIABLE} | cut -d'=' -f2)"

#         if [ "$(echo ${VARIABLE} | awk -F ':' '{ print NF }')" -ne 4 ]; then
#             echo "'${VARIABLE}' user has invalid syntax. Skipping."
#             continue
#         fi

#         VSFTPD_USER_NAME="$(echo ${VARIABLE} | cut -d':' -f1)"
#         VSFTPD_USER_PASS="$(echo ${VARIABLE} | cut -d':' -f2)"
#         VSFTPD_USER_ID="$(echo ${VARIABLE} | cut -d':' -f3)"
#         VSFTPD_USER_HOME_DIR="$(echo ${VARIABLE} | cut -d':' -f4)"

#         if [ -z "$VSFTPD_USER_NAME" ] || [ -z "$VSFTPD_USER_PASS" ]; then
#             echo "'${VARIABLE}' is missing a username or password. Skipping."
#             continue
#         fi

#         # add the user credentials to the vsftpd.passwd file
#         entry="${VSFTPD_USER_NAME}:$(openssl passwd -1 "${VSFTPD_USER_PASS}")"
#         sedr="s~^${VSFTPD_USER_NAME}.*~${entry}~"

#         # check if the user exists already in the file
#         if [ ! -z "$(grep -G -i "^${VSFTPD_USER_NAME}" $PASSWD_FILE)" ]; then
#             sed -i "${sedr}" $PASSWD_FILE
#         else
#             printf "%s:%s\n" "$VSFTPD_USER_NAME" "$(openssl passwd -1 "$VSFTPD_USER_PASS")" >> "$PASSWD_FILE"
#         fi

#         USER_CONFIG_FILE="${USER_CONFIG_DIR}/${VSFTPD_USER_NAME}"

#         cp $DEFAULT_USER_CONFIG "$USER_CONFIG_FILE"

#         # pull the default username from the config file
#         username="$(grep -Gi '^guest_username=' "$USER_CONFIG_FILE" | cut -d'=' -f2)"

#         # set username to default if it's still not set to anything
#         if [ -z "$username" ]; then
#             username="ftp"
#         fi

#         # make sure the user ID is actually a number before setting it
#         if [[ "$VSFTPD_USER_ID" =~ ^[0-9]+$ ]] ; then
#             username="$(createuser "$VSFTPD_USER_ID" "$VSFTPD_USER_NAME")"
#         else
#             # make sure a system user exists for the username
#             # that the new user is supposed to operate as.
#             username="$(createuser "$username")"

#             VSFTPD_USER_ID="$(getent passwd "$username" | cut -d':' -f3)"
#         fi

#         setftpconfigsetting "guest_username" "$username" "$USER_CONFIG_FILE"

#         if [ -d "$VSFTPD_USER_HOME_DIR" ]; then
#             setftpconfigsetting "local_root" "$VSFTPD_USER_HOME_DIR" "$USER_CONFIG_FILE"
#         else
#             usersubtoken="$(cat "$USER_CONFIG_FILE" /etc/vsftpd/vsftpd.conf | grep -m1 -Gi "^user_sub_token=" | cut -d'=' -f2)"
#             VSFTPD_USER_HOME_DIR="$(cat "$USER_CONFIG_FILE" /etc/vsftpd/vsftpd.conf | grep -m1 -Gi "^local_root=" | cut -d'=' -f2)"

#             if [ ! -z "$usersubtoken" ]; then
#                 VSFTPD_USER_HOME_DIR="$(echo $VSFTPD_USER_HOME_DIR | sed "s/$usersubtoken/$VSFTPD_USER_NAME/")"
#             fi
#         fi

#         # make sure the virtual home directory exists
#         if [ ! -d "$VSFTPD_USER_HOME_DIR" ]; then
#             mkdir -p "$VSFTPD_USER_HOME_DIR"
#         fi

# cat << EOB
#  USER SETTINGS
#  ---------------
#  . FTP User: $VSFTPD_USER_NAME
#  . FTP Password: $VSFTPD_USER_PASS
#  . System User: $username
#  . System UID: $VSFTPD_USER_ID
#  . FTP Home Dir: $VSFTPD_USER_HOME_DIR
# EOB

#     fi
# done


set +e

if ! id -u "$FTP_USER" > /dev/null 2>&1; then
    # Add user
    useradd -Ums /bin/bash "$FTP_USER"
fi

# Set passwords to "dev"
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

set -e

# Add user to groups specified in FTP_USER_GROUPS as comma seperated list
if [[ -n "${FTP_USER_GROUPS+x}" ]]; then
    echo -n "${FTP_USER_GROUPS}" | xargs -rd, -n1 groupadd -f
    usermod -G "${FTP_USER_GROUPS}" "${FTP_USER}"
fi


echo '' >> /opt/docker/etc/vsftpd/vsftpd.conf
echo '# container env settings' >> /opt/docker/etc/vsftpd/vsftpd.conf


#!/usr/bin/env bash
set -e

source /opt/docker/functions/set-conf-setting.sh

# string_option OPTION VALUE
string_option() {
	setConfSetting "$1" "$2" /opt/docker/etc/vsftpd/vsftpd.conf
    # echo "$1=$2" >> /opt/docker/etc/vsftpd/vsftpd.temp.conf
}


#############################################################################
############################## STRING OPTIONS ###############################

if [[ -n "${VSFTP_ANON_ROOT+x}" ]]; then
	string_option "anon_root" "${VSFTP_ANON_ROOT}"
fi

if [[ -n "${VSFTP_BANNED_EMAIL_FILE+x}" ]]; then
	string_option "banned_email_file" "${VSFTP_BANNED_EMAIL_FILE}"
fi

if [[ -n "${VSFTP_BANNER_FILE+x}" ]]; then
	string_option "banner_file" "${VSFTP_BANNER_FILE}"
fi

if [[ -n "${VSFTP_CA_CERTS_FILE+x}" ]]; then
	string_option "ca_certs_file" "${VSFTP_CA_CERTS_FILE}"
fi

if [[ -n "${VSFTP_CHOWN_USERNAME+x}" ]]; then
	string_option "chown_username" "${VSFTP_CHOWN_USERNAME}"
fi

if [[ -n "${VSFTP_CHROOT_LIST_FILE+x}" ]]; then
	string_option "chroot_list_file" "${VSFTP_CHROOT_LIST_FILE}"
fi

if [[ -n "${VSFTP_CMDS_ALLOWED+x}" ]]; then
	string_option "cmds_allowed" "${VSFTP_CMDS_ALLOWED}"
fi

if [[ -n "${VSFTP_CMDS_DENIED+x}" ]]; then
	string_option "cmds_denied" "${VSFTP_CMDS_DENIED}"
fi

if [[ -n "${VSFTP_DENY_FILE+x}" ]]; then
	string_option "deny_file" "${VSFTP_DENY_FILE}"
fi

if [[ -n "${VSFTP_DSA_CERT_FILE+x}" ]]; then
	string_option "dsa_cert_file" "${VSFTP_DSA_CERT_FILE}"
fi

if [[ -n "${VSFTP_DSA_PRIVATE_KEY_FILE+x}" ]]; then
	string_option "dsa_private_key_file" "${VSFTP_DSA_PRIVATE_KEY_FILE}"
fi

if [[ -n "${VSFTP_EMAIL_PASSWORD_FILE+x}" ]]; then
	string_option "email_password_file" "${VSFTP_EMAIL_PASSWORD_FILE}"
fi

if [[ -n "${VSFTP_FTP_USERNAME+x}" ]]; then
	string_option "ftp_username" "${VSFTP_FTP_USERNAME}"
fi

if [[ -n "${VSFTP_FTPD_BANNER+x}" ]]; then
	string_option "ftpd_banner" "${VSFTP_FTPD_BANNER}"
fi

if [[ -n "${VSFTP_GUEST_USERNAME+x}" ]]; then
	string_option "guest_username" "${VSFTP_GUEST_USERNAME}"
fi

if [[ -n "${VSFTP_HIDE_FILE+x}" ]]; then
	string_option "hide_file" "${VSFTP_HIDE_FILE}"
fi

if [[ -n "${VSFTP_LISTEN_ADDRESS+x}" ]]; then
	string_option "listen_address" "${VSFTP_LISTEN_ADDRESS}"
fi

if [[ -n "${VSFTP_LISTEN_ADDRESS6+x}" ]]; then
	string_option "listen_address6" "${VSFTP_LISTEN_ADDRESS6}"
fi

if [[ -n "${VSFTP_LOCAL_ROOT+x}" ]]; then
	string_option "local_root" "${VSFTP_LOCAL_ROOT}"
fi

if [[ -n "${VSFTP_MESSAGE_FILE+x}" ]]; then
	string_option "message_file" "${VSFTP_MESSAGE_FILE}"
fi

if [[ -n "${VSFTP_NOPRIV_USER+x}" ]]; then
	string_option "nopriv_user" "${VSFTP_NOPRIV_USER}"
fi

if [[ -n "${VSFTP_PAM_SERVICE_NAME+x}" ]]; then
	string_option "pam_service_name" "${VSFTP_PAM_SERVICE_NAME}"
fi

if [[ -n "${VSFTP_PASV_ADDRESS+x}" ]]; then
	string_option "pasv_address" "${VSFTP_PASV_ADDRESS}"
fi

if [[ -n "${VSFTP_RSA_CERT_FILE+x}" ]]; then
	string_option "rsa_cert_file" "${VSFTP_RSA_CERT_FILE}"
fi

if [[ -n "${VSFTP_RSA_PRIVATE_KEY_FILE+x}" ]]; then
	string_option "rsa_private_key_file" "${VSFTP_RSA_PRIVATE_KEY_FILE}"
fi

if [[ -n "${VSFTP_SECURE_CHROOT_DIR+x}" ]]; then
	string_option "secure_chroot_dir" "${VSFTP_SECURE_CHROOT_DIR}"
fi

if [[ -n "${VSFTP_SSL_CIPHERS+x}" ]]; then
	string_option "ssl_ciphers" "${VSFTP_SSL_CIPHERS}"
fi

if [[ -n "${VSFTP_USER_CONFIG_DIR+x}" ]]; then
	string_option "user_config_dir" "${VSFTP_USER_CONFIG_DIR}"
fi

if [[ -n "${VSFTP_USER_SUB_TOKEN+x}" ]]; then
	string_option "user_sub_token" "${VSFTP_USER_SUB_TOKEN}"
fi

if [[ -n "${VSFTP_USERLIST_FILE+x}" ]]; then
	string_option "userlist_file" "${VSFTP_USERLIST_FILE}"
fi

if [[ -n "${VSFTP_VSFTPD_LOG_FILE+x}" ]]; then
	string_option "vsftpd_log_file" "${VSFTP_VSFTPD_LOG_FILE}"
fi

if [[ -n "${VSFTP_XFERLOG_FILE+x}" ]]; then
	string_option "xferlog_file" "${VSFTP_XFERLOG_FILE}"
fi
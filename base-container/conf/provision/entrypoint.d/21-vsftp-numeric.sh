#!/usr/bin/env bash
set -e

source /opt/docker/functions/set-conf-setting.sh

# numeric_option OPTION VALUE
numeric_option() {
    declare OPTION="$1" VALUE="$2"
    declare REGEX='^[0-9]+$'

    if ! [[ "$VALUE" =~ $REGEX ]]; then
        echo "Error: VSFTP_${OPTION^^} must be an integer" >&2
        return 1
    fi

	setConfSetting "$OPTION" "$VALUE" /opt/docker/etc/vsftpd/vsftpd.conf
}

if [[ -n "${VSFTP_ACCEPT_TIMEOUT+x}" ]]; then
	numeric_option "accept_timeout" "${VSFTP_ACCEPT_TIMEOUT}"
fi

if [[ -n "${VSFTP_ANON_MAX_RATE+x}" ]]; then
	numeric_option "anon_max_rate" "${VSFTP_ANON_MAX_RATE}"
fi

if [[ -n "${VSFTP_ANON_UMASK+x}" ]]; then
	numeric_option "anon_umask" "${VSFTP_ANON_UMASK}"
fi

if [[ -n "${VSFTP_CHOWN_UPLOAD_MODE+x}" ]]; then
	numeric_option "chown_upload_mode" "${VSFTP_CHOWN_UPLOAD_MODE}"
fi

if [[ -n "${VSFTP_CONNECT_TIMEOUT+x}" ]]; then
	numeric_option "connect_timeout" "${VSFTP_CONNECT_TIMEOUT}"
fi

if [[ -n "${VSFTP_DATA_CONNECTION_TIMEOUT+x}" ]]; then
	numeric_option "data_connection_timeout" "${VSFTP_DATA_CONNECTION_TIMEOUT}"
fi

if [[ -n "${VSFTP_DELAY_FAILED_LOGIN+x}" ]]; then
	numeric_option "delay_failed_login" "${VSFTP_DELAY_FAILED_LOGIN}"
fi

if [[ -n "${VSFTP_DELAY_SUCCESSFUL_LOGIN+x}" ]]; then
	numeric_option "delay_successful_login" "${VSFTP_DELAY_SUCCESSFUL_LOGIN}"
fi

if [[ -n "${VSFTP_FILE_OPEN_MODE+x}" ]]; then
	numeric_option "file_open_mode" "${VSFTP_FILE_OPEN_MODE}"
fi

if [[ -n "${VSFTP_FTP_DATA_PORT+x}" ]]; then
	numeric_option "ftp_data_port" "${VSFTP_FTP_DATA_PORT}"
fi

if [[ -n "${VSFTP_IDLE_SESSION_TIMEOUT+x}" ]]; then
	numeric_option "idle_session_timeout" "${VSFTP_IDLE_SESSION_TIMEOUT}"
fi

if [[ -n "${VSFTP_LISTEN_PORT+x}" ]]; then
	numeric_option "listen_port" "${VSFTP_LISTEN_PORT}"
fi

if [[ -n "${VSFTP_LOCAL_MAX_RATE+x}" ]]; then
	numeric_option "local_max_rate" "${VSFTP_LOCAL_MAX_RATE}"
fi

if [[ -n "${VSFTP_LOCAL_UMASK+x}" ]]; then
	numeric_option "local_umask" "${VSFTP_LOCAL_UMASK}"
fi

if [[ -n "${VSFTP_MAX_CLIENTS+x}" ]]; then
	numeric_option "max_clients" "${VSFTP_MAX_CLIENTS}"
fi

if [[ -n "${VSFTP_MAX_LOGIN_FAILS+x}" ]]; then
	numeric_option "max_login_fails" "${VSFTP_MAX_LOGIN_FAILS}"
fi

if [[ -n "${VSFTP_MAX_PER_IP+x}" ]]; then
	numeric_option "max_per_ip" "${VSFTP_MAX_PER_IP}"
fi

if [[ -n "${VSFTP_PASV_MAX_PORT+x}" ]]; then
	numeric_option "pasv_max_port" "${VSFTP_PASV_MAX_PORT}"
fi

if [[ -n "${VSFTP_PASV_MIN_PORT+x}" ]]; then
	numeric_option "pasv_min_port" "${VSFTP_PASV_MIN_PORT}"
fi

if [[ -n "${VSFTP_TRANS_CHUNK_SIZE+x}" ]]; then
	numeric_option "trans_chunk_size" "${VSFTP_TRANS_CHUNK_SIZE}"
fi

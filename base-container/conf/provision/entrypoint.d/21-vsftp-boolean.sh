#!/usr/bin/env bash
set -e

source /opt/docker/functions/set-conf-setting.sh

# boolean_option OPTION VALUE
boolean_option() {
    declare OPTION="$1" VALUE="$2"

    case "${VALUE,,}" in
        0|no|false)
            VALUE=NO
        ;;
        1|yes|true)
            VALUE=YES
        ;;
        *)
			echo "Error: VSFTP_${OPTION^^} must be a valid boolean value" >&2
            return 1
        ;;
    esac

	setConfSetting "$OPTION" "$VALUE" /opt/docker/etc/vsftpd.conf
}

if [[ -n "${VSFTP_ALLOW_ANON_SSL+x}" ]]; then
	boolean_option "allow_anon_ssl" "${VSFTP_ALLOW_ANON_SSL}"
fi

if [[ -n "${VSFTP_ANON_MKDIR_WRITE_ENABLE+x}" ]]; then
	boolean_option "anon_mkdir_write_enable" "${VSFTP_ANON_MKDIR_WRITE_ENABLE}"
fi

if [[ -n "${VSFTP_ANON_OTHER_WRITE_ENABLE+x}" ]]; then
	boolean_option "anon_other_write_enable" "${VSFTP_ANON_OTHER_WRITE_ENABLE}"
fi

if [[ -n "${VSFTP_ANON_UPLOAD_ENABLE+x}" ]]; then
	boolean_option "anon_upload_enable" "${VSFTP_ANON_UPLOAD_ENABLE}"
fi

if [[ -n "${VSFTP_ANON_WORLD_READABLE_ONLY+x}" ]]; then
	boolean_option "anon_world_readable_only" "${VSFTP_ANON_WORLD_READABLE_ONLY}"
fi

if [[ -n "${VSFTP_ANONYMOUS_ENABLE+x}" ]]; then
	boolean_option "anonymous_enable" "${VSFTP_ANONYMOUS_ENABLE}"
fi

if [[ -n "${VSFTP_ASCII_DOWNLOAD_ENABLE+x}" ]]; then
	boolean_option "ascii_download_enable" "${VSFTP_ASCII_DOWNLOAD_ENABLE}"
fi

if [[ -n "${VSFTP_ASCII_UPLOAD_ENABLE+x}" ]]; then
	boolean_option "ascii_upload_enable" "${VSFTP_ASCII_UPLOAD_ENABLE}"
fi

if [[ -n "${VSFTP_ASYNC_ABOR_ENABLE+x}" ]]; then
	boolean_option "async_abor_enable" "${VSFTP_ASYNC_ABOR_ENABLE}"
fi

if [[ -n "${VSFTP_BACKGROUND+x}" ]]; then
	boolean_option "background" "${VSFTP_BACKGROUND}"
fi

if [[ -n "${VSFTP_CHECK_SHELL+x}" ]]; then
	boolean_option "check_shell" "${VSFTP_CHECK_SHELL}"
fi

if [[ -n "${VSFTP_CHMOD_ENABLE+x}" ]]; then
	boolean_option "chmod_enable" "${VSFTP_CHMOD_ENABLE}"
fi

if [[ -n "${VSFTP_CHOWN_UPLOADS+x}" ]]; then
	boolean_option "chown_uploads" "${VSFTP_CHOWN_UPLOADS}"
fi

if [[ -n "${VSFTP_CHROOT_LIST_ENABLE+x}" ]]; then
	boolean_option "chroot_list_enable" "${VSFTP_CHROOT_LIST_ENABLE}"
fi

if [[ -n "${VSFTP_CHROOT_LOCAL_USER+x}" ]]; then
	boolean_option "chroot_local_user" "${VSFTP_CHROOT_LOCAL_USER}"
fi

if [[ -n "${VSFTP_CONNECT_FROM_PORT_20+x}" ]]; then
	boolean_option "connect_from_port_20" "${VSFTP_CONNECT_FROM_PORT_20}"
fi

if [[ -n "${VSFTP_DEBUG_SSL+x}" ]]; then
	boolean_option "debug_ssl" "${VSFTP_DEBUG_SSL}"
fi

if [[ -n "${VSFTP_DELETE_FAILED_UPLOADS+x}" ]]; then
	boolean_option "delete_failed_uploads" "${VSFTP_DELETE_FAILED_UPLOADS}"
fi

if [[ -n "${VSFTP_DENY_EMAIL_ENABLE+x}" ]]; then
	boolean_option "deny_email_enable" "${VSFTP_DENY_EMAIL_ENABLE}"
fi

if [[ -n "${VSFTP_DIRLIST_ENABLE+x}" ]]; then
	boolean_option "dirlist_enable" "${VSFTP_DIRLIST_ENABLE}"
fi

if [[ -n "${VSFTP_DIRMESSAGE_ENABLE+x}" ]]; then
	boolean_option "dirmessage_enable" "${VSFTP_DIRMESSAGE_ENABLE}"
fi

if [[ -n "${VSFTP_DOWNLOAD_ENABLE+x}" ]]; then
	boolean_option "download_enable" "${VSFTP_DOWNLOAD_ENABLE}"
fi

if [[ -n "${VSFTP_DUAL_LOG_ENABLE+x}" ]]; then
	boolean_option "dual_log_enable" "${VSFTP_DUAL_LOG_ENABLE}"
fi

if [[ -n "${VSFTP_FORCE_DOT_FILES+x}" ]]; then
	boolean_option "force_dot_files" "${VSFTP_FORCE_DOT_FILES}"
fi

if [[ -n "${VSFTP_FORCE_ANON_DATA_SSL+x}" ]]; then
	boolean_option "force_anon_data_ssl" "${VSFTP_FORCE_ANON_DATA_SSL}"
fi

if [[ -n "${VSFTP_FORCE_ANON_LOGINS_SSL+x}" ]]; then
	boolean_option "force_anon_logins_ssl" "${VSFTP_FORCE_ANON_LOGINS_SSL}"
fi

if [[ -n "${VSFTP_FORCE_LOCAL_DATA_SSL+x}" ]]; then
	boolean_option "force_local_data_ssl" "${VSFTP_FORCE_LOCAL_DATA_SSL}"
fi

if [[ -n "${VSFTP_FORCE_LOCAL_LOGINS_SSL+x}" ]]; then
	boolean_option "force_local_logins_ssl" "${VSFTP_FORCE_LOCAL_LOGINS_SSL}"
fi

if [[ -n "${VSFTP_GUEST_ENABLE+x}" ]]; then
	boolean_option "guest_enable" "${VSFTP_GUEST_ENABLE}"
fi

if [[ -n "${VSFTP_HIDE_IDS+x}" ]]; then
	boolean_option "hide_ids" "${VSFTP_HIDE_IDS}"
fi

if [[ -n "${VSFTP_IMPLICIT_SSL+x}" ]]; then
	boolean_option "implicit_ssl" "${VSFTP_IMPLICIT_SSL}"
fi

if [[ -n "${VSFTP_LISTEN+x}" ]]; then
	boolean_option "listen" "${VSFTP_LISTEN}"
fi

if [[ -n "${VSFTP_LISTEN_IPV6+x}" ]]; then
	boolean_option "listen_ipv6" "${VSFTP_LISTEN_IPV6}"
fi

if [[ -n "${VSFTP_LOCAL_ENABLE+x}" ]]; then
	boolean_option "local_enable" "${VSFTP_LOCAL_ENABLE}"
fi

if [[ -n "${VSFTP_LOCK_UPLOAD_FILES+x}" ]]; then
	boolean_option "lock_upload_files" "${VSFTP_LOCK_UPLOAD_FILES}"
fi

if [[ -n "${VSFTP_LOG_FTP_PROTOCOL+x}" ]]; then
	boolean_option "log_ftp_protocol" "${VSFTP_LOG_FTP_PROTOCOL}"
fi

if [[ -n "${VSFTP_LS_RECURSE_ENABLE+x}" ]]; then
	boolean_option "ls_recurse_enable" "${VSFTP_LS_RECURSE_ENABLE}"
fi

if [[ -n "${VSFTP_MDTM_WRITE+x}" ]]; then
	boolean_option "mdtm_write" "${VSFTP_MDTM_WRITE}"
fi

if [[ -n "${VSFTP_NO_ANON_PASSWORD+x}" ]]; then
	boolean_option "no_anon_password" "${VSFTP_NO_ANON_PASSWORD}"
fi

if [[ -n "${VSFTP_NO_LOG_LOCK+x}" ]]; then
	boolean_option "no_log_lock" "${VSFTP_NO_LOG_LOCK}"
fi

if [[ -n "${VSFTP_ONE_PROCESS_MODEL+x}" ]]; then
	boolean_option "one_process_model" "${VSFTP_ONE_PROCESS_MODEL}"
fi

if [[ -n "${VSFTP_PASSWD_CHROOT_ENABLE+x}" ]]; then
	boolean_option "passwd_chroot_enable" "${VSFTP_PASSWD_CHROOT_ENABLE}"
fi

if [[ -n "${VSFTP_PASV_ADDR_RESOLVE+x}" ]]; then
	boolean_option "pasv_addr_resolve" "${VSFTP_PASV_ADDR_RESOLVE}"
fi

if [[ -n "${VSFTP_PASV_ENABLE+x}" ]]; then
	boolean_option "pasv_enable" "${VSFTP_PASV_ENABLE}"
fi

if [[ -n "${VSFTP_PASV_PROMISCUOUS+x}" ]]; then
	boolean_option "pasv_promiscuous" "${VSFTP_PASV_PROMISCUOUS}"
fi

if [[ -n "${VSFTP_PORT_ENABLE+x}" ]]; then
	boolean_option "port_enable" "${VSFTP_PORT_ENABLE}"
fi

if [[ -n "${VSFTP_PORT_PROMISCUOUS+x}" ]]; then
	boolean_option "port_promiscuous" "${VSFTP_PORT_PROMISCUOUS}"
fi

if [[ -n "${VSFTP_REQUIRE_CERT+x}" ]]; then
	boolean_option "require_cert" "${VSFTP_REQUIRE_CERT}"
fi

if [[ -n "${VSFTP_REQUIRE_SSL_REUSE+x}" ]]; then
	boolean_option "require_ssl_reuse" "${VSFTP_REQUIRE_SSL_REUSE}"
fi

if [[ -n "${VSFTP_REVERSE_LOOKUP_ENABLE+x}" ]]; then
	boolean_option "reverse_lookup_enable" "${VSFTP_REVERSE_LOOKUP_ENABLE}"
fi

if [[ -n "${VSFTP_RUN_AS_LAUNCHING_USER+x}" ]]; then
	boolean_option "run_as_launching_user" "${VSFTP_RUN_AS_LAUNCHING_USER}"
fi

if [[ -n "${VSFTP_SECURE_EMAIL_LIST_ENABLE+x}" ]]; then
	boolean_option "secure_email_list_enable" "${VSFTP_SECURE_EMAIL_LIST_ENABLE}"
fi

if [[ -n "${VSFTP_SESSION_SUPPORT+x}" ]]; then
	boolean_option "session_support" "${VSFTP_SESSION_SUPPORT}"
fi

if [[ -n "${VSFTP_SETPROCTITLE_ENABLE+x}" ]]; then
	boolean_option "setproctitle_enable" "${VSFTP_SETPROCTITLE_ENABLE}"
fi

if [[ -n "${VSFTP_SSL_ENABLE+x}" ]]; then
	boolean_option "ssl_enable" "${VSFTP_SSL_ENABLE}"
fi

if [[ -n "${VSFTP_SSL_REQUEST_CERT+x}" ]]; then
	boolean_option "ssl_request_cert" "${VSFTP_SSL_REQUEST_CERT}"
fi

if [[ -n "${VSFTP_SSL_SSLV2+x}" ]]; then
	boolean_option "ssl_sslv2" "${VSFTP_SSL_SSLV2}"
fi

if [[ -n "${VSFTP_SSL_SSLV3+x}" ]]; then
	boolean_option "ssl_sslv3" "${VSFTP_SSL_SSLV3}"
fi

if [[ -n "${VSFTP_SSL_TLSV1+x}" ]]; then
	boolean_option "ssl_tlsv1" "${VSFTP_SSL_TLSV1}"
fi

if [[ -n "${VSFTP_STRICT_SSL_READ_EOF+x}" ]]; then
	boolean_option "strict_ssl_read_eof" "${VSFTP_STRICT_SSL_READ_EOF}"
fi

if [[ -n "${VSFTP_STRICT_SSL_WRITE_SHUTDOWN+x}" ]]; then
	boolean_option "strict_ssl_write_shutdown" "${VSFTP_STRICT_SSL_WRITE_SHUTDOWN}"
fi

if [[ -n "${VSFTP_SYSLOG_ENABLE+x}" ]]; then
	boolean_option "syslog_enable" "${VSFTP_SYSLOG_ENABLE}"
fi

if [[ -n "${VSFTP_TCP_WRAPPERS+x}" ]]; then
	boolean_option "tcp_wrappers" "${VSFTP_TCP_WRAPPERS}"
fi

if [[ -n "${VSFTP_TEXT_USERDB_NAMES+x}" ]]; then
	boolean_option "text_userdb_names" "${VSFTP_TEXT_USERDB_NAMES}"
fi

if [[ -n "${VSFTP_TILDE_USER_ENABLE+x}" ]]; then
	boolean_option "tilde_user_enable" "${VSFTP_TILDE_USER_ENABLE}"
fi

if [[ -n "${VSFTP_USE_LOCALTIME+x}" ]]; then
	boolean_option "use_localtime" "${VSFTP_USE_LOCALTIME}"
fi

if [[ -n "${VSFTP_USE_SENDFILE+x}" ]]; then
	boolean_option "use_sendfile" "${VSFTP_USE_SENDFILE}"
fi

if [[ -n "${VSFTP_USERLIST_DENY+x}" ]]; then
	boolean_option "userlist_deny" "${VSFTP_USERLIST_DENY}"
fi

if [[ -n "${VSFTP_USERLIST_ENABLE+x}" ]]; then
	boolean_option "userlist_enable" "${VSFTP_USERLIST_ENABLE}"
fi

if [[ -n "${VSFTP_VALIDATE_CERT+x}" ]]; then
	boolean_option "validate_cert" "${VSFTP_VALIDATE_CERT}"
fi

if [[ -n "${VSFTP_USERLIST_LOG+x}" ]]; then
	boolean_option "userlist_log" "${VSFTP_USERLIST_LOG}"
fi

if [[ -n "${VSFTP_VIRTUAL_USE_LOCAL_PRIVS+x}" ]]; then
	boolean_option "virtual_use_local_privs" "${VSFTP_VIRTUAL_USE_LOCAL_PRIVS}"
fi

if [[ -n "${VSFTP_WRITE_ENABLE+x}" ]]; then
	boolean_option "write_enable" "${VSFTP_WRITE_ENABLE}"
fi

if [[ -n "${VSFTP_XFERLOG_ENABLE+x}" ]]; then
	boolean_option "xferlog_enable" "${VSFTP_XFERLOG_ENABLE}"
fi

if [[ -n "${VSFTP_XFERLOG_STD_FORMAT+x}" ]]; then
	boolean_option "xferlog_std_format" "${VSFTP_XFERLOG_STD_FORMAT}"
fi

if [[ -n "${VSFTP_ISOLATE_NETWORK+x}" ]]; then
	boolean_option "isolate_network" "${VSFTP_ISOLATE_NETWORK}"
fi

if [[ -n "${VSFTP_ISOLATE+x}" ]]; then
	boolean_option "isolate" "${VSFTP_ISOLATE}"
fi

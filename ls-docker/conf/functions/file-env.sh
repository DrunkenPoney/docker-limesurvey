#!/usr/bin/env bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
function fileEnv() {
    declare var="$1"
    declare fileVar="${1}_FILE"
    declare val="${2:-}"

    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo "error: both ${var} and ${fileVar} are set (but are exclusive)" >&2
		exit 1
	fi

    if [ "${!var:-}" ]; then
        val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi

	export "${var}"="${val}"
	unset "${fileVar}"
}

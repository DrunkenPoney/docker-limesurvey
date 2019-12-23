#!/usr/bin/env bash

function setConfigLS() {
    declare DFLT_CFG_FILE="${WEB_DOCUMENT_ROOT}/application/config/config.php"
    declare DFLT_ARRAY='config'
    declare cfgFile="$DFLT_CFG_FILE"
    declare array="$DFLT_ARRAY"
    declare value='' key='' arg=''
    declare -a args

    while (( $# > 0 )); do
        arg="$1" && shift
        case "$arg" in
            --file=*)
                cfgFile="${arg#*=}"
            ;;
            -f|--file)
                cfgFile="$1"
                shift
            ;;
            --value=*)
                value="${arg#*=}"
            ;;
            -v|--value)
                value="$1"
                shift
            ;;
            --key=*)
                key="${arg#*=}"
            ;;
            -k|--key)
                key="$1"
                shift
            ;;
            --array=*)
                array="${arg#*=}"
            ;;
            -a|--array)
                array="$1"
                shift
            ;;
            -h|--help)
                echo >&2 'Set a LimeSurvey configuration option.'
                echo >&2 ''
                echo >&2 'Usage:'
                echo >&2 '  setConfigLS [options...] <KEY> <VALUE>'
                echo >&2 '  setConfigLS [options...] --value=<VALUE> --key=<KEY>'
                echo >&2 ''
                echo >&2 'Options:'
                echo >&2 '  --file, -f <CONFIG_FILE>  LimeSurvey configuration file.'
                echo >&2 "                              Default: ${DFLT_CFG_FILE}"
                echo >&2 '  --array, -a <ARRAY>       Name of array containing the configuration.'
                echo >&2 "                              Default: ${DFLT_ARRAY}"
                echo >&2 '  --key, --k <KEY>          Key of the configuration option to set. (required)'
                echo >&2 '  --value, -v <VALUE>       Value of the configuration option. (required)'
                echo >&2 '  --help, -h                Prints this message.'
                echo >&2 ''
                return 0
            ;;
            *)
                args+=( "$arg" )
            ;;
        esac
    done

    if [ -z "$key" ]; then
        if (( ${#args} > 0 )); then
            key="${args[0]}"
            args=( "${args[@]:1}" )
        else
            echo 'Error: `--key` is required' >&2
            return 1
        fi
    fi

    if [ -z "$value" ]; then
        if (( ${#args} > 0 )); then
            value="${args[0]}"
            args=( "${args[@]:1}" )
        else
            echo 'Error: `--value` is required' >&2
            return 1
        fi
    fi

    if (( ${#args} > 0 )); then
        echo 'Error: too many arguments' >&2
        return 1
    fi

    array="${array//\//\\\/}"
    value="${value//$'\n'/\\$'\n'}"

    ssed -Ri "$cfgFile" \
        -e 's~^(\s*)('"${array}"'\s*=>\s*array\s*\()((?:\([^)]*\)|[^)])+)~\1\2\n\1    \3\n\1~'

    ssed -Ri "$cfgFile" \
        -e '/^\s*'"${array}"'\s*=>\s*array\s*\([^)]*$/ {
                :a
                n
                s~^((?:\s*(?:[^,/\s]|/[^/]))+)(\s*//.*)?$~\1,\2~
                s~^(\s*)//\s*('"${key//~/\\~}"'\s*=>)~\1\2~
                /^\s*\)/ {
                    i \        '"${key}"'=>'"${value}"',
                    bq
                }
                /^\s*'"${key//\//\\\/}"'\s*=>/ {
                    s~>.*~>'"${value//~/\\~}"',~
                    bq
                }
                ba
                :q
            }'
}


# function setConfigLS() {
#     declare key="'$1'" value="${2//$'\n'/\\$'\n'}" config="'${3:-config}'"
#     # value="$(echo "$value" | tr '\n' '\0' | xargs -0rl1 printf '%s\\\n')"
#     ssed -Ri "${WEB_DOCUMENT_ROOT}/application/config/config.php" \
#         -e 's~^(\s*)('"${config}"'\s*=>\s*array\s*\()((?:\([^)]*\)|[^)])+)~\1\2\n\1    \3\n\1~'
#     ssed -Ri "${WEB_DOCUMENT_ROOT}/application/config/config.php" \
#         -e '/^\s*'"${config}"'\s*=>\s*array\s*\([^)]*$/ {
#                 :a
#                 n
#                 s~^((?:\s*(?:[^,/\s]|/[^/]))+)(\s*//.*)?$~\1,\2~
#                 s~^(\s*)//\s*('"${key}"'\s*=>)~\1\2~
#                 /^\s*\)/ {
#                     i \        '"${key}"'=>'"${value}"',
#                     bq
#                 }
#                 /^\s*'"${key}"'\s*=>/ {
#                     s~>.*~>'"${value//~/\\~}"',~
#                     bq
#                 }
#                 ba
#                 :q
#             }'
#     # ssed -Ri "/'$key'/ s/>\(.*\)/>$value,/1"  application/config/config.php
# }
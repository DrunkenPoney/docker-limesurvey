#!/usr/bin/env bash
set -eu

declare FUNC_DIR='/opt/docker/functions'
declare APP_DIR="${WEB_DOCUMENT_ROOT}"
declare DB_SETUP_PHP="/opt/docker/db_setup.php"

source "${FUNC_DIR}/tty-loggers.sh"
source "${FUNC_DIR}/yes-no.sh"
source "${FUNC_DIR}/file-env.sh"
source "${FUNC_DIR}/set-config-ls.sh"
source "${FUNC_DIR}/env-list-vars.sh"


####################################################################
########################## Setup Variables #########################

fileEnv 'LIMESURVEY_DB_TYPE' 'mysql'
fileEnv 'LIMESURVEY_DB_HOST' 'mysql'
fileEnv 'LIMESURVEY_DB_PORT' '3306'
fileEnv 'LIMESURVEY_TABLE_PREFIX' ''
fileEnv 'LIMESURVEY_ADMIN_NAME' 'Lime Administrator'
fileEnv 'LIMESURVEY_ADMIN_EMAIL' 'lime@lime.lime'
fileEnv 'LIMESURVEY_ADMIN_USER' ''
fileEnv 'LIMESURVEY_ADMIN_PASSWORD' ''
fileEnv 'LIMESURVEY_DEBUG' '0'
fileEnv 'LIMESURVEY_SQL_DEBUG' '0'
fileEnv 'MYSQL_SSL_CA' ''
fileEnv 'LIMESURVEY_USE_INNODB' ''

# if we're linked to MySQL and thus have credentials already, let's use them
fileEnv 'LIMESURVEY_DB_NAME' "${MYSQL_ENV_MYSQL_DATABASE:-limesurvey}"
fileEnv 'LIMESURVEY_DB_USER' "${MYSQL_ENV_MYSQL_USER:-root}"

if [ "${LIMESURVEY_DB_USER}" = 'root' ]; then
    fileEnv 'LIMESURVEY_DB_PASSWORD' "${MYSQL_ENV_MYSQL_ROOT_PASSWORD:-}"
else
    fileEnv 'LIMESURVEY_DB_PASSWORD' "${MYSQL_ENV_MYSQL_PASSWORD:-}"
fi

if [ -z "${LIMESURVEY_DB_PASSWORD}" ]; then
    logError 'error: missing required LIMESURVEY_DB_PASSWORD environment variable' >&2
    logError '  Did you forget to -e LIMESURVEY_DB_PASSWORD=... ?' >&2
    logError '' >&2
    logError '  (Also of interest might be LIMESURVEY_DB_USER and LIMESURVEY_DB_NAME.)' >&2
    exit 1
fi

declare -A CONNECTION_STRINGS=(
    [mysql]="mysql:host=${LIMESURVEY_DB_HOST};port=${LIMESURVEY_DB_PORT};dbname=${LIMESURVEY_DB_NAME};"
    [dblib]="dblib:host=${LIMESURVEY_DB_HOST};dbname=${LIMESURVEY_DB_NAME}"
    [pgsql]="pgsql:host=${LIMESURVEY_DB_HOST};port=${LIMESURVEY_DB_PORT};user=${LIMESURVEY_DB_USER};password=${LIMESURVEY_DB_PASSWORD};dbname=${LIMESURVEY_DB_NAME};"
    [sqlsrv]="sqlsrv:Server=${LIMESURVEY_DB_HOST};Database=${LIMESURVEY_DB_NAME}"
)

if [ -z "${CONNECTION_STRINGS[${LIMESURVEY_DB_TYPE}]}" ]; then
    logError "error: invalid database type: ${LIMESURVEY_DB_TYPE}" >&2
    logError "  LIMESURVEY_DB_TYPE must be either \"mysql\", \"dblib\", \"pgsql\" or \"sqlsrv\"." >&2
    exit 1
fi


####################################################################
######################## Download LimeSurvey #######################

if [ ! -f "${APP_DIR}/.RELEASE_${LIMESURVEY_GIT_RELEASE}" ] || isYes "${LIMESURVEY_FORCE_FETCH}"; then
    find "$APP_DIR" -maxdepth 1 -type f -name '.RELEASE_*' -delete

    logInfo "Retrieving LimeSurvey... (this operation may take a while)" >&2
    wget -O "/tmp/lime.tar.gz" \
        --progress="$( [ -t 1 ] && echo 'bar:noscroll' || echo 'dot:mega' )" \
        "https://github.com/LimeSurvey/LimeSurvey/archive/${LIMESURVEY_GIT_RELEASE}.tar.gz"


    logInfo "Extracting files from archive..." >&2
    tar -xzf "/tmp/lime.tar.gz" \
        --strip-components=1 \
        --keep-newer-files \
        --exclude-vcs \
        --to-command='sh -c '\''
            mkdir -p "$(dirname "'"${APP_DIR}"'/$TAR_FILENAME")" &&
                touch "'"${APP_DIR}"'/$TAR_FILENAME" &&
                dd of="'"${APP_DIR}"'/$TAR_FILENAME" >/dev/null 2>&1 &&
                echo "'"${APP_DIR}"'/$TAR_FILENAME" '\' |
        xargs -I '{}' touch -t 195001010000 '{}'

    chown -R "${APPLICATION_USER}:${APPLICATION_GROUP}" "$APP_DIR"
    rm "/tmp/lime.tar.gz"

    touch ".RELEASE_${LIMESURVEY_GIT_RELEASE}"
fi


####################################################################
######################### LimeSurvey Setup #########################

# Install BaltimoreCyberTrustRoot.crt.pem
if [ ! -f "${APP_DIR}/BaltimoreCyberTrustRoot.crt.pem" ]; then
    logInfo "Downloading BaltimoreCyberTrustroot.crt.pem..."
    curl -fsSLo "${APP_DIR}/BaltimoreCyberTrustRoot.crt.pem" \
        "https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem"
fi

if [ ! -f "${APP_DIR}/application/config/config.php" ]; then
    logWarn "No config file for LimeSurvey"
    logWarn "  Copying default config file..."
    # Copy default config file but also allow for the addition of attributes
    echo "            'attributes' => array()," |
        awk '/lime_/ && c == 0 { c = 1; system("cat") } { print }' \
            "${APP_DIR}/application/config/config-sample-${LIMESURVEY_DB_TYPE}.php" \
            > "${APP_DIR}/application/config/config.php"
fi

# Set LimeSurvey configs
setConfigLS -a 'db' -k 'connectionString' "'${CONNECTION_STRINGS[${LIMESURVEY_DB_TYPE}]}'"
setConfigLS -a 'db' -k 'tablePrefix' "'${LIMESURVEY_TABLE_PREFIX}'"
setConfigLS -a 'db' -k 'username' "'${LIMESURVEY_DB_USER}'"
setConfigLS -a 'db' -k 'password' "'${LIMESURVEY_DB_PASSWORD}'"
setConfigLS -a 'urlManager' -k 'urlFormat' "'path'"
setConfigLS -k 'debug' "${LIMESURVEY_DEBUG}"
setConfigLS -k 'debugsql' "${LIMESURVEY_SQL_DEBUG}"

if [ -n "${MYSQL_SSL_CA}" ]; then
    setConfigLS -a 'db' 'attributes' \
        "array(PDO::MYSQL_ATTR_SSL_CA => '${APP_DIR//\//\\\/}\/${MYSQL_SSL_CA}',
            PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false)"
fi

declare cfg key val
for ENV_VAR in $(envListVars "limesurvey\."); do
        val="$(envGetValue "$ENV_VAR")"
        cfg="${ENV_VAR#limesurvey.}"
        cfg="${cfg%%.*}"
        key="${ENV_VAR#limesurvey.*.}"
        setConfigLS -a "$cfg" "$key" "$val"
done

mkdir -p "${APP_DIR}/upload/surveys"
chown -R "${APPLICATION_USER}:${APPLICATION_GROUP}" \
    "${APP_DIR}/tmp" "${APP_DIR}/upload" "${APP_DIR}/application/config"

####################################################################
#################### LimeSurvey Database Setup #####################

if [ -n "${LIMESURVEY_USE_INNODB}" ]; then
    # If you want to use INNODB - remove MyISAM specification from LimeSurvey code
    sed -i "/ENGINE=MyISAM/s/\(ENGINE=MyISAM \)//1" \
        "${APP_DIR}/application/core/db/MysqlSchema.php"
fi

logInfo "Waiting for database..." >&2
while ! curl -sL "${LIMESURVEY_DB_HOST}:${LIMESURVEY_DB_PORT:-3306}"; do sleep 1; done

DBSTATUS=$(TERM=dumb php -f "$DB_SETUP_PHP" -- \
    "${LIMESURVEY_DB_HOST}" "${LIMESURVEY_DB_USER}" "${LIMESURVEY_DB_PASSWORD}" \
    "${LIMESURVEY_DB_NAME}" "${LIMESURVEY_TABLE_PREFIX}" "${MYSQL_SSL_CA}" \
    "${APP_DIR}") &>/dev/null

if [ "${DBSTATUS}" != "DBEXISTS" ] &&  [ -n "${LIMESURVEY_ADMIN_USER}" ] && [ -n "${LIMESURVEY_ADMIN_PASSWORD}" ]; then
    logInfo 'Database not yet populated - installing Limesurvey database' >&2
    su - "${APPLICATION_USER}" \
        -c php -f "${APP_DIR}/application/commands/console.php" -- \
            install "${LIMESURVEY_ADMIN_USER}" "${LIMESURVEY_ADMIN_PASSWORD}" \
            "${LIMESURVEY_ADMIN_NAME}" "${LIMESURVEY_ADMIN_EMAIL}" verbose
fi

if [ -f "${APP_DIR}/application/commands/UpdateDbCommand.php" ]; then
    logInfo 'Updating database...' >&2
    su - "${APPLICATION_USER}" -c php "${APP_DIR}/application/commands/console.php" updatedb
else
    logWarn 'WARNING: Manual database update may be required!' >&2
fi

if [ -n "${LIMESURVEY_ADMIN_USER}" ] && [ -n "${LIMESURVEY_ADMIN_PASSWORD}" ]; then
    logInfo 'Updating password for admin user...' >&2
    su - "${APPLICATION_USER}" \
        -c php -f "${APP_DIR}/application/commands/console.php" -- \
            resetpassword "${LIMESURVEY_ADMIN_USER}" "${LIMESURVEY_ADMIN_PASSWORD}"
fi
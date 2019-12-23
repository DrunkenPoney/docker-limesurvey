#!/bin/bash
set -eu

###### IMPORTATION DES DONNÉES ######

# docker-servie-start mysql

if [[ "${IMPORT_ENABLED}" == "1" ]]; then
    # mysqladmin create "${MYSQL_DATABASE}"
    mysqldump -h "${IMPORT_BD_HOST}" \
        -P "${IMPORT_BD_PORT}" \
        -u "${IMPORT_BD_USER}" \
        --password="${IMPORT_BD_PASS}" \
        --single-transaction \
        "${IMPORT_BD_NAME}" |
        mysql -u root \
            --password="${MYSQL_ROOT_PASSWORD}" \
            -D "${MYSQL_DATABASE}"
else
    echo "Aucune données importées! (importation désactivée)"
fi

###### CRÉATION DES UTILISATEURS ######

mysql -u root --password="${MYSQL_ROOT_PASSWORD}" <<EOFMYSQL
SELECT 'Création de l\'utilisateur «${MYSQL_USER}»...';

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';

ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;


SELECT 'Création de l\'utilisateur «${MYSQL_ADMIN_USER}»...';

CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ADMIN_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ADMIN_PASSWORD}';

ALTER USER '${MYSQL_ADMIN_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ADMIN_PASSWORD}';
ALTER USER '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ADMIN_PASSWORD}';

GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;
EOFMYSQL

#!/bin/bash
set -eu

source /opt/docker/functions/tty-loggers.sh

declare PIWIK_TAG=master
[ "${LIMESURVEY_GIT_RELEASE:0:1}" -lt 3 ] && PIWIK_TAG=7505d2c629a0ed4992e7eece6b1f8a21fc05b706

logInfo "Retrieving PiwikPlugin (${PIWIK_TAG})..." >&2
curl -sSL -o '/tmp/piwik.tar.gz' \
    "https://github.com/SteveCohen/Piwik-for-Limesurvey/archive/${PIWIK_TAG}.tar.gz"

mkdir -p "${WEB_DOCUMENT_ROOT}/plugins/PiwikPlugin"
chown "${APPLICATION_USER}:${APPLICATION_GROUP}" "${WEB_DOCUMENT_ROOT}/plugins/PiwikPlugin"

logInfo 'Extracting PiwikPlugin...' >&2
tar -xzf /tmp/piwik.tar.gz \
    --group="$APPLICATION_GROUP" \
    --owner="$APPLICATION_USER" \
    --exclude-vcs \
    --strip-components=2 \
    -C "${WEB_DOCUMENT_ROOT}/plugins/PiwikPlugin"

rm /tmp/piwik.tar.gz
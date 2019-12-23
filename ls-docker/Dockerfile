FROM drunkenponey/base-container:latest

ENV LIMESURVEY_GIT_RELEASE=2.05_plus_141123 \
    LIMESURVEY_FORCE_FETCH=0 \
    EDITOR=nano

ENV WATCHKEYS_DIRECTORY=/ssh-keys \
    WATCHKEYS_CONFIG_PATH=/ssh-keys/keys-mapping.cfg

ENV SSH_USER=admin \
    SSH_PASSWORD=admin \
    SSH_USER_GROUPS=admin,sudo,adm,application \
    SSH_DISABLE_OPTS=UsePAM \
    sshd.PermitRootLogin=yes

COPY conf/ /opt/docker/

RUN set -x \
    && echo '<?php phpinfo(); ?>' > "${WEB_DOCUMENT_ROOT}/info.php" \
    && chown "${APPLICATION_USER}:${APPLICATION_GROUP}" "${WEB_DOCUMENT_ROOT}/info.php" \
    && chmod g+w /app

# FTP(21) / SSH(22)
EXPOSE 21 22
# HTTP(80) / HTTPS(443)
EXPOSE 80 443
# XDEBUG
EXPOSE 9000

SHELL [ "/bin/bash", "-l", "-c" ]

VOLUME [ "/ssh-keys" ]

# CMD [ "/piwik.sh", "/entrypoint", "supervisord" ]

# ENTRYPOINT [ "/limesurvey.sh" ]



FROM webdevops/php-apache-dev:latest

RUN set -x \
    && sed -Ei /etc/dpkg/dpkg.cfg.d/excludes \
        -e 's:^(path-exclude=/usr/share/man):#\1:' \
        -e 's:^(path-exclude=/usr/share/doc/):\1lib:' \
    && apt-get update -q \
    && apt-get install -yq \
        curl dirmngr apt-transport-https lsb-release ca-certificates \
        apt-utils software-properties-common \
        man man-db manpages manpages-posix \
        glibc-doc gpg-agent pkg-config sudo \
        build-essential sysvinit-utils \
    && curl -sSL -o /usr/bin/svc \
        "https://git.launchpad.net/~usd-import-team/ubuntu/+source/init-system-helpers/plain/script/service?h=ubuntu/$(lsb_release -sc)" \
    && chmod +x /usr/bin/svc

RUN set -x \
    && curl -sSL https://api.github.com/repos/nodesource/distributions/contents/deb?ref=master \
        | sed -n '/^\s*"path":\s*"deb\/setup_[0-9]/ { s/^\s*"path":\s*"deb\///; s/",\s*$//; p }' \
        | sort -V | tail -n1 \
        | xargs -I '{}' curl -sSL 'https://deb.nodesource.com/{}' \
        | bash - \
    && apt-get update -q \
    && apt-get upgrade -yq \
    && echo -e '1\n1\n1' | env DEBIAN_FRONTEND=noninteractive \
        apt-get install -yq nodejs inotify-tools nano

RUN set -x \
    && apt-get install -yq \
        python python3 \
        python-pip python3-pip \
        libyaml-dev less \
    && python3 -m pip install -q --upgrade pip \
    && python3 -m pip install -q watchdog[watchmedo] \
    && phpenmod imap \
    && a2enmod rewrite

COPY conf/ /opt/docker/

################################# SSH #################################

ENV SSH_USER=${APPLICATION_USER} \
    SSH_USER_GROUPS=${APPLICATION_GROUP} \
    SSH_PASSWORD=${APPLICATION_USER}
    #SSH_DISABLE_OPTS
    #sshd.*

################################ VSFTP ################################

ENV FTP_USER=${SSH_USER} \
    FTP_USER_GROUPS=${SSH_USER_GROUPS} \
    FTP_PASSWORD=${SSH_PASSWORD} \
    FTP_PATH=${WEB_DOCUMENT_ROOT}

RUN set -x \
    && apt-get install -yq vsftpd ssed \
    && ln -sf /opt/docker/etc/vsftpd/vsftpd.conf /etc/vsftpd.conf \
    && mkdir -p \
            /var/run/vsftpd/empty \
            /var/log/supervisor

EXPOSE 20 21 12020 12021 12022 12023 12024 12025


############################## WATCHKEYS ##############################

ENV WATCHKEYS_CONFIG_PATH=/ssh-keys/keys-mapping.cfg \
    WATCHKEYS_DIRECTORY=/ssh-keys


#######################################################################

RUN docker-run-bootstrap
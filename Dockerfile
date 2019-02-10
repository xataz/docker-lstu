FROM mondedie/alpine-perl

ARG LSTU_VERSION=0.21-4
ARG BUILD_DATE

ENV GID=991 \
    UID=991 \
    SECRET=f6056062888a9a6aff1cc89dd3397853 \
    CONTACT=contact@domain.tld \
    WEBROOT=/ \
    ADMINPWD="s3cr3T"

LABEL description="lstu based on alpine" \
      tags="latest 0.21-4 0.21" \
      maintainer="xataz <https://github.com/mondediefr> <https://mondedie.fr>" \
      build_ver=${BUILD_DATE}

RUN apk add --update --no-cache --virtual .build-deps \
                build-base \
                openssl-dev \
                git \
                tar \
                perl-dev \
                libidn-dev \
                wget \
                postgresql-dev \
                libpng-dev \
                mariadb-dev \
                zlib-dev \
                mariadb-connector-c-dev \
                perl-devel-checklib \
    && apk add --update --no-cache \
                openssl \
                ca-certificates \
                libidn \
                postgresql-libs \
                libpng \
                perl-netaddr-ip \
                perl-io-socket-ssl \
                perl-dbd-pg \
                mariadb-client \
                zlib \
    && echo | cpan \
    && cpan install Carton \
    && git clone -b ${LSTU_VERSION} https://framagit.org/luc/lstu.git /usr/lstu \
    && cd /usr/lstu \
    && carton install --deployment --without=test \
    && perl -MCPAN -e 'install inc::latest' \
    && perl -MCPAN -e 'install Config::FromHash' \
    && apk del --no-cache .build-deps \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lstu/local/cache/*
#    && rm /usr/lstu/local/lib/perl5/x86_64-linux-thread-multi/auto/DBD/mysql/mysql.so
# This last one is a very weird fix for the following error:
# Can't load application from file "/usr/lstu/script/lstu": Can't load '/usr/lstu/local/lib/perl5/x86_64-linux-thread-multi/auto/DBD/mysql/mysql.so' for module DBD::mysql: Error relocating /usr/lstu/local/lib/perl5/x86_64-linux-thread-multi/auto/DBD/mysql/mysql.so: net_buffer_length: symbol not found at /usr/lib/perl5/core_perl/DynaLoader.pm line 193.

VOLUME /usr/lstu/data

EXPOSE 8282

COPY rootfs /
RUN mv /tmp/lstu.conf /usr/lstu/lstu.conf \
    && chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]

FROM alpine:3.8

ARG LSTU_VERSION=0.20-1

ENV GID=991 \
    UID=991 \
    SECRET=f6056062888a9a6aff1cc89dd3397853 \
    CONTACT=contact@domain.tld \
    WEBROOT=/ \
    ADMINPWD="s3cr3T"

LABEL description="lstu based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201805160600" \
      commit="7a0e602af4410af68f24b75201f701f22208bb0d"

RUN apk add --update --no-cache --virtual .build-deps \
                build-base \
                libressl-dev \
                ca-certificates \
                git \
                tar \
                perl-dev \
                libidn-dev \
                wget \
                postgresql-dev \
                libpng-dev \
                mariadb-dev \
    && apk add --update --no-cache \
                libressl \
                perl \
                libidn \
                tini \
                su-exec \
                perl-net-ssleay \
                postgresql-libs \
                perl-dbd-mysql \
                libpng \
    && echo | cpan \
    && cpan install Carton \
    && git clone -b ${LSTU_VERSION} https://framagit.org/luc/lstu.git /usr/lstu \
    && cd /usr/lstu \
    && carton install \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lstu/local/cache/* \
    && rm /usr/lstu/local/lib/perl5/x86_64-linux-thread-multi/auto/DBD/mysql/mysql.so
# This last one is a very weird fix for the following error:
# Can't load application from file "/usr/lstu/script/lstu": Can't load '/usr/lstu/local/lib/perl5/x86_64-linux-thread-multi/auto/DBD/mysql/mysql.so' for module DBD::mysql: Error relocating /usr/lstu/local/lib/perl5/x86_64-linux-thread-multi/auto/DBD/mysql/mysql.so: net_buffer_length: symbol not found at /usr/lib/perl5/core_perl/DynaLoader.pm line 193.

VOLUME /usr/lstu/data

EXPOSE 8282

COPY startup /usr/local/bin/startup
COPY lstu.conf /usr/lstu/lstu.conf
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]

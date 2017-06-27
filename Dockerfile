FROM xataz/alpine:3.6

ENV GID=991 \
    UID=991 \
    SECRET=f6056062888a9a6aff1cc89dd3397853 \
    CONTACT=contact@domain.tld \
    WEBROOT=/ \
    ADMINPWD="s3cr3T"

LABEL description="lstu based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="2017062601"

RUN BUILD_DEPS="build-base \
                libressl-dev \
                ca-certificates \
                git \
                tar \
                perl-dev \
                libidn-dev \
                wget \
                postgresql-dev" \
    && apk add -U ${BUILD_DEPS} \
                libressl \
                perl \
                libidn \
                tini \
                su-exec \
                perl-net-ssleay \
    && echo | cpan \
    && cpan install Carton \
    && git clone https://git.framasoft.org/luc/lstu.git /usr/lstu \
    && cd /usr/lstu \
    && carton install \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lstu/local/cache/* /usr/lstu/utilities
    
EXPOSE 8282

COPY startup /usr/local/bin/startup
COPY lstu.conf /usr/lstu/lstu.conf
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]

ARG NAMESPACE="local"
ARG OS_VERSION="3.21"
ARG PLATFORM="amd64"
ARG PHP_VERSION="84"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/php-alpine:${TAG_PREFIX}${PHP_VERSION}-${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-fpm \
"

ARG UNNEEDED_PATHS="\
  /etc/init.d/php-fpm* \
  /etc/logrotate.d/php-fpm \
  /etc/php/php-fpm.d/* \
"

RUN apk add --no-cache $REQUIRED_PKGS \
 && ln -s /usr/bin/php-fpm${PHP_VERSION} /usr/bin/php-fpm \
 && ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
 && rm -rf $UNNEEDED_PATHS

ADD fsroot /

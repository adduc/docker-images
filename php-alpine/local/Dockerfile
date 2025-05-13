##
# PHP image for "local" development
#
# Focused on SQLite-based development without a lot of extensions.
##

ARG NAMESPACE="local"
ARG OS_VERSION="3.21"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-cli \
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-fpm \
  php${PHP_VERSION}-opcache \
  php${PHP_VERSION}-pdo \
  php${PHP_VERSION}-pdo_sqlite \
"

ARG UNNEEDED_PATHS="\
  /etc/init.d/php-fpm* \
  /etc/logrotate.d/php-fpm \
  /etc/php/php-fpm.d/* \
"

RUN apk add --no-cache $REQUIRED_PKGS \
 && mv /etc/php${PHP_VERSION} /etc/php \
 && ln -fs /usr/bin/php${PHP_VERSION} /usr/bin/php \
 && ln -s /etc/php /etc/php${PHP_VERSION} \
 && ln -s /usr/bin/php-fpm${PHP_VERSION} /usr/bin/php-fpm \
 && ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
 && rm -rf $UNNEEDED_PATHS

ADD fsroot /

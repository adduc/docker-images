##
# PHP base image with FPM
#
# Provides PHP-FPM with scripts to translate environment variables into
# PHP-FPM pools and settings.
##

ARG NAMESPACE="local"
ARG OS_VERSION="3.21"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-cli \
  php${PHP_VERSION}-fpm \
  php${PHP_VERSION}-opcache \
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

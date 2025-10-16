##
# PHP image for "debug" development
#
# Focused on providing the whole kit-and-kaboodle of PHP extensions
# for debugging and development.
#
# This image is not intended for production use.
##

ARG NAMESPACE="local"
ARG OS_VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
ARG PHP_VERSION="84"
FROM ${NAMESPACE}/php-alpine:${TAG_PREFIX}${PHP_VERSION}-fpm-${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-bcmath \
  php${PHP_VERSION}-ctype \
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-dom \
  php${PHP_VERSION}-ffi \
  php${PHP_VERSION}-fileinfo \
  php${PHP_VERSION}-iconv \
  php${PHP_VERSION}-mbstring \
  php${PHP_VERSION}-openssl \
  php${PHP_VERSION}-pcntl \
  php${PHP_VERSION}-pdo \
  php${PHP_VERSION}-pdo_pgsql \
  php${PHP_VERSION}-pdo_sqlite \
  php${PHP_VERSION}-pecl-excimer \
  php${PHP_VERSION}-pecl-grpc \
  php${PHP_VERSION}-pecl-pcov \
  php${PHP_VERSION}-pecl-protobuf \
  php${PHP_VERSION}-pecl-redis \
  php${PHP_VERSION}-pecl-xdebug \
  php${PHP_VERSION}-phar \
  php${PHP_VERSION}-phpdbg \
  php${PHP_VERSION}-posix \
  php${PHP_VERSION}-redis \
  php${PHP_VERSION}-session \
  php${PHP_VERSION}-tokenizer \
  php${PHP_VERSION}-xml \
  php${PHP_VERSION}-xmlreader \
  php${PHP_VERSION}-xmlwriter \
  php${PHP_VERSION}-zip \
"

RUN apk add --no-cache $REQUIRED_PKGS

RUN wget \
  https://getcomposer.org/download/latest-stable/composer.phar \
  -O /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer



##
# PHP image for "work" development
#
# Focused on enough extensions for most work environments. Could be
# pared down to just the ones needed for your project.
##

ARG NAMESPACE="local"
ARG OS_VERSION="3.21"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
ARG PHP_VERSION="84"
FROM ${NAMESPACE}/php-alpine:${TAG_PREFIX}${PHP_VERSION}-fpm-${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-ctype \
  php${PHP_VERSION}-dom \
  php${PHP_VERSION}-fileinfo \
  php${PHP_VERSION}-iconv \
  php${PHP_VERSION}-mbstring \
  php${PHP_VERSION}-openssl \
  php${PHP_VERSION}-pecl-excimer \
  php${PHP_VERSION}-pcntl \
  php${PHP_VERSION}-pdo \
  php${PHP_VERSION}-pdo_sqlite \
  php${PHP_VERSION}-pdo_pgsql \
  php${PHP_VERSION}-phar \
  php${PHP_VERSION}-posix \
  php${PHP_VERSION}-redis \
  php${PHP_VERSION}-session \
  php${PHP_VERSION}-tokenizer \
  php${PHP_VERSION}-xml \
  php${PHP_VERSION}-xmlreader \
  php${PHP_VERSION}-xmlwriter \
"

RUN apk add --no-cache $REQUIRED_PKGS

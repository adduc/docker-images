##
# PHP image for "local" development
#
# Focused on SQLite-based development without a lot of extensions.
##

ARG NAMESPACE="local"
ARG OS_VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
ARG PHP_VERSION="84"
FROM ${NAMESPACE}/php-alpine:${TAG_PREFIX}${PHP_VERSION}-fpm-${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-pdo \
  php${PHP_VERSION}-pdo_sqlite \
  php${PHP_VERSION}-pecl-apcu \
  php${PHP_VERSION}-mbstring \
"

RUN apk add --no-cache $REQUIRED_PKGS

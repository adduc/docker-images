ARG NAMESPACE="local"
ARG OS_VERSION="3.21"
ARG PLATFORM="amd64"
FROM ${NAMESPACE}/base-alpine:${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION}-cli \
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-opcache \
  php${PHP_VERSION}-pdo \
  php${PHP_VERSION}-xml \
"

RUN apk add --no-cache $REQUIRED_PKGS \
 && mv /etc/php${PHP_VERSION} /etc/php \
 && ln -fs /usr/bin/php${PHP_VERSION} /usr/bin/php \
 && ln -s /etc/php /etc/php${PHP_VERSION}

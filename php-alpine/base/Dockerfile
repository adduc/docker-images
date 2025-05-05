ARG NAMESPACE="local"
ARG OS_VERSION="3.21"
ARG PLATFORM="amd64"
FROM ${NAMESPACE}/base-alpine:${OS_VERSION}-${PLATFORM}

ARG PHP_VERSION="84"

ARG REQUIRED_PKGS="\
  php${PHP_VERSION} \
"

RUN apk add --no-cache $REQUIRED_PKGS

# ADD fsroot /

# VOLUME /var/cache /var/log

# ENTRYPOINT ["/entrypoint.sh"]

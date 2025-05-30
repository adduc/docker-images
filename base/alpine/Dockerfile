# ignored in this Dockerfile
ARG NAMESPACE="local"
ARG VERSION="3.21"
# ignored in this Dockerfile
ARG PLATFORM="amd64"
FROM alpine:${VERSION}

ARG REQUIRED_PKGS="\
  dcron \
  logrotate \
  runit \
  sudo \
"

RUN apk add --no-cache $REQUIRED_PKGS

ADD fsroot /

VOLUME /var/cache /var/log

ENTRYPOINT ["/entrypoint.sh"]

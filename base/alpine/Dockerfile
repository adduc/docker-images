# ignored in this Dockerfile
ARG NAMESPACE="local"
ARG VERSION="3.22"
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

# Allow installing packages from Alpine Edge repositories using @edge
# tag (e.g. opentofu@edge)
RUN { \
  echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main"; \
  echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community"; \
  echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing"; \
  } >> /etc/apk/repositories

ADD fsroot /

VOLUME /var/cache /var/log

ENTRYPOINT ["/entrypoint.sh"]

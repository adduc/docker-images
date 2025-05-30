# ignored in this Dockerfile
ARG NAMESPACE="local"
ARG VERSION="24.04"
# ignored in this Dockerfile
ARG PLATFORM="amd64"
FROM ubuntu:${VERSION}

ARG REQUIRED_PKGS="\
  cron \
  logrotate \
  runit \
  sudo \
"

RUN apt-get update \
 && apt-get install -y --no-install-recommends $REQUIRED_PKGS \
 && apt-get purge -y --auto-remove \
 && rm -rf /var/lib/apt/lists/*

ADD fsroot /

VOLUME /var/cache /var/log

ENTRYPOINT ["/entrypoint.sh"]

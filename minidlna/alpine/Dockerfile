ARG NAMESPACE="local"
ARG VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

ARG REQUIRED_PKGS="\
  minidlna \
"

RUN apk add --no-cache $REQUIRED_PKGS \
 && sed -i 's/^#\(db_dir\)/\1/' /etc/minidlna.conf

ENV SERVICE_MINIDLNA="rm -f /run/minidlna/minidlna.pid; minidlnad -d -r"

VOLUME /var/cache/minidlna

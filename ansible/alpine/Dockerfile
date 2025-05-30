ARG NAMESPACE="local"
ARG VERSION="3.21"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

ARG REQUIRED_PKGS="\
  ansible-core \
  ansible-lint \
  openssh-client \
"

RUN apk add --no-cache $REQUIRED_PKGS

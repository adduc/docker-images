ARG NAMESPACE="local"
ARG VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

ARG REQUIRED_PKGS="\
  alpine-sdk \
  doas \
"

RUN apk add --no-cache $REQUIRED_PKGS

# create user, add to abuild group, enable for doas
RUN adduser -D user \
 && addgroup user abuild \
 && echo "permit nopass user as root" >> /etc/doas.conf

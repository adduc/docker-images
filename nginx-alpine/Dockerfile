ARG NAMESPACE="local"
ARG VERSION="3.21"
ARG PLATFORM="amd64"
FROM ${NAMESPACE}/base-alpine:${VERSION}-${PLATFORM}

ARG REQUIRED_PKGS="\
  nginx \
"

ARG UNNEEDED_PATHS="\
  /etc/nginx/http.d/*.conf \
"

RUN apk add --no-cache $REQUIRED_PKGS \
 && rm -rf $UNNEEDED_PATHS

ADD fsroot /

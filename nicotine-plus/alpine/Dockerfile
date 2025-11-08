ARG NAMESPACE="local"
ARG VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

# Use two separate apk commands to minimize the number of packages
# installed from the edge/testing repository.
RUN apk add --no-cache ttf-opensans gtk4.0 py3-gobject3 python3 python3-gdbm \
 && apk add --no-cache nicotine-plus \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN adduser -D -u 1000 -g 1000 nicotine

ENV DIR_CONFIG=/home/nicotine/.config/nicotine CONFIG_DIR_OWNER=nicotine \
    DIR_DOWNLOADS=/home/nicotine/.config/nicotine/downloads DOWNLOADS_DIR_OWNER=nicotine \
    DIR_INCOMPLETE=/home/nicotine/.config/nicotine/incomplete INCOMPLETE_DIR_OWNER=nicotine \
    SERVICE_GTK4_BROADWAYD="su - nicotine -c 'gtk4-broadwayd :5 -a 0.0.0.0 -p 8080'" \
    SERVICE_NICOTINE_PLUS="su - nicotine -c 'env GDK_BACKEND=broadway BROADWAY_DISPLAY=:5 nicotine'"

ARG NAMESPACE="local"
ARG VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

ARG REQUIRED_PKGS="\
  ansible-core \
  ansible-lint \
  openssh-client \
"

RUN apk add --no-cache $REQUIRED_PKGS

# Set default environment variables (processed by entry point scripts
# in the base image to create a user)
ENV USER_ANSIBLE=ansible ANSIBLE_USER_ID=1000

ADD fsroot /

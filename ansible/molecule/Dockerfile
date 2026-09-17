ARG NAMESPACE="local"
ARG VERSION="3.23"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/ansible-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

# ansible-core and ansible-lint are already installed by the ansible-alpine
# base image for every version (via apk normally, or via pip from git main
# on edge — see ansible/base/Dockerfile), so they're not repeated here.
ARG REQUIRED_PKGS="\
  openssh-client \
  sshpass \
  podman \
"

RUN apk add --no-cache $REQUIRED_PKGS

# Add molecule for testing Ansible roles
RUN apk add --no-cache py-pip \
 && pip install --break-system-packages --root-user-action ignore molecule molecule-podman \
 && apk del --no-cache py-pip



# Set default environment variables (processed by entry point scripts
# in the base image to create a user)
ENV USER_ANSIBLE=ansible ANSIBLE_USER_ID=1000

ADD fsroot /

ARG NAMESPACE="local"
ARG VERSION="3.23"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/ansible-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

# ARGs declared before FROM don't survive into the build stage, so VERSION
# needs to be redeclared here to be usable below.
ARG VERSION

ARG REQUIRED_PKGS="\
  openssh-client \
  sshpass \
  podman \
"

RUN apk add --no-cache $REQUIRED_PKGS

# On "edge" the base ansible-alpine image already installs ansible from git
# main via pip (see ansible/base/Dockerfile); installing ansible-core via apk
# here on top of that would pull in Alpine's edge-repo package and conflict
# with it. Everyone else gets the normal apk-packaged ansible-core.
RUN if [ "$VERSION" != "edge" ]; then \
      apk add --no-cache ansible-core ansible-lint; \
    fi

# Add molecule for testing Ansible roles
RUN apk add --no-cache py-pip \
 && pip install --break-system-packages --root-user-action ignore molecule molecule-podman \
 && apk del --no-cache py-pip



# Set default environment variables (processed by entry point scripts
# in the base image to create a user)
ENV USER_ANSIBLE=ansible ANSIBLE_USER_ID=1000

ADD fsroot /

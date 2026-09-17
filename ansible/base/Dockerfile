ARG NAMESPACE="local"
ARG VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

# ARGs declared before FROM don't survive into the build stage, so VERSION
# needs to be redeclared here to be usable in the RUN below.
ARG VERSION

ARG REQUIRED_PKGS="\
  openssh-client \
  sshpass \
"

RUN apk add --no-cache $REQUIRED_PKGS

# On "edge" we want the true bleeding-edge ansible from git main rather than
# whatever Alpine's edge repo happens to have packaged, since the whole point
# of using edge here is to pick up Python compatibility fixes ahead of both
# Alpine and PyPI releases. This tracks main unpinned by design; to pin to a
# specific commit instead, append "@<commit-sha>" to the git+https URL below.
# Everyone else gets the normal apk-packaged ansible-core.
RUN if [ "$VERSION" = "edge" ]; then \
      apk add --no-cache python3 && \
      apk add --no-cache --virtual .ansible-build-deps \
        gcc musl-dev python3-dev libffi-dev openssl-dev cargo rust py3-pip git && \
      pip install --break-system-packages --root-user-action ignore \
        "git+https://github.com/ansible/ansible.git" ansible-lint && \
      apk del --no-cache .ansible-build-deps; \
    else \
      apk add --no-cache ansible-core ansible-lint; \
    fi

# Set default environment variables (processed by entry point scripts
# in the base image to create a user)
ENV USER_ANSIBLE=ansible ANSIBLE_USER_ID=1000

ADD fsroot /

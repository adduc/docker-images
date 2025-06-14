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

# Set default environment variables defining the user to create
# for running ansible playbooks
ENV UID=1000 GID=1000 USER=ansible

# Create an entrypoint script to prepare the environment
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "sleep", "infinity" ]

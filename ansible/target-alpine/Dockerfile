ARG NAMESPACE="local"
ARG VERSION="3.22"
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
FROM ${NAMESPACE}/base-alpine:${TAG_PREFIX}${VERSION}-${PLATFORM}

ARG REQUIRED_PKGS="\
  openssh-server \
  openrc \
  python3 \
"

RUN apk add --no-cache $REQUIRED_PKGS

# Prepare OpenRC
RUN sed -i 's/^tty/#tty/' /etc/inittab \
 && rm /etc/init.d/hwdrivers /etc/init.d/machine-id

# Enable SSH
RUN rc-update add sshd

# Set default environment variables defining the user to create
# for running ansible playbooks
ENV UID=1000 GID=1000 USER=ansible

STOPSIGNAL SIGTERM

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/sbin/init" ]

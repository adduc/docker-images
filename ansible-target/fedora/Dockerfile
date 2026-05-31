ARG VERSION="44"
FROM fedora:${VERSION}

# Update installed packages
RUN \
  dnf update -y \
    --setopt=install_weak_deps=False \
    --nodocs \
  && dnf clean all \
  && rm -rf /var/cache/dnf /var/log/dnf*

ARG REQUIRED_PKGS="\
  openssh-server \
  python3 \
  python3-libdnf5 \
  sudo \
  systemd \
"

# Install required packages
RUN \
  dnf install -y $REQUIRED_PKGS \
    --setopt=install_weak_deps=False \
    --nodocs \
  && dnf clean all \
  && rm -rf /var/cache/dnf /var/log/dnf*

# Enable SSH service and set a minimal default target
RUN systemctl enable sshd.service \
 && systemctl set-default multi-user.target \
 && systemctl mask console-getty.service \
 && systemctl mask systemd-logind.service \
 && systemctl mask systemd-logind-varlink.socket \
 && systemctl mask dnf-makecache.timer \
 && systemctl mask systemd-update-utmp.service \
 && systemctl mask systemd-ask-password-console.path \
 && systemctl mask systemd-ask-password-wall.path \
 && systemctl mask systemd-ask-password.socket \
 && systemctl mask systemd-factory-reset.socket \
 && systemctl mask systemd-mute-console.socket \
 && systemctl mask systemd-creds.socket \
 && systemctl mask systemd-hostnamed.socket

# Systemd does not trap the default stop signal that docker
# uses, SIGTERM, so we need to set the stop signal to the signal systemd
# expects to stop services gracefully.
# @see https://www.man7.org/linux/man-pages/man1/systemd.1.html#SIGNALS
STOPSIGNAL SIGRTMIN+3
CMD [ "/lib/systemd/systemd" ]
VOLUME [ "/tmp", "/run/lock" ]

# Set default environment variables defining the user to create
# for running ansible playbooks
ENV UID=1000 GID=1000 USER=ansible

# Create an entrypoint script to prepare the environment before starting
# systemd
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

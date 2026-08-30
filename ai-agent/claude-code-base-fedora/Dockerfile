ARG VERSION="44"

# Install the Claude Code CLI as an unprivileged user, as the installer
# refuses to run as root.
FROM fedora:${VERSION} AS claude

RUN groupadd -g 1000 user \
 && useradd -u 1000 -g 1000 -m user

USER user
ENV PATH=/home/user/.local/bin:/home/user/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN curl -fsSL https://claude.ai/install.sh | bash

FROM fedora:${VERSION} AS runtime

ARG REQUIRED_PKGS="\
  jq \
  ripgrep \
  util-linux \
"

# Install agent tools
RUN dnf install -y $REQUIRED_PKGS \
    --setopt=install_weak_deps=False \
    --nodocs \
 && dnf clean all \
 && rm -rf /var/cache/dnf /var/log/dnf*

WORKDIR /srv

COPY --from=claude /home/user/.local/bin/claude /home/user/.local/bin/claude

# Set default environment variables defining the user to create for
# running claude. These are overridden at `docker run` time to match the
# host user so that bind-mounted files remain accessible.
ENV UID=1000 GID=1000 USER=user
ENV HOME=/home/user
ENV PATH=/home/user/.local/bin:/home/user/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create an entrypoint script to prepare the user before running claude
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "claude" ]

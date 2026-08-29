#!/bin/bash

# Instruct bash to exit when a command returns a non-zero exit code,
# when an undefined variable is used, and to fail if piped commands
# return a non-zero exit code.
set -o nounset -o errexit -o pipefail

create_group() {
  echo "Checking if group ${USER} exists..."

  if getent group "${USER}" > /dev/null; then
    echo "Group ${USER} already exists. Skipping group creation."
    return 0
  fi

  echo "Creating group ${USER} with GID ${GID}..."

  groupadd \
    --gid "${GID}" \
    "${USER}"
}

create_user() {
  echo "Checking if user ${USER} exists..."

  if getent passwd "${USER}" > /dev/null; then
    echo "User ${USER} already exists. Skipping user creation."
    return 0
  fi

  echo "Creating user ${USER} with UID ${UID} and GID ${GID}..."

  useradd \
    --create-home \
    --gid "${GID}" \
    --shell /bin/bash \
    --uid "${UID}" \
    "${USER}"
}

fix_ownership() {
  echo "Ensuring ${USER} owns its home directory..."
  chown -R "${USER}:${USER}" /home/"${USER}"
}

exec_cmd() {
  echo "Executing command as ${USER}: $*"
  exec runuser -u "${USER}" -- "$@"
}

main() {
  create_group
  create_user
  fix_ownership
  exec_cmd "$@"
}

main "$@"

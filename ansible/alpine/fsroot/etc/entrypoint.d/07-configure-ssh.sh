#!/bin/sh

# Instruct ash to exit when a command returns a non-zero exit code,
# when an undefined variable is used, and to fail if piped commands
# return a non-zero exit code.
set -o nounset -o errexit -o pipefail

prepare_user_ssh() {
  [ -d /mnt/user-ssh ] || return 0
  echo "Preparing SSH configuration for user ${USER_ANSIBLE}..."
  mkdir -p /home/"${USER_ANSIBLE}"/.ssh

  echo "Copying SSH keys from /mnt/user-ssh to /home/${USER_ANSIBLE}/.ssh..."
  cp -r /mnt/user-ssh/* /home/"${USER_ANSIBLE}"/.ssh/

  echo "Trusting localhost SSH key..."

}

prepare_system_ssh() {
  [ -d /mnt/system-ssh ] || return 0

  echo "Trusting system SSH keys..."

  truncate -s 0 /home/"${USER_ANSIBLE}"/.ssh/known_hosts

  for file in /mnt/system-ssh/ssh_host_*.pub; do
    # use wildcard to trust fingerprint for all hostnames
    (echo -n "* "; cat "$file") >> /home/"${USER_ANSIBLE}"/.ssh/known_hosts
  done
}

set_ssh_ownership() {
  if [ -d /home/"${USER_ANSIBLE}"/.ssh ]; then
    echo "Setting ownership of SSH directories and files..."
    chown -R "${USER_ANSIBLE}:${USER_ANSIBLE}" /home/"${USER_ANSIBLE}"/.ssh
    find /home/"${USER_ANSIBLE}"/.ssh -type d -exec chmod 700 {} +
    find /home/"${USER_ANSIBLE}"/.ssh -type f -exec chmod 600 {} +
  fi
}

exec_cmd() {
  echo "Executing command: $*"
  exec "$@"
}

main() {
  prepare_user_ssh
  prepare_system_ssh
  set_ssh_ownership
  exec_cmd "$@"
}

main "$@"

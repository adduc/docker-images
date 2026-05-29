#!/bin/sh

# Instruct ash to exit when a command returns a non-zero exit code,
# when an undefined variable is used, and to fail if piped commands
# return a non-zero exit code.
set -o nounset -o errexit -o pipefail

main() {
	grep -q '^ansible:' /etc/subuid 2>/dev/null || echo 'ansible:100000:65536' >> /etc/subuid
	grep -q '^ansible:' /etc/subgid 2>/dev/null || echo 'ansible:100000:65536' >> /etc/subgid
	su -c "podman system migrate"
}

main "$@"

#!/bin/sh

# Configure the shell to exit on errors, treat unset variables as errors,
# and error on any piped commands that fail
set -o nounset -o errexit -o pipefail

# Echo each command before executing it if DEBUG is set
[ -z "${DEBUG:-}" ] || set -o xtrace

##
# Utility function to get the value of an environment variable
#
# Usage: get_var VAR_NAME [default_value]
##
get_var() { eval "printf '%s' \"\${$1:-${2:-}}\""; }

##
# Sets common variables used in entrypoint scripts
##
preflight() {
  KV_REGEX="\([^=]\+\)=\(.*\)"
}

##
# Runs scripts from /etc/entrypoint.d/
#
# These scripts perform any necessary setup tasks that need to be run
# as part of the container startup process, including processing
# environment variables, starting services, and running one-off
# commands.
#
# This is architected to allow for additional entrypoints to be added
# by dependent images.
##
run_entrypoints() {
  for entrypoint in /etc/entrypoint.d/*; do
    echo "Running entrypoint script: $entrypoint"
    source $entrypoint
  done

  process_oneoff_cmd_env_vars
}

##
# Tells the shell how to handle signals
##
set_trap_handler() {
  trap 'trap_handler' INT TERM HUP QUIT
}

##
# Handles signals and exits gracefully
##
trap_handler() {
  CODE=$(expr $? - 128)
  echo "Received signal ${CODE}, shutting down gracefully..."

  # Stop all services
  pkill -$CODE -f runsvdir || true

  exit $CODE
}

##
# Runs the passed command or waits if no command is provided
##
run_cmd() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided, sleeping indefinitely..."
    sleep infinity &
    wait
  else
    echo "Arguments provided, running: $*"
    "$@"
  fi
}

##
# Main entrypoint function
##
main() {
  echo -e "---\nStarting entrypoint script\n---"
  preflight
  run_entrypoints
  set_trap_handler
  run_cmd "$@"
}

main "$@"

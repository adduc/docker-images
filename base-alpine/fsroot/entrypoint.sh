#!/bin/sh

# Configure the shell to exit on errors, treat unset variables as errors,
# and error on any piped commands that fail
set -o nounset -o errexit -o pipefail

# Echo each command before executing it if DEBUG is set
[ -z "${DEBUG:-}" ] || set -o xtrace

##
# Utility function to get the value of an environment variable
# Usage: get_var VAR_NAME [default_value]
##
get_var() { eval "echo -e \${$1:-${2:-}}"; }

##
# Sets common variables used in the script
##
preflight() {
  KV_REGEX="\([^=]\+\)=\(.*\)"
}

##
# Translate environment variables into commands to run at boot
#
# This is useful to prepare environment variables to be processed by
# subsequent features, such as environment files, startup commands, or
# services.
#
# BOOT_CMD_APP1="echo 'Hello, World!'"
#
# With the above environment variable, a command is run at boot that
# prints "Hello, World!" to the console.
##
process_boot_env_vars() {
    local BOOT_CMDS BOOT_CMD NAME

    BOOT_CMDS=$(env | grep '^BOOT_CMD_' | sed "s/^BOOT_CMD_${KV_REGEX}$/\1 \2/" || true)
    [ -z "$BOOT_CMDS" ] && return

    IFS=$'\n'
    for BOOT_CMD in $BOOT_CMDS; do
        unset IFS
        set $BOOT_CMD
        NAME=$1
        shift

        echo "Running boot command $NAME: $@"
        if ! eval "$@"; then
            echo "Command $NAME failed"
            exit 1
        fi
    done
}

##
# Translate environment variables into files
#
# This is useful in situations where the orchestration tool does not
# support creating files directly, but allows setting environment
# variables (e.g. Docker)
#
# FILE_APP1=/tmp/example
# APP1_FILE_CONTENT="asdf\nasdf"
# APP1_FILE_OWNER=root
# APP1_FILE_GROUP=root
# APP1_FILE_CHMOD=644
#
# With the above environment variables, a file is created at
# /tmp/example owned by root:root, with permissions 644, and with the
# following content:
#
# asdf
# asdf
##
process_file_env_vars() {
  local FILES FILE NAME CONTENT OWNER GROUP CHMOD

  FILES=$(env | grep '^FILE_' | sed "s/^FILE_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$FILES" ] && return

  IFS=$'\n'
  for FILE in $FILES; do
    unset IFS
    set $FILE
    NAME=$1
    shift

    mkdir -p $(dirname "$@")

    touch "$@"

    CONTENT=$(get_var "${NAME}_FILE_CONTENT")
    OWNER=$(get_var "${NAME}_FILE_OWNER")
    GROUP=$(get_var "${NAME}_FILE_GROUP")
    CHMOD=$(get_var "${NAME}_FILE_CHMOD")

    [ -z "$CONTENT" ] || echo "$CONTENT" > "$@"
    [ -z "$OWNER" ] || chown "$OWNER" "$@"
    [ -z "$GROUP" ] || chgrp "$GROUP" "$@"
    [ -z "$CHMOD" ] || chmod "$CHMOD" "$@"
  done
}

##
# Translate environment variables into ".env" files
#
# This can be useful in situations where multiple services need to run
# in the same container, and each service needs its own environment
# variables. If the service supports reading from a ".env" file, this
# can be used to create separate environment files for each service.
#
# ENV_FILE_APP1=/tmp/.env
# APP1_ENV_FILE_OWNER=root
# APP1_ENV_FILE_GROUP=root
# APP1_ENV_FILE_CHMOD=644
# APP1_ENV_FILE_KEY_DEBUG="1"
# APP1_ENV_FILE_KEY_A="2"
#
# With the above environment variables, a file is created at
# /tmp/.env owned by root:root, with permissions 644, and with the
# following content:
#
# DEBUG="1"
# A="2"
##
process_env_file_env_vars() {
  local ENV_FILES ENV_FILE NAME OWNER GROUP CHMOD

  ENV_FILES=$(env | grep "^ENV_FILE_" | sed "s/^ENV_FILE_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$ENV_FILES" ] && return

  IFS=$'\n'
  for ENV_FILE in $ENV_FILES; do
    unset IFS
    set $ENV_FILE
    NAME=$1
    shift

    mkdir -p $(dirname "$@")

    touch "$@"

    OWNER=$(get_var "${NAME}_ENV_FILE_OWNER")
    GROUP=$(get_var "${NAME}_ENV_FILE_GROUP")
    CHMOD=$(get_var "${NAME}_ENV_FILE_CHMOD")

    [ -z "$OWNER" ] || chown "$OWNER" "$@"
    [ -z "$GROUP" ] || chgrp "$GROUP" "$@"
    [ -z "$CHMOD" ] || chmod "$CHMOD" "$@"

    env | grep "^${NAME}_ENV_FILE_KEY_" \
      | sed "s/^${NAME}_ENV_FILE_KEY_\([^=]\+\)=\(.*\)$/\1=\2/" > "$@" \
      || true
  done
}

##
# Translate environment variables into cron jobs
#
# This is useful for running scheduled tasks that need to be run at
# specific intervals, such as database backups, cache refreshes, or
# other periodic tasks.
#
# CRON_JOB_APP1="0 0 * * * /usr/bin/backup.sh"
#
# With the above environment variable, a cron job is created that runs
# the command "/usr/bin/backup.sh" every day at midnight. The output of
# the command is logged to /var/log/cron/app1.log.
##
process_cron_env_vars() {
  local CRON_JOBS JOB NAME USER
  CRON_JOBS=$(env | grep "^CRON_JOB_" | sed "s/^CRON_JOB_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$CRON_JOBS" ] && return

  # don't expand wildcards
  set -o noglob

  IFS=$'\n'
  for JOB in $CRON_JOBS; do
    unset IFS
    set $JOB
    NAME=$1
    shift

    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
    echo "$@ >> /var/log/cron/${NAME}.log 2>&1" > "/etc/cron.d/${NAME}"
  done

  set +o noglob
}

##
# Translate environment variables into commands to run commands after
# the environment has been set up, but before any services are started.
#
# This is useful for running commands that rely on the files created
# by the previous steps, such as database migrations that need .env
# files to be present, or other setup tasks that need to be run before
# the services are started.
#
# STARTUP_CMD_APP1="echo 'Hello, World!'"
#
# With the above environment variable, a command is run after the
# environment has been set up that prints "Hello, World!" to the
# console.
##
process_startup_cmd_env_vars() {
  local STARTUP_CMDS CMD NAME

  STARTUP_CMDS=$(env | grep '^STARTUP_CMD_' | sed "s/^STARTUP_CMD_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$STARTUP_CMDS" ] && return

  IFS=$'\n'
  for CMD in $STARTUP_CMDS; do
    unset IFS
    set $CMD
    NAME=$1
    shift

    echo "Running startup command $NAME: $@"
    if ! eval "$@"; then
      echo "Startup command $NAME failed, exiting..."
      exit 1
    fi
  done
}

##
# Translate environment variables into service definitions
#
# This is useful for running long-lived commands that are expected to
# run in the background, such as web servers, databases, or other
# services.
#
# SERVICE_APP1="nginx -g 'daemon off;'"
#
# With the above environment variable, a service is started that runs
# the command "nginx -g 'daemon off;'" in the background. When the
# command exits for any reason, the service will be restarted
# automatically.
#
# If the command should be run multiple times, a _COUNT suffix can be
# used to specify the number of times the service should be started.
# For example, if the environment variable is set to
# APP1_SERVICE_COUNT=3, the service will be started three times with the
# same command. The environment variables "SERVICE_COUNT_TOTAL" and
# "SERVICE_COUNT_INDEX" will be set to the total number of services
# started and the index of the current service (starting from 0) and can
# be used within the command to differentiate between the services.
#
# Note: services are managed through runit; the command is expected to
# run in the foreground.
##
process_service_env_vars() {
  local SERVICES SERVICE NAME COUNT N

  SERVICES=$(env | grep '^SERVICE_' | sed "s/^SERVICE_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$SERVICES" ] && return

  IFS=$'\n'
  for SERVICE in $SERVICES; do
    unset IFS
    set $SERVICE
    NAME=$1
    shift

    eval COUNT=\${${NAME}_SERVICE_COUNT:-1}
    NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

    echo "Defining service $NAME with command: $@ (count: $COUNT)"

    for N in $(seq $COUNT); do
      # Create the service directory
      mkdir -p "/etc/service/${NAME}_${N}"
      # Create the run script for the service
      echo "#!/bin/sh" > "/etc/service/${NAME}_${N}/run"
      echo "export SERVICE_COUNT_TOTAL=$COUNT" >> "/etc/service/${NAME}_${N}/run"
      echo "export SERVICE_COUNT_INDEX=$N" >> "/etc/service/${NAME}_${N}/run"
      echo "{ $@; } >> /var/log/svc/${NAME}_${N}.log 2>&1" >> "/etc/service/${NAME}_${N}/run"
      chmod +x "/etc/service/${NAME}_${N}/run"
    done
  done
}

##
# Starts the services defined in the /etc/service directory (using
# runit)
##
start_services() {
  echo "Starting services..."
  mkdir -p /var/log/svc
  runsvdir -P /etc/service &
}

##
# Translate environment variables into one-off commands to run
#
# These commands are run after the services have been started, and are
# not monitored for errors or restarts. They are useful for running
# commands that are expected to run once and then exit, such as
# truncating logs, refreshing caches, or other one-off tasks that may
# not need to block the container from starting up while they run.
#
# ONEOFF_CMD_APP1="echo 'Hello, World!'"
#
# With the above environment variable, a command is run after the
# services have been started that prints "Hello, World!" to the
# console.
##
process_oneoff_cmd_env_vars() {
  local ONEOFF_CMDS CMD NAME

  ONEOFF_CMDS=$(env | grep '^ONEOFF_CMD_' | sed "s/^ONEOFF_CMD_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$ONEOFF_CMDS" ] && return

  IFS=$'\n'
  for CMD in $ONEOFF_CMDS; do
    unset IFS
    set $CMD
    NAME=$1
    shift

    echo "Running one-off command $NAME: $@"
    eval "$@" &
  done
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
run() {
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
  process_boot_env_vars
  process_file_env_vars
  process_env_file_env_vars
  process_cron_env_vars
  process_startup_cmd_env_vars
  start_services
  process_service_env_vars
  process_oneoff_cmd_env_vars
  set_trap_handler
  run "$@"
}

main "$@"

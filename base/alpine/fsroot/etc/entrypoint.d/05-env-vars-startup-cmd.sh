#!/bin/sh

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
# With the above environment variable, a file is created at
# /etc/startup.d/app1.sh that contains the command "echo 'Hello,
# World!'". Responsibility for running this command is left to the
# 10-exec-startup-cmds.sh script, which is run later in the startup
# process.
##
process_startup_cmd_env_vars() {
  local STARTUP_CMDS CMD NAME

  STARTUP_CMDS=$(env | grep '^STARTUP_CMD_' | sed "s/^STARTUP_CMD_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$STARTUP_CMDS" ] && return

  mkdir -p /etc/startup.d

  IFS=$'\n'
  for CMD in $STARTUP_CMDS; do
    unset IFS
    set $CMD
    NAME=$1
    shift

    # Write to /etc/startup.d/ so that the command is run later in the
    # startup process
    echo "#!/bin/sh" > "/etc/startup.d/${NAME}.sh"
    echo "$@" >> "/etc/startup.d/${NAME}.sh"
  done
}

process_startup_cmd_env_vars

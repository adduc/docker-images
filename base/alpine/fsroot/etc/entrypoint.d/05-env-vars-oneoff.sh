#!/bin/sh

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
# With the above environment variable, a file is created at
# /etc/oneoff.d/app1.sh that contains the command "echo 'Hello,
# World!'". Responsibility for running this command is left to the
# 20-exec-oneoff-cmds.sh script, which is run later in the startup
# process.
##
process_oneoff_cmd_env_vars() {
  local ONEOFF_CMDS CMD NAME

  ONEOFF_CMDS=$(env | grep '^ONEOFF_CMD_' | sed "s/^ONEOFF_CMD_${KV_REGEX}$/\1/" || true)
  [ -z "$ONEOFF_CMDS" ] && return

  mkdir -p /etc/oneoff.d

  IFS=$'\n'
  for ONEOFF_CMD in $ONEOFF_CMDS; do
    CMD=$(get_var "ONEOFF_CMD_${ONEOFF_CMD}")

    # Write to /etc/oneoff.d/ so that the command is run later in the
    # startup process
    echo "#!/bin/sh" > "/etc/oneoff.d/${ONEOFF_CMD}.sh"
    echo "$CMD" >> "/etc/oneoff.d/${ONEOFF_CMD}.sh"
    chmod +x "/etc/oneoff.d/${ONEOFF_CMD}.sh"
  done
}

process_oneoff_cmd_env_vars

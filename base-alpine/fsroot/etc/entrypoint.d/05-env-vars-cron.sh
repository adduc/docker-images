#!/bin/sh

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

process_cron_env_vars

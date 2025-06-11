#!/bin/sh

##
# Translate environment variables into directories
#
# This is useful in situations where the orchestration tool does not
# support creating directories directly, but allows setting environment
# variables (e.g. Docker)
#
# DIR_APP1=/tmp/example
# APP1_DIR_OWNER=root
# APP1_DIR_GROUP=root
# APP1_DIR_CHMOD=644
#
# With the above environment variables, a directory is created at
# /tmp/example owned by root:root and with permissions 644
##
process_dir_env_vars() {
  local DIRS DIR NAME OWNER GROUP CHMOD

  DIRS=$(env | grep '^DIR_' | sed "s/^DIR_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$DIRS" ] && return

  IFS=$'\n'
  for DIR in $DIRS; do
    unset IFS
    set $DIR
    NAME=$1
    shift

    mkdir -p "$@"

    OWNER=$(get_var "${NAME}_DIR_OWNER")
    GROUP=$(get_var "${NAME}_DIR_GROUP")
    CHMOD=$(get_var "${NAME}_DIR_CHMOD")

    [ -z "$OWNER" ] || chown "$OWNER" "$@"
    [ -z "$GROUP" ] || chgrp "$GROUP" "$@"
    [ -z "$CHMOD" ] || chmod "$CHMOD" "$@"
  done
}

process_dir_env_vars

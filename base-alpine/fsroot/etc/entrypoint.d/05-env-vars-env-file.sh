#!/bin/sh

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

process_env_file_env_vars

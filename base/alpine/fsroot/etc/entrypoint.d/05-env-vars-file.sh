#!/bin/sh

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

process_file_env_vars

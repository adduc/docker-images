#!/bin/sh

##
# Translate environment variables into user creation commands.
#
# This script processes environment variables that define users and
# their user IDs, creating the users in the system. The environment
# variables should be named in the format:
#
# USER_<name>=<username>
# <name>_USER_ID=<user_id>
#
# If the user ID is not specified, a default user ID will be assigned
# by the system.
#
# For example:
#
# USER_GEORGE=george
# GEORGE_USER_ID=1000
#
# This will create a user named "george" with user ID 1000.
##
process_user_env_vars() {
  USERS=$(env | grep '^USER_' | sed "s/^USER_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$USERS" ] && return

  IFS=$'\n'
  for USER in $USERS; do
    unset IFS
    set $USER
    NAME=$1
    USER_NAME=$2
    ID=$(get_var "${NAME}_USER_ID")

    UID_OPTS=""
    if [ -n "$ID" ]; then
      UID_OPTS="--uid $ID"
    fi

    adduser -D $UID_OPTS "$USER_NAME" || {
      >&2 echo "Failed to create user '$USER_NAME' with ID '$ID'."
      exit 1
    }
  done
}

process_user_env_vars

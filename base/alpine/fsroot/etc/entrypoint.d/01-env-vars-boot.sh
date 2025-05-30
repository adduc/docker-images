#!/bin/sh

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

process_boot_env_vars

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

    BOOT_CMDS=$(env | grep '^BOOT_CMD_' | sed "s/^BOOT_CMD_${KV_REGEX}$/\1/" || true)
    [ -z "$BOOT_CMDS" ] && return

    IFS=$'\n'
    for BOOT_CMD in $BOOT_CMDS; do
        CMD=$(get_var "BOOT_CMD_${BOOT_CMD}")
        echo -e "--- CMD: $BOOT_CMD (SCRIPT) ---\n$CMD\n--- CMD: $BOOT_CMD (OUTPUT) ---"

        if ! eval "$CMD"; then
            echo "Command $BOOT_CMD failed"
            exit 1
        fi
        echo "--- CMD: $BOOT_CMD (END) ---"
    done
}

process_boot_env_vars

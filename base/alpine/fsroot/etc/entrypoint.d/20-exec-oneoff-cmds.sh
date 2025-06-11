#!/bin/sh

##
# Executes all oneoff commands defined in /etc/oneoff.d/*.sh
##
exec_oneoff_cmds() {
  if [ ! -d /etc/oneoff.d ]; then
    echo "No one-off commands to run"
    return
  fi

  if [ ! -f /etc/oneoff.d/*.sh ]; then
    echo "No one-off commands to run"
    return
  fi

  for CMD in /etc/oneoff.d/*.sh; do
    echo "Running one-off command $CMD"
    source "$CMD"
  done
}

exec_oneoff_cmds

#!/bin/sh

##
# Executes all startup commands defined in /etc/startup.d/*.sh
##
exec_startup_cmds() {

  if [ ! -d /etc/startup.d ]; then
    echo "No startup commands to run"
    return
  fi

  if [ ! -f /etc/startup.d/*.sh ]; then
    echo "No startup commands to run"
    return
  fi

  for CMD in /etc/startup.d/*.sh; do
    echo "Running startup command $CMD"
    source "$CMD"
  done
}

exec_startup_cmds

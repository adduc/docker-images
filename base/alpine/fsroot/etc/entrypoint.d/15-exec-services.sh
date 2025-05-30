#!/bin/sh

##
# Starts the services defined in the /etc/service directory (using
# runit)
##
exec_services() {
  echo "Starting services..."
  mkdir -p /var/log/svc
  runsvdir -P /etc/service &
}

exec_services

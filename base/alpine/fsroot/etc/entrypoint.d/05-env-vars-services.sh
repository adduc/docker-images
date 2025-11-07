#!/bin/sh

##
# Translate environment variables into service definitions
#
# This is useful for running long-lived commands that are expected to
# run in the background, such as web servers, databases, or other
# services.
#
# SERVICE_APP1="nginx -g 'daemon off;'"
#
# With the above environment variable, a service is started that runs
# the command "nginx -g 'daemon off;'" in the background. When the
# command exits for any reason, the service will be restarted
# automatically.
#
# If the command should be run multiple times, a _COUNT suffix can be
# used to specify the number of times the service should be started.
# For example, if the environment variable is set to
# APP1_SERVICE_COUNT=3, the service will be started three times with the
# same command. The environment variables "SERVICE_COUNT_TOTAL" and
# "SERVICE_COUNT_INDEX" will be set to the total number of services
# started and the index of the current service (starting from 0) and can
# be used within the command to differentiate between the services.
#
# Note: services are managed through runit; the command is expected to
# run in the foreground.
##
process_service_env_vars() {
  local SERVICES SERVICE NAME COUNT N

  SERVICES=$(env | grep '^SERVICE_' | sed "s/^SERVICE_${KV_REGEX}$/\1/" || true)
  [ -z "$SERVICES" ] && return

  IFS=$'\n'
  for SERVICE in $SERVICES; do
    NAME=$(echo "$SERVICE" | tr '[:upper:]' '[:lower:]')
    CMD=$(get_var "SERVICE_${SERVICE}")
    COUNT=$(get_var "SERVICE_${SERVICE}_COUNT" "1")

    echo "Defining service $NAME with command: $CMD (count: $COUNT)"

    for N in $(seq $COUNT); do
      # Create the service directory
      mkdir -p "/etc/service/${NAME}_${N}"
      # Create the run script for the service
      echo "#!/bin/sh" > "/etc/service/${NAME}_${N}/run"
      echo "export SERVICE_COUNT_TOTAL=$COUNT" >> "/etc/service/${NAME}_${N}/run"
      echo "export SERVICE_COUNT_INDEX=$N" >> "/etc/service/${NAME}_${N}/run"
      echo "{ $CMD; } >> /var/log/svc/${NAME}_${N}.log 2>&1" >> "/etc/service/${NAME}_${N}/run"
      chmod +x "/etc/service/${NAME}_${N}/run"
    done
  done
}

process_service_env_vars

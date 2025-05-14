#!/bin/sh

process_fpm_conf_env_vars() {
  cat /etc/php/templates/php-fpm.conf \
  > /etc/php/php-fpm.conf
}

##
# Translate FPM_POOL_* environment variables into nginx virtual hosts
# optimized for PHP applications.
#
# Syntax: FPM_POOL_<NAME>=<LISTEN_ADDRESS> <NUM_CHILDREN>
#
# Arguments:
#   NAME: Name to use for config and logs files
#   LISTEN_ADDRESS: Address to listen on
#   NUM_CHILDREN: Number of child processes
##
process_fpm_pool_env_vars() {
  POOLS=$(env | grep "^FPM_POOL_" | sed "s/^FPM_POOL_${KV_REGEX}$/\1 \2/" || true)
  [ -z "$POOLS" ] && return

  # don't expand wildcards
  set -o noglob

  IFS=$'\n'
  for POOL in $POOLS; do
    unset IFS
    set $POOL
    NAME=$1
    LISTEN_ADDRESS=$2
    NUM_CHILDREN=$3

    UID=$(get_var "${NAME}_FPM_POOL_UID")
    GID=$(get_var "${NAME}_FPM_POOL_GID")

    cat /etc/php/templates/pool.conf \
    | sed "\
      s|{{ NAME }}|$NAME|g;\
      s|{{ LISTEN_ADDRESS }}|$LISTEN_ADDRESS|g;\
      s|{{ NUM_CHILDREN }}|$NUM_CHILDREN|g; \
      s|{{ UID }}|${UID:nobody}|g;\
      s|{{ GID }}|${GID:nobody}|g" \
    > /etc/php/php-fpm.d/$NAME.conf
  done
}

main() {
  process_fpm_conf_env_vars
  process_fpm_pool_env_vars
}

main

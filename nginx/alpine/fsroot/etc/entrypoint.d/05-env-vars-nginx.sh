#!/bin/sh

##
# Translate VHOST_PHP_* environment variables into nginx virtual hosts
# configured for PHP applications.
#
# Syntax: VHOST_PHP_<NAME>=<SERVER_NAME> <ROOT_DIR> <PHP_ADDR>
#
# Arguments:
#   NAME: Name to use for config and logs files
#   SERVER_NAME: Server name to accept requests for
#   ROOT_DIR: Root directory to serve requests from
#   PHP_ADDR: PHP address to pass unresolved requests to
##
process_vhost_php_env_vars() {
  VHOSTS=$(get_vars "VHOST_PHP_")
  [ -z "$VHOSTS" ] && return

  # don't expand wildcards
  set -o noglob

  IFS=$'\n'
  for VHOST in $VHOSTS; do
    unset IFS
    set $VHOST
    NAME=$1
    SERVER_NAME=$2
    ROOT_DIR=$3
    PHP_ADDR=$4

    cat /etc/nginx/templates/vhost.php.conf \
    | sed "\
      s|{{ SERVER_NAME }}|$SERVER_NAME|g;\
      s|{{ ROOT_DIR }}|$ROOT_DIR|g;\
      s|{{ PHP_ADDR }}|$PHP_ADDR|g" \
    > /etc/nginx/http.d/$NAME.php.conf
  done
}

##
# Route all non-static requests index.php
# VHOST_INDEX_PHP_<NAME>=<SERVER_NAME> <ROOT_DIR> <PHP_ADDR>
##
process_vhost_index_php_env_vars() {
  VHOSTS=$(get_vars "VHOST_INDEX_PHP_")
  [ -z "$VHOSTS" ] && return

  # don't expand wildcards
  set -o noglob

  IFS=$'\n'
  for VHOST in $VHOSTS; do
    unset IFS
    set $VHOST
    NAME=$1
    SERVER_NAME=$2
    ROOT_DIR=$3
    PHP_ADDR=$4

    cat /etc/nginx/templates/vhost.index.php.conf \
    | sed "\
      s|{{ SERVER_NAME }}|$SERVER_NAME|g;\
      s|{{ ROOT_DIR }}|$ROOT_DIR|g;\
      s|{{ PHP_ADDR }}|$PHP_ADDR|g" \
    > /etc/nginx/http.d/$NAME.index.php.conf
  done
}

process_vhost_static_env_vars() {
  VHOSTS=$(get_vars "VHOST_STATIC_")
  [ -z "$VHOSTS" ] && return

  # don't expand wildcards
  set -o noglob

  IFS=$'\n'
  for VHOST in $VHOSTS; do
    unset IFS
    set $VHOST
    NAME=$1
    SERVER_NAME=$2
    ROOT_DIR=$3

    cat /etc/nginx/templates/vhost.static.conf \
    | sed "\
      s|{{ SERVER_NAME }}|$SERVER_NAME|g;\
      s|{{ ROOT_DIR }}|$ROOT_DIR|g" \
    > /etc/nginx/http.d/$NAME.static.conf
  done
  return 0
}

##
# Translate VHOST_PROXY_* environment variables into nginx virtual hosts
# configured for proxying requests to another server.
#
# Syntax: VHOST_PROXY_<NAME>=<SERVER_NAME> <ROOT_DIR> <PROXY_ADDR>
#
# Additional Environment Variables:
#   <NAME>_VHOST_PROXY_HOST: Host header to send to the proxied server (default: $host)
#   <NAME>_VHOST_PROXY_PROTO: Protocol to use for the proxied server (default: https)
##
process_vhost_proxy_env_vars() {
  VHOSTS=$(get_vars "VHOST_PROXY_")
  [ -z "$VHOSTS" ] && return

  # don't expand wildcards
  set -o noglob

  IFS=$'\n'
  for VHOST in $VHOSTS; do
    unset IFS
    set $VHOST
    NAME=$1
    SERVER_NAME=$2
    ROOT_DIR=$3
    PROXY_ADDR=$4

    PROXY_HOST=$(get_var "${NAME}_VHOST_PROXY_HOST" '\$host')
    PROXY_PROTO=$(get_var "${NAME}_VHOST_PROXY_PROTO" "https")

    cat /etc/nginx/templates/vhost.proxy.conf \
    | sed "\
      s|{{ SERVER_NAME }}|$SERVER_NAME|g;\
      s|{{ ROOT_DIR }}|$ROOT_DIR|g;\
      s|{{ PROXY_ADDR }}|$PROXY_ADDR|g;\
      s|{{ PROXY_HOST }}|$PROXY_HOST|g;\
      s|{{ PROXY_PROTO }}|$PROXY_PROTO|g" \
    > /etc/nginx/http.d/$NAME.proxy.conf
  done
}

process_nginx_conf_env_vars() {
  # find NGINX_* env vars
  # cat /etc/nginx/templates/nginx.conf to /etc/nginx/nginx.conf
  # replace WORKER_PROCESSES, WORKER_CONNECTIONS, and KEEP_ALIVE_TIMEOUT
  cat /etc/nginx/templates/nginx.conf > /etc/nginx/nginx.conf
  return 0
}

main() {
  process_vhost_php_env_vars
  process_vhost_index_php_env_vars
  process_vhost_static_env_vars
  process_vhost_proxy_env_vars
  process_nginx_conf_env_vars
}

main

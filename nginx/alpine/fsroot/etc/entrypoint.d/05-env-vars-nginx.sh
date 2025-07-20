#!/bin/sh

##
# Translate VHOST_PHP_* environment variables into nginx virtual hosts
# optimized for PHP applications.
#
# Syntax: VHOST_PHP_<NAME>=<SERVER_NAME> <ROOT_DIR> <PHP_ENDPOINT>
#
# Arguments:
#   NAME: Name to use for config and logs files
#   SERVER_NAME: Server name to accept requests for
#   ROOT_DIR: Root directory to serve requests from
#   PHP_ENDPOINT: PHP endpoint to pass unresolved requests to
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
    PHP_ENDPOINT=$4

    cat /etc/nginx/templates/vhost.php.conf \
    | sed "\
      s|{{ SERVER_NAME }}|$SERVER_NAME|g;\
      s|{{ ROOT_DIR }}|$ROOT_DIR|g;\
      s|{{ PHP_ENDPOINT }}|$PHP_ENDPOINT|g" \
    > /etc/nginx/http.d/$NAME.php.conf
  done
}

##
# Route all non-static requests index.php
# VHOST_INDEX_PHP_<NAME>=<SERVER_NAME> <ROOT_DIR> <PHP_ENDPOINT>
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
    PHP_ENDPOINT=$4

    cat /etc/nginx/templates/vhost.index.php.conf \
    | sed "\
      s|{{ SERVER_NAME }}|$SERVER_NAME|g;\
      s|{{ ROOT_DIR }}|$ROOT_DIR|g;\
      s|{{ PHP_ENDPOINT }}|$PHP_ENDPOINT|g" \
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

process_vhost_proxy_env_vars() {
  # find VHOST_PROXY_* env vars
  # cat /etc/nginx/templates/vhost.proxy.conf to /etc/nginx/http.d/$NAME.proxy.conf
  # replace SERVER_NAME, ROOT_DIR, and PROXY_PASS
  return 0
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
  process_vhost_static_env_vars
  process_vhost_proxy_env_vars
  process_nginx_conf_env_vars
}

main

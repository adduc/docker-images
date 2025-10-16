#!/bin/sh

process_php_ini_env_vars() {
  RAW_CONFIG=$(get_var PHP_INI_RAW_CONFIG)

  # escape newlines so they can be used in sed
  RAW_CONFIG=${RAW_CONFIG//$'\n'/'\n'}

  cat /etc/php/templates/php.ini \
  | sed "\
    s|{{ RAW_CONFIG }}|$RAW_CONFIG|g" \
  > /etc/php/php.ini
}

main() {
  process_php_ini_env_vars
}

main

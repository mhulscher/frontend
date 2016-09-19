#!/bin/sh

set -efo pipefail

[[ -x /opt/init ]] && /opt/init

if [[ ! -z $NGX_PROXY ]]; then
  echo "== Enabling proxy-mode"
  sed -i 's/^# PROXY-enabled #//' /etc/nginx/conf.d/www.conf
else
  sed -i '/^# PROXY-enabled #/d'  /etc/nginx/conf.d/www.conf
fi

if [[ -f /tls/tls.crt && -f /tls/tls.key ]]; then
  echo "== Enabling TLS, found /tls/tls.crt and /tls/tls.key"

  sed -i '/^# TLS-disabled #/d' /etc/nginx/conf.d/www.conf
  sed -i 's/^# TLS-enabled #//' /etc/nginx/conf.d/www.conf
else
  sed -i '/^# TLS-enabled #/d'   /etc/nginx/conf.d/www.conf
  sed -i 's/^# TLS-disabled #//' /etc/nginx/conf.d/www.conf
fi

cat /var/www/html/env.js | envsubst > /var/www/html/env.js.tmp
mv  /var/www/html/env.js.tmp /var/www/html/env.js

nginx -t
nginx -g "daemon off;" -c /etc/nginx/nginx.conf

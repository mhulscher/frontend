#!/bin/sh

# Safe mode
set -eufo pipefail

# Configuration of confd
export CONFD_LOG_LEVEL="${CONFD_LOG_LEVEL:-info}"

# Configuration of nginx
# NGX_PROXY is absent unless set by user
export NGX_DOCUMENT_ROOT="${NGX_DOCUMENT_ROOT:-/var/www/html}"
export NGX_INDEX="${NGX_INDEX:-index.html}"
export ENVIRONMENT_FILE="${ENVIRONMENT_FILE:-env.js}"

# Configuration of TLS in nginx
if [[ -f /tls/tls.crt && -f /tls/tls.key ]]; then
  echo "== Enabling TLS, found /tls/tls.crt and /tls/tls.key"
  export NGX_TLS=1
fi

cat ${NGX_DOCUMENT_ROOT}/${ENVIRONMENT_FILE} | envsubst > ${NGX_DOCUMENT_ROOT}/${ENVIRONMENT_FILE}.tmp
mv  ${NGX_DOCUMENT_ROOT}/${ENVIRONMENT_FILE}.tmp ${NGX_DOCUMENT_ROOT}/${ENVIRONMENT_FILE}

confd -onetime -backend env -log-level $CONFD_LOG_LEVEL

# Run optional init script
[[ -x /opt/init ]] && /opt/init

# Start nginx
nginx -g "daemon off;" -c /etc/nginx/nginx.conf

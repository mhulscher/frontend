#!/bin/bash

# Safe mode
set -eufo pipefail

# Symlink cache directories

CACHE_DIRS="npm node_gyp jspm ssh"

for DIR in $CACHE_DIRS; do
  if [[ -d "/$DIR" ]]; then
    ln -vs "/${DIR}" "/root/.${DIR}"
  fi
done

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

# Execute optional init script

[[ -x /opt/init ]] && /opt/init

/usr/sbin/nginx -g "daemon off;" -c /etc/nginx/nginx.conf &

mkdir -pv  /var/www/html/dist
chmod 0777 /var/www/html/dist

set +f
rm -rf /var/www/html/dist/*
set -f

set +e
npm --unsafe-perm $@

find /var/www/html/dist -exec chmod ugo=rwX {} \;

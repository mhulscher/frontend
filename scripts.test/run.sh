#!/bin/bash

set -eufo pipefail

###
# Symlink cache directories

CACHE_DIRS="npm node_gyp jspm ssh"

for DIR in $CACHE_DIRS; do
  if [[ -d "/$DIR" ]]; then
    ln -vs "/${DIR}" "/root/.${DIR}"
  fi
done

###
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

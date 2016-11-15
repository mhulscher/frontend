#!/bin/bash

set -xeufo pipefail

image=${1}

function start_container () {
  options=${1}
  container_id=`docker run ${options} -dP ${image}`
  port_http=`docker inspect ${container_id} | jq -rMc '.[].NetworkSettings.Ports."80/tcp"[]."HostPort"'`
  sleep 3
}

function remove_container {
  docker rm -f ${container_id}
}

function test_http {
  start_container ""
  output=`curl -XGET http://0.0.0.0:${port_http}`
  [ `echo $output | grep -c 'Default frontend welcome page.'` -eq 1 ] || exit
  remove_container
}

test_http

#!/bin/sh

set -x

export OPS_NAMESPACE=`grep search /etc/resolv.conf |awk '{sub(".svc","-ops.svc", $2); print $2 }'`
export HTTP_PROXY="http://proxy.$OPS_NAMESPACE:8080"
export HTTPS_PROXY=$HTTP_PROXY
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTP_PROXY
#export NO_PROXY

exec /usr/bin/openshift-docker-build "$@"

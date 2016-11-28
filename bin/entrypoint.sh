#!/bin/sh

set -x

cat /etc/resolv.conf
cat /etc/hostname
cat /etc/hosts
cat /run/secrets/kubernetes.io/serviceaccount/namespace

export HTTP_PROXY=http://proxy.ops.svc.cluster.local:8080
export HTTPS_PROXY=http://proxy.ops.svc.cluster.local:8080
export http_proxy=http://proxy.ops.svc.cluster.local:8080
export https_proxy=http://proxy.ops.svc.cluster.local:8080
#export NO_PROXY

exec /usr/bin/openshift-docker-build "$@"

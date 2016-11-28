FROM registry.access.redhat.com/openshift3/ose-docker-builder:latest

MAINTAINER Steven wolfram

COPY bin/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT /usr/local/bin/entrypoint.sh


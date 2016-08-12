FROM registry.access.redhat.com/openshift3/ose-docker-builder:latest
MAINTAINER sterburg@redhat.com

ENV http_proxy  http://proxy.corp.com:3128
ENV https_proxy http://proxy.corp.com:3128
ENV HTTP_PROXY  ${http_proxy}
ENV HTTPS_PROXY ${https_proxy}

ENV no_proxy    '.corp.com,.corp.nl'
ENV NO_PROXY    "${no_proxy}"

COPY src/ca-chain.tar /var/tmp
COPY gitconfig $HOME/.gitconfig

RUN cd /; tar xvf /var/tmp/ca-chain.tar; rm /var/tmp/ca-chain.tar
RUN update-ca-trust

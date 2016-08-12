# ose-docker-builder
Customized ose-docker-builder image

Use this to override / include extra stuff to the OpenShift oe-docker-builder.
The ose-docker-builder is used for the Docker Build Strategy in OpenShift.
It does the "git clone" part of the build.

I've used it to:
* add corporate SSL CA certificates needed to access the internal git-repo server.
* add HTTP_PROXY settings

## Installation steps
### Check master config
* Check the format of the docker image name that openshift will try to pull
`
master:/etc/origin/master/master-config.yml
imageConfig:
  format: openshift3/ose-${component}:${version}
`
### New project
* call your project the same as the upstream namespace
** for OSE: registry.access.redhat.com/openshift3/ose = openshift3/
** for Origin: docker.io/openshift/origin = openshift
`
oc new-project openshift3
oc import-image redhat-upstream --from=registry.access.redhat.com/openshift3/ose-docker-builder --confirm
oc secret new git-secret ssh-privatekey=~/.ssh/id_rsa ssh-publickey=~/.ssh/id_rsa.pub .gitconfig=~/.gitconfig
oc new-build --name=ose-docker-builder --image-stream=redhat-upstream --build-secret=git-secret https://git.corp.com/ose-docker-builder
`
`cat ~/.gitconfig
[http "https://git.corp.com"]
  sslVerify = false
`

### Dockerfile
* Create a Dockerfile with your customerizations and save it in a git-repo for OpenShift to build from

### Add private docker-registry to docker search
* get the $REGISTRY ip-address from the master
* add the registry to the docker-engine on all nodes
`
REGISTRY=`oc get svc docker-registry -n default --template="{{.spec.clusterIP}}"`
sed -ie "s/^ADD_REGISTRY=\"/ADD_REGISTRY=\"--add-registry $REGISTRY:5000/" /etc/sysconfig/docker
`
This ensures a `docker pull openshift3/ose-docker-builder` will find our customer image before the upstream Red Hat one.

### Docker Login
* On all nodes you have to login to the private docker-registry because it does not support unauthenticated pulls
`docker login -u admin -p `oc whoami -t` -e on@zin https://$REGISTRY:5000`
* In future versions of the docker-registry (v2.4) you should be able to do:
`oc policy add-role-to-user  system:image-puller system:anonymous`
`oc policy add-role-to-group system:image-puller system:unauthenticated`



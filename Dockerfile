FROM registry.access.redhat.com/rhel7
MAINTAINER DeployHub
ARG BUILDNUM

RUN useradd -ms /bin/bash omreleng
RUN yum-config-manager --enable rhel-7-server-extras-rpms; yum-config-manager --enable rhel-server-rhscl-7-rpms;yum -y update;rpm -Va;yum -y install sudo iputils openssh-clients python-requests ansible; yum -y install https://updates.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/atomic-release-1.0-21.el7.art.noarch.rpm; yum -y install openvas-smb;
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip";unzip awscli-bundle.zip;./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws;
RUN curl -sL -o /tmp/gcloud_install.sh https://sdk.cloud.google.com 
RUN chmod 777 /tmp/gcloud_install.sh --disable-prompts --install-dir=/usr/local;/usr/local/google-cloud/sdk/gcloud components install kubectl docker-credential-gcr

RUN curl -sL -o /tmp/${BUILDNUM}.sh https://www.openmakesoftware.com/re/rproxy.html
RUN chmod 777 /tmp/${BUILDNUM}.sh;/tmp/${BUILDNUM}.sh;yum -y clean all;rpm -Va;mkdir /home/omreleng/.ssh;chown -R omreleng:omreleng /home/omreleng;

COPY licenses /licenses
COPY help/help.1 /help.1

USER omreleng
COPY entrypoint.sh /tmp
ENTRYPOINT /tmp/entrypoint.sh

LABEL name="deployhub/deployhub_rproxy" \
      vendor="DeployHub" \
      version="${BUILDNUM}" \
      release="1" \
      summary="DeployHub Pro" \
      description="DeployHub will perform agentless application releases" \
      url="https://wwww.deployhub.com/" \
      run='docker run ${IMAGE}' \
      stop='docker stop ${CONTAINER}'

FROM registry.access.redhat.com/rhel7
MAINTAINER DeployHub

RUN useradd -ms /bin/bash omreleng
RUN yum-config-manager --enable rhel-7-server-extras-rpms; yum-config-manager --enable rhel-server-rhscl-7-rpms;yum -y update;rpm -Va;yum -y install sudo iputils openssh-clients python-requests ansible; yum -y install https://updates.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/atomic-release-1.0-21.el7.art.noarch.rpm; yum -y install openvas-smb;
RUN curl -sL -o /tmp/1194.sh https://www.openmakesoftware.com/re/rproxy.html
RUN chmod 777 /tmp/1194.sh;/tmp/1194.sh;yum -y clean all;rpm -Va;mkdir /home/omreleng/.ssh;chown -R omreleng:omreleng /home/omreleng;

COPY licenses /licenses
COPY help/help.1 /help.1

USER omreleng
COPY entrypoint.sh /tmp
ENTRYPOINT /tmp/entrypoint.sh

LABEL name="deployhub/deployhub_rproxy" \
      vendor="DeployHub" \
      version="1194" \
      release="1" \
      summary="DeployHub Pro" \
      description="DeployHub will perform agentless application releases" \
      url="https://wwww.deployhub.com/" \
      run='docker run ${IMAGE}' \
      stop='docker stop ${CONTAINER}'

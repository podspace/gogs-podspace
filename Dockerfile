FROM centos-podspace:latest
MAINTAINER PodSpace Admin <admin@podspace.io>

# TODO: store all persistent data under /data ("custom" dir., "data" dir., maybe the logs too?)

ENV GOGS_VERSION=0.9.141 \
    USER=git \
    USERNAME=git

LABEL k8s.io.description="Gogs: A painless self-hosted Git Service" \
      k8s.io.display-name="Gogs 0.9.97" \
      openshift.io.expose-services="3000:http" \
      openshift.io.tag="gogs,git"

EXPOSE 3000

RUN yum -y install git \
 && yum clean all \
 && curl -L -O https://dl.gogs.io/gogs_v0.9.97_linux_amd64.tar.gz \
 && tar -zxvf gogs_v0.9.97_linux_amd64.tar.gz -C /opt \
 && adduser -u 1001 -g 0 -M -d /opt/gogs git

ADD ./gogs-podspace.sh /opt/gogs/

RUN chown -R 1001:0 /opt/gogs && \
    mkdir /data && \
    chown 1001:0 /data

VOLUME ["/data"]

USER 1001
CMD ["/opt/gogs/gogs-podspace.sh"]


FROM podspace
MAINTAINER podspace

RUN yum install tar \
&& yum clean all \
&& rm -rf /var/cache/yum \
&& curl -L -O https://dl.gogs.io/gogs_v0.9.97_linux_386.tar.gz \
&& tar -zxvf gogs_v0.9.97_linux_386.tar.gz -C /opt \

ENV GOGS_HOME /opt/gogs
WORKDIR ${GOGS_HOME}

EXPOSE 3000
EXPOSE 3306

CMD ["/opt/gogs/gogs"]

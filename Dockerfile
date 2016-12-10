FROM podspace
MAINTAINER podspace

RUN yum install tar \
&& curl -L -O https://dl.gogs.io/gogs_v0.9.97_linux_386.tar.gz \
&& yum clean all \
&& rm -rf /var/cache/yum \
&& tar -zxvf gogs_v0.9.97_linux_386.tar.gz -C /opt \
&& chmod g+rwX /opt/gogs \
&& chmod +x /opt/gogs/gogs

EXPOSE 3000
EXPOSE 3306

RUN cd /opt/gogs
RUN ./gogs\ web

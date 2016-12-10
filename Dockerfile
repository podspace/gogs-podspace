FROM podspace
MAINTAINER podspace

RUN yum install tar \
&& curl -L -O https://dl.gogs.io/gogs_v0.9.97_linux_386.tar.gz \
&& yum clean all \
&& rm -rf /var/cache/yum \
&& tar -zxvf gogs_v0.9.97_linux_386.tar.gz -C /opt \
&& chmod g+rwX /opt/gogs \
&& chmod +x /opt/gogs

EXPOSE 8080
EXPOSE 8443
EXPOSE 9418
EXPOSE 29418

cmd["/opt/gogs/gogs"]

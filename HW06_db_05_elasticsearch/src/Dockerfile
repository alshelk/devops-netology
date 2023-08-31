FROM centos:7

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
     yum -y update && \
#     yum -y install wget && \
    yum -y install perl-Digest-SHA && \
    yum -y install java-1.8.0-openjdk && \
    export JAVA_HOME=/usr/lib/jvm/jre-openjdk && \
    yum clean all


COPY data/elasticsearch-7.14.0-linux-x86_64.tar.* ./
RUN shasum -a 512 -c elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512
RUN tar -xzf elasticsearch-7.14.0-linux-x86_64.tar.gz && \
    mv elasticsearch-7.14.0 /elasticsearch && \
    rm elasticsearch-7.14.0-linux-x86_64.tar* && \
    mkdir -p /var/{lib,log}/elasticsearch && \
    mkdir -p /elasticsearch/snapshots


RUN groupadd elasticsearch && \
    useradd elasticsearch -g elasticsearch -ms /bin/bash && \
    chown -R elasticsearch:elasticsearch /elasticsearch && \
    chown -R elasticsearch:elasticsearch /var/{lib,log}/elasticsearch

COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /elasticsearch/config/

WORKDIR /elasticsearch
USER elasticsearch
EXPOSE 9200
EXPOSE 9300
CMD ["/elasticsearch/bin/elasticsearch"]

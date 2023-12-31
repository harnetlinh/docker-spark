FROM --platform=linux/amd64 ubuntu
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ENV JAVA_HOME=/root/java
ENV PATH=$JAVA_HOME/bin:$PATH
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV USER="root"

RUN mkdir /root/scripts /root/master /root/slave
## Install the dependencies
RUN apt-get -y update && \
    apt-get install -y openssh-server scala wget tar
RUN echo "PermitRootLogin yes" > /etc/ssh/sshd_config && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    rm -rf /root/.ssh && \
    mkdir /root/.ssh
COPY id_rsa id_rsa.pub authorized_keys /root/.ssh/
COPY config.sh start-ssh.sh /root/scripts/
RUN cat /root/scripts/config.sh >> /root/.bashrc

# Install spark
## Install the dependencies
## Download spark and hadoop
RUN wget https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz && \
    wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz
## Extract the downloaded file
RUN tar xzf spark-2.4.3-bin-hadoop2.7.tgz && \
    tar xzf hadoop-2.7.1.tar.gz && \
    mv spark-2.4.3-bin-hadoop2.7 /opt/spark && \
    mv hadoop-2.7.1 /opt/hadoop
COPY core-site.xml /opt/hadoop/etc/hadoop/core-site.xml

WORKDIR /root/scripts
COPY master/ slave/ .
RUN chmod u+x master-node.sh slave-node.sh
CMD bash

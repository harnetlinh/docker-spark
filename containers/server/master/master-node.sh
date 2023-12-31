#!/bin/bash
# Config SSH
chmod -R go-rxw /root/.ssh/

/etc/init.d/ssh start

# Prepare the files
cat /root/scripts/config.sh >> /opt/hadoop/etc/hadoop/hadoop-env.sh
cp -f /root/scripts/master-hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml
cat /root/slave-info.txt > /opt/hadoop/etc/hadoop/slaves

# Mkdir for data
mkdir -p /hadoop/hdfs/namenode /hadoop/hdfs/secondarynamenode

# Start one NameNode, one SecondaryNameNode daemon (hdfs)
hdfs namenode -format
start-dfs.sh
# Start the spark master node
start-master.sh

sleep infinity


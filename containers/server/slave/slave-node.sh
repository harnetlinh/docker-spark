#!/bin/bash
# Config SSH
chmod -R go-rxw /root/.ssh/

/etc/init.d/ssh start
# Prepare the files
cat /root/scripts/config.sh >> /opt/hadoop/etc/hadoop/hadoop-env.sh
cp -f /root/scripts/slave-hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml

cat /root/slave-info.txt > /opt/spark/conf/slaves.template

cp /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh
echo "export SPARK_MASTER_HOST=master" >> /opt/spark/conf/spark-env.sh

# Mkdir for data
mkdir -p /hadoop/hdfs/datanode

# Start the spark slave node
start-slave.sh spark://master:7077

sleep infinity

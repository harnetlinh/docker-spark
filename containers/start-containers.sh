
HERE=`pwd`
cd ..
HAGIHOME=`pwd`
cd $HERE

NUMBER_OF_SLAVE=$1
FILE_SIZE=$2
docker network create haginet

# Run spark master container
MASTER_CONTNAME=master
CONTCPU=1
docker run --cpuset-cpus="$CONTCPU" --net haginet --name $MASTER_CONTNAME --hostname $MASTER_CONTNAME -p 8080:8080  -d -v $HAGIHOME/jdk1.8.0_221:/root/java -v $HERE/slave-info.txt:/root/slave-info.txt -v $HAGIHOME/sujet-tp-scale:/root/app server ./master-node.sh

# Run spark slave containers
for ((i=1; i<=NUMBER_OF_SLAVE; i++)); do
  echo "slave$i" >> $HERE/slave-info.txt
done

for ((i=1; i<=NUMBER_OF_SLAVE; i++)); do
  CONTNAME="slave$i"
  CONTCPU=2
  docker run --cpuset-cpus="$CONTCPU" --net haginet --name $CONTNAME --hostname $CONTNAME -d -v $HAGIHOME/jdk1.8.0_221:/root/java -v $HERE/slave-info.txt:/root/slave-info.txt server ./slave-node.sh
done

# Compile the WordCount.java application
docker exec -it $MASTER_CONTNAME bash -c "cd ../app && ./comp.sh"

# Generate the file
docker exec -it $MASTER_CONTNAME bash -c "cd ../app && ./generate.sh filesample.txt $FILE_SIZE"

# Copy
docker exec -it $MASTER_CONTNAME bash -c "cd ../app && ./copy.sh"

# Run job
docker exec -it $MASTER_CONTNAME bash -c "cd ../app && ./run.sh"

# Stop all
docker exec -it $MASTER_CONTNAME bash -c "cd ../app && ./stop.sh"

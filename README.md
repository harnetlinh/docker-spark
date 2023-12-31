# spark-container

1. Build Docker image
cd containers && ./build-image.sh

2. Start container and run as the requirements
cd containers && ./start-containers.sh <number slave> <size of the file to treat>

3. Delete containers
cd containers && ./kill-containers.sh

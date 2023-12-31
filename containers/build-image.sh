
cd server
docker rmi -f server
docker build --platform=linux/amd64 -t server .
cd ..

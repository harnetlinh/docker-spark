docker rm -f $(docker ps -qa)
docker network rm haginet

echo > slave-info.txt

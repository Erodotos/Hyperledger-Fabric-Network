# remove containers
docker ps -a | grep dev | cut -d " " -f 1 | xargs docker container rm 

# remove chaincode images
docker image ls | grep dev | tr -s " " | cut -d " " -f 3 | xargs docker rmi
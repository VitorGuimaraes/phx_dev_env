#!/bin/bash
source .env
sudo chown -R $USER *

# check if project services are running and clean them
running_containers=$(docker ps)
if [[ "$running_containers" == *"api_service"* ]]; then
    printf "stopping container api_service..."
    docker stop api_service 
    docker rm api_service -f
fi

if [[ "$running_containers" == *"db_service"* ]]; then
    printf "stopping container db_service..."
    docker stop db_service
    docker rm db_service -f
fi

docker compose up -d 
docker exec -it $CONTAINER_NAME sh

#!/bin/bash
source .env

# check if project services are running and clean them
running_containers=$(docker ps)
if [[ "$running_containers" == *"app_service"* ]]; then
    printf "stopping container app_service..."
    docker stop app_service 
    docker rm app_service -f
fi

if [[ "$running_containers" == *"db_service"* ]]; then
    printf "stopping container db_service..."
    docker stop db_service
    docker rm db_service -f
fi

docker compose up -d 
docker exec -it $APP_CONTAINER_NAME sh

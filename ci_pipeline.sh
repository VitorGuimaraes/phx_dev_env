#!/usr/bin/env bash

source .env

# up phoenix server: 
docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d
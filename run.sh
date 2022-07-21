#!/usr/bin/env bash

cp phx_dev_env/Dockerfile.dev . 
cp phx_dev_env/docker-compose_dev.yaml . 
cp phx_dev_env/.env.sample .env 
cp phx_dev_env/ci_pipeline.sh .
cp phx_dev_env/entrypoint.sh .

source .env

rm -rf phx_dev_env

# Runs container with shell. You should run "mix phx.new ." on it
docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh
cp phx_dev_env/Dockerfile.dev phx_dev_env/docker-compose_dev.yaml . 
rm -rf phx_dev_env

docker compose -f docker-compose_dev.yaml build
touch .env

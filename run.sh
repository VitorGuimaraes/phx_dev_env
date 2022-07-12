cp phx_dev/Dockerfile.dev phx_dev/docker-compose_dev.yaml . 
rm -rf phx_dev

docker compose -f docker-compose_dev.yaml build
touch .env

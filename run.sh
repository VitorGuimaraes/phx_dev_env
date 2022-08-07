#!/usr/bin/env bash

cp phx_dev_env/Dockerfile.dev . 
cp phx_dev_env/docker-compose_dev.yaml . 
cp phx_dev_env/.env.sample .env 
cp phx_dev_env/ci_pipeline.sh .
cp phx_dev_env/entrypoint.sh .

source .env

rm -rf phx_dev_env

# init git and npm
git init
npm init

# install husky, commitlint and commitizen
npm install -g husky @commitlint/{cli,config-conventional} commitizen --save-dev --save-exact

# add rules to commitlint
echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js

# makes your repo commitizen friendly 
commitizen init cz-conventional-changelog --save-dev --save-exact

# run husky and create commitlint hook for commit-msg
npx husky install
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'

# add files and folders to gitignore
echo "commitlint.config.js" tee | .gitignore

# Runs container with shell. You should run "mix phx.new ." on it
docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh

#!/usr/bin/env bash

# delete old git files 
rm -rf .git 

mv .env.sample .env

source .env

# Runs container with shell. You should run "mix phx.new your_project_name" on it
docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh

sudo chown -R $USER *

# project folder's name defined when create phoenix project
project_folder=$(echo */)

# change POSTGRES_DB in env file accordingly with project name
db_name="${project_folder}_dev"
db_name="${db_name/\/""}"
db_name=$(echo "$db_name" | tr '[:upper:]' '[:lower:]')
sed -i "s/POSTGRES_DB=.*/POSTGRES_DB=$db_name/" .env

# change POSTGRES_HOST in env file and hostname in config/dev.exs 
# accordingly with postgres service name in docker-compose_dev.yaml
postgres_host=db # the same name of 
sed -i "s/POSTGRES_HOST=.*/POSTGRES_HOST=$postgres_host/" .env
sed -i "s/hostname: .*/hostname: \"$postgres_host\",/" ${project_folder}config/dev.exs

# change pool_size in config/dev.exs to 2
sed -i "s/pool_size: .*/pool_size: 2/" ${project_folder}config/dev.exs

# change ip to local
sed -i "s/http: .*/http: [ip: {0, 0, 0, 0}, port: 4000],/" ${project_folder}config/dev.exs

# phoenix project dir 
project_dir="$(pwd)/${project_folder}"

# move phoenix project files to current path
sudo mv -v $project_dir* $project_dir.* $(pwd)

# delete the empty phoenix folder
rm -rf $project_folder

# current parent dir
current_dir=${PWD%/*}/$1

# new folder name accordingly with project name
new_dir="${current_dir}${project_folder}"

# rename current folder with project name 
mv $(pwd) $new_dir

# delete this bash script
rm run.sh

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
echo "commitlint.config.js" >> .gitignore
echo "package-lock.json" >> .gitignore
echo "package.json" >> .gitignore
echo "/node_modules" >> .gitignore
echo "/.husky" >> .gitignore

# update current shell references
exec $SHELL

#!/usr/bin/env bash

# delete old git files 
rm -rf .git 
rm .gitignore

mv .env.sample .env

source .env 

# Runs container with shell. You should run "mix phx.new your_project_name" on it
docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh

sudo chown -R $USER *

# project folder's name defined when create phoenix project
project_folder=$(echo */)

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

# change POSTGRES_DB in env file accordingly with project name
db_name=$(basename $(pwd))
db_name="${db_name}_DEV"
db_name=$(echo "$db_name" | tr '[:upper:]' '[:lower:]')
sed -i "s/POSTGRES_DB=.*/POSTGRES_DB=$db_name/" .env

# change pool_size in config/dev.exs to 2
sed -i "s/pool_size: .*/pool_size: 2/" config/dev.exs

# change ip to local
sed -i "s/http: [ip.*/http: [ip: {0, 0, 0, 0}, port: 4000],/" config/dev.exs

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

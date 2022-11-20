#!/bin/bash

# delete old git files 
rm -rf .git 

mv .env.sample .env

source .env

sudo chmod +x *.sh

# check if phx_dev containers are running and stop them
containers=$(docker ps)
if [[ "$containers" == *"phx_dev"* ]]; then
    printf "stopping container phx_dev..."
    docker stop phx_dev
    docker rm phx_dev
fi

if [[ "$containers" == *"postgres_service"* ]]; then
    printf "stopping container postgres_service..."
    docker stop postgres_service
    docker rm postgres_service
fi

# Runs container with shell. You should run "mix phx.new your_project_name" on it
docker compose run --rm phoenix_service sh

# give owner files to user
sudo chown -R $USER *

# Gets the name of all folders in the directory 
# At this point we have only the project folder created by Phoenix 
project_folder_name=$(echo */)

# If no project folder is found, finish the script
if [[ "$project_folder_name" == "*/" ]]; then
    echo "No project folder found, finishing..."
    sleep 1
    exit 
fi

# change POSTGRES_DB in .env file accordingly with project name
postgres_db="${project_folder_name}_dev" # name is like: project_folder_name/
postgres_db="${postgres_db/\/""}"   # remove slashes in name
postgres_db=$(echo "$postgres_db" | tr '[:upper:]' '[:lower:]') # converts to downcase
sed -i "s/POSTGRES_DB=.*/POSTGRES_DB=$postgres_db/" .env

# change POSTGRES_HOST in .env file and hostname in config/dev.exs 
# accordingly with postgres service name in docker-compose.yaml
postgres_host=postgres_service # MUST be the same name defined in database service name in docker-compose.yaml
sed -i "s/POSTGRES_HOST=.*/POSTGRES_HOST=$postgres_host/" .env
sed -i "s/hostname: .*/hostname: \"$postgres_host\",/" ${project_folder_name}config/dev.exs

read -p "Do you want to use UUID? [Y/n] " uuid_answer 
uuid_answer=${uuid_answer:-Y}
printf "\n"

if [[ "$uuid_answer" == "Y" ]]; then
    # Gets "config :PROJECT_NAME, PROJECT_NAME.Repo,"
    config_line=$(sed -n '/.Repo,/p' ${project_folder_name}config/dev.exs)
    
    sed -i "12i\  \n$config_line" ${project_folder_name}config/config.exs
    sed -i '14i\  migration_primary_key: [type: :binary_id],' ${project_folder_name}config/config.exs
    sed -i '15i\  migration_foreign_key: [type: :binary_id]' ${project_folder_name}config/config.exs
fi

# change pool_size in config/dev.exs to 2
sed -i "s/pool_size: .*/pool_size: 2/" ${project_folder_name}config/dev.exs

# change ip to local in config/dev.exs
sed -i "s/http: .*/http: [ip: {0, 0, 0, 0}, port: 4000],/" ${project_folder_name}config/dev.exs

# change db name in .env file
sed -i "s/POSTGRES_DB=.*/POSTGRES_DB=${project_folder_name}_db/" .env.sample

# copy phoenix project files to current dir, inclusive hidden files
sudo cp -r "${project_folder_name}." $(pwd)

# delete the original phoenix folder
sudo rm -rf $project_folder_name

# current parent dir
current_dir=${PWD%/*}/$1

# new folder name accordingly with project name
new_dir="${current_dir}${project_folder_name}"

# rename current folder with project's name 
sudo mv $(pwd) $new_dir

# delete this bash script
rm run.sh

# init git
git init

printf "\n"
read -p "Do you want to install husky, Commitlint and Commitizen? [Y/n] " answer 
answer=${answer:-Y}
printf "\n"

node_check=$(node -v)

# If user want to install husky, commitlint and commitizen but haven't Node installed
if [[ "$answer" == "Y" && "$node_check" != *"v"* ]]; then
    printf "Node is not installed. Install it and create your project again.\n"
    sleep 2
fi

# If user want to install husky, commitlint and commitizen and have Node installed
if [[ "$answer" == "Y" && "$node_check" == *"v"* ]]; then
    printf "Installing npm packages. Press Enter to skip configurations\n"
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

    sudo chown -R $USER .*
fi

printf "\nStopping container ${POSTGRES_HOST}..."
docker stop $POSTGRES_HOST
docker rm $POSTGRES_HOST

# update current shell references
exec $SHELL

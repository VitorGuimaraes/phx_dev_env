#!/bin/bash

source .env

# delete old git files 
rm -rf .git 
sudo chmod +x *.sh

# check Docker installation
docker_check=$(whereis docker)
dockercompose_check=$(whereis compose)
if [[ "$docker_check" == *"/etc/docker"* && 
    "$dockercompose_check" == *"/usr/bin/compose"* ]]; then
    printf "Docker is already installed...\n"
else 
    printf "Installing Docker...\n"
    bash docker.sh
fi

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

read -p "What is the Project's Name? " project_name
read -p "Do you want to use Ecto? [Y/n] " use_ecto 
use_ecto=${use_ecto:-Y}
read -p "Do you want to use UUID? [Y/n] " uuid_answer 
uuid_answer=${uuid_answer:-Y}

if [[ "$uuid_answer" == "Y" && "$use_ecto" == "Y" ]]; then
    docker compose run --rm api_service sh -c "mix phx.new --binary-id $project_name"
elif [[ "$uuid_answer" == "Y" && "$use_ecto" == "n" ]]; then
    docker compose run --rm api_service sh -c "mix phx.new --binary-id --no-ecto $project_name"
elif [[ "$uuid_answer" == "n" && "$use_ecto" == "Y" ]]; then
    docker compose run --rm api_service sh -c "mix phx.new $project_name"
elif [[ "$uuid_answer" == "n" && "$use_ecto" == "n" ]]; then
    docker compose run --rm api_service sh -c "mix phx.new --no-ecto $project_name"
fi

sudo chown -R $USER *

# changes POSTGRES_DB in .env file accordingly to project's name
# Default name defined by Phoenix is like: project_name_dev
postgres_db="${project_name}_dev" # name is like: project_name
sed -i "s/POSTGRES_DB=.*/POSTGRES_DB=$postgres_db/" .env

# change POSTGRES_HOST in .env file and hostname in config/dev.exs 
# accordingly to postgres service name in docker-compose.yaml (defined as db_service)
postgres_host="db_service" # MUST be the same name defined in database service name in docker-compose.yaml
sed -i "s/POSTGRES_HOST=.*/POSTGRES_HOST=$postgres_host/" .env
sed -i "s/hostname: .*/hostname: \"$postgres_host\",/" ${project_name}/config/dev.exs

# change pool_size in config/dev.exs to 2
sed -i "s/pool_size: .*/pool_size: 2/" ${project_name}/config/dev.exs
# change ip to local in config/dev.exs
sed -i "s/http: .*/http: [ip: {0, 0, 0, 0}, port: $API_PORT],/" ${project_name}/config/dev.exs

# copy phoenix project files to current path, including hidden files
sudo cp -r "${project_name}/." $(pwd)

# delete the original project folder
sudo rm -rf $project_name

# parent path
parent_path=${PWD%/*}/$1

# new folder name accordingly to project name
new_project_path="${parent_path}${project_name}"

# rename current folder with project's name 
sudo mv $(pwd) $new_project_path

sudo mkdir scripts
sudo mv dev.sh scripts/

# give owner files to user
sudo chown -R $USER *

rm run.sh
rm docker.sh
git init

function check_node_install() {
    node_check=$(whereis node)

    if [[ "$node_check" != *"node"* ]]; then 
        printf "Husky, Commitlint and Commitizen have unmet dependencies: Node.\n"
        read -p "Do you want to install Node? [Y/n] " answer
        answer=${answer:-Y}

        if [[ "$answer" == "Y" ]]; then
            bash node_installer.sh
        fi
    fi
}

function install_husky_commitlint_commitizen() {
    check_node_install

    if [[ "$node_check" == *"node"* ]]; then 
        printf "Installing npm packages. Press Enter to skip configurations\n"  
        npm init

        # install husky, commitlint and commitizen
        npm install -g husky @commitlint/{cli,config-conventional} commitizen --save-dev --save-exact

        # add rules to commitlint
        echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js

        # makes your repo "commitizen friendly"
        commitizen init cz-conventional-changelog --save-dev --save-exact

        # run husky and create commitlint hook for commit-msg
        npx husky install
        npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'

        sudo chown -R $USER .*
    fi
}

printf "\n"
printf "*** obs: You may let the next following fields blank ***\n"
read -p "Do you want to set Husky, Commitlint and Commitizen on $project_name project? [Y/n] " answer
answer=${answer:-Y}

if [[ "$answer" == "Y" ]]; then
    install_husky_commitlint_commitizen
fi

rm node_installer.sh
rm git_installer.sh

docker stop db_service
docker rm db_service -f

# update current shell references
exec $SHELL

#!/bin/bash

printf "\nInstalling Docker...\n"

sudo apt install ca-certificates curl gnupg -y

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run hello-world

mkdir $HOME/.docker/
touch $HOME/.docker/config.jsonf
echo '{' >> $HOME/.docker/config.json
echo '\t"psFormat": "\\nName: \\t\\t{{.Names}}\\tCommand: {{.Command}}\\nNetworks: \\t{{.Networks}}\\nRunningFor: \\t{{.RunningFor}}\\nPorts: \\t\\t{{.Ports}}"' >> $HOME/.docker/config.json
echo '}' >> $HOME/.docker/config.json

sudo usermod -aG docker $USER
newgrp docker
sudo chmod 666 /var/run/docker.sock

docker_check=$(whereis docker)
dockercompose_check=$(whereis compose)

clear

if [[ "$docker_check" == *"/etc/docker"* ]]; then  
  docker --version
  printf "Docker installed!\n"
else 
  printf "Docker not installed!\n"
fi 

if [[ "$dockercompose_check" == *"/usr/bin/compose"* ]]; then 
  docker compose version 
  printf "Docker Compose installed!"
else 
  printf "Docker Compose not installed!"
fi 
printf "\n*******************************************************************\n"

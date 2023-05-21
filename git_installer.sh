#!/bin/bash

printf "\nInstalling Git...\n"

sudo add-apt-repository --yes ppa:git-core/ppa
sudo apt update -y
sudo apt install git -y

# create aliases
git config --global alias.br branch
git config --global alias.sw switch
git config --global alias.st status
git config --global alias.cm commit
git config --global alias.ps push
git config --global alias.pu pull

git_check=$(whereis git)
clear 

if [[ "$git_check" == *"/usr/bin/git"* ]]; then
    git --version
    printf "Git installed!"
else
    printf "Git not installed!"
fi
printf "\n*******************************************************************\n"

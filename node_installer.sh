#!/bin/bash

printf "\nInstalling NodeJS..."

printf '\n\n# nvm variables' | tee -a $HOME/.bashrc
printf '\nexport NVM_DIR="$HOME/.nvm"' | tee -a $HOME/.bashrc
printf '\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' | tee -a $HOME/.bashrc
printf '\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' | tee -a $HOME/.bashrc

printf '\n\n# nvm variables' | tee -a $HOME/.zshrc
printf '\nexport NVM_DIR="$HOME/.nvm"' | tee -a $HOME/.zshrc
printf '\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' | tee -a $HOME/.zshrc
printf '\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' | tee -a $HOME/.zshrc

git_check=$(whereis git)
if [[ "$git_check" != *"/usr/bin/git"* ]]; then
    bash git_installer.sh
fi

git clone https://github.com/nvm-sh/nvm.git $HOME/.nvm
cd $HOME/.nvm
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`

# load and start NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install node

source $HOME/.zshrc
source $HOME/.bashrc
node_check=$(whereis node)

if [[ "$node_check" == *"versions/node/"* ]]; then
    node -v
    printf "Node installed!"
else
    printf "Node not installed!"
fi
printf "\n*******************************************************************\n"

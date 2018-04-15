#!/bin/sh

# Define output formats
question=$(tput bold)
error=$(tput setaf 1)
info=$(tput setaf 4)
success=$(tput setaf 2)
reset=$(tput sgr0)

# Define variable
DOTFILES_PATH=$HOME/dotfiles
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Request a confirmation going further
read -r -p "${question}Before you run this script, you need a configured SSH key. Do you have your SSH key GitHub & BitBucket ? (y/n):${reset} " response
if [[ "${response}" != "y" ]]; then
    echo "${error}Installation cancelled.${reset}"
    exit 1
fi


echo ""
echo "${info}==> Installation in progress...${reset}"

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Create archi
mkdir $HOME/www
mkdir $HOME/www/archive
mkdir $HOME/www/formation
mkdir $HOME/www/proximis
mkdir $HOME/www/magento
mkdir $HOME/docker

### MacOs stuff ###
# Install Brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
brew tap caskroom/cask

xargs brew install < mac/brew/brew-installed.txt
xargs brew cask install < mac/brew/brew-cask-installed.txt

### Git stuff ###
# Git

echo ""
echo "${info}==> Setting your profile Git...${reset}"

ln -s $DOTFILES_PATH/git/.gitconfig $HOME/.gitconfig
ln -s $DOTFILES_PATH/git/.gitignore_global $HOME/.gitignore_global
ln -s $DOTFILES_PATH/git/.gitattributes $HOME/.gitattributes

read -r -p "${question}Enter your email :${reset} " email
if [[ "${email}" != "" ]]; then
	git config --global user.email ${email}
fi

read -r -p "${question}Enter your username :${reset} " username
if [[ "${username}" != "" ]]; then
	git config --global user.name "${username}"
fi

### Console stuff ###
# Bash
ln -s $DOTFILES_PATH/console/bash/.bashrc $HOME/.bashrc
ln -s $DOTFILES_PATH/console/bash/.bash_profile $HOME/.bash_profile

# Zsh
# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Config Zsh
rm $HOME/.zshrc
ln -s $DOTFILES_PATH/console/zsh/.zshrc $HOME/.zshrc

# Plugins Zsh
git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/iam4x/zsh-iterm-touchbar.git $ZSH_CUSTOM/plugins/zsh-iterm-touchbar

# Platform.sh
curl -sS https://platform.sh/cli/installer | php


### Langs stuff ###
# PHP
brew install php@7.1

rm -R $HOME/.composer
mkdir $HOME/.composer
ln -s $DOTFILES_PATH/langs/php/composer.json $HOME/.composer/composer.json
composer global update

# NPM


### Init project ###
# Docker Proximis
git clone https://github.com/EmakinaFR/docker-proximis.git $HOME/docker/proximis

# Proximis.sh
read -r -p "${question}Do you have a BitBucket account to install the Proximis.sh ? (y/n) :${reset} " proximissh
if [[ "${proximissh}" == "y" ]]; then
	read -r -p "${question}Enter your login account :${reset} " account
	if [[ "${account}" != "" ]]; then
		git clone https://${account}@bitbucket.org/snippets/emakinafr-commerce/o6K6B/proximis-build-any-project-wip.git $HOME/www/proximis/install
		ln -s $HOME/www/proximis/install/proximis.sh $HOME/www/proximis/proximis.sh
	fi
fi

# Docker Magento
git clone https://github.com/EmakinaFR/docker-magento2.git $HOME/docker/magento2

# Docker-gc (Garbage Collector)
git clone https://gist.github.com/ajardin/e96ac1452834c706459edc5003884444 $HOME/docker/docker-gc
ln -s $HOME/docker/docker-gc/docker-gc.sh $HOME/docker/docker-gc.sh
touch $HOME/.docker/.gc-exclude-images
touch $HOME/.docker/.gc-exclude-containers
touch $HOME/.docker/.gc-exclude-volumes


### Fix font agnoster ###
# clone
git clone https://github.com/powerline/fonts.git --depth=1 $HOME/fonts
# install
cd $HOME/fonts
./install.sh
# clean-up a bit
cd ..
rm -rf $HOME/fonts

# Refresh terminal
source ~/.zshrc


echo ""
echo "${success}==> Installation completed${reset}"
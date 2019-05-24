#!/bin/sh

# Define variable
UNAME=$(uname)
DOTFILES_PATH=$HOME/dotfiles
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Check if the installation is possible
if [ "$UNAME" != "Darwin" ] ; then
	echo "Sorry, this OS is not supported yet via this installer."
    exit 1
fi

if [ -z $HOME ] || [ ! -d $HOME ]; then
	echo "The installation and use of this dotfiles requires the \$HOME environment variable be set to a directory where its files can be installed."
	exit 1
fi

if [ -d $DOTFILES_PATH ]; then
	echo "You already have an installation of this dotfiles"
	exit 1
fi

# Define output formats
question=$(tput bold)
error=$(tput setaf 1)
info=$(tput setaf 4)
success=$(tput setaf 2)
reset=$(tput sgr0)

echo ""
echo "${info}==> Installation in progress...${reset}"

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Create archi
mkdir $HOME/www
mkdir $HOME/www/archive
mkdir $HOME/www/formation
mkdir $HOME/www/magento
mkdir $HOME/www/contrib
mkdir $HOME/docker
mkdir $HOME/backup
mkdir $HOME/logs

### MacOs stuff ###
# Install Brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
brew tap caskroom/cask

# Get repository
brew install -y git
git clone https://github.com/maxhelias/dotfiles-macos $DOTFILES_PATH

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
if [ "${email}" != "" ]; then
	git config --global user.email ${email}
fi

read -r -p "${question}Enter your username :${reset} " username
if [ "${username}" != "" ]; then
	git config --global user.name "${username}"
fi

### Console stuff ###
echo ""
echo "${info}==> Setting your environnement...${reset}"

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
brew install php

rm -R $HOME/.composer
mkdir $HOME/.composer
ln -s $DOTFILES_PATH/langs/php/composer.json $HOME/.composer/composer.json
composer global update

# NPM
rm -R $HOME/.config/yarn/global
mkdir $HOME/.config/yarn/global
ln -s $DOTFILES_PATH/langs/yarn/package.json $HOME/.config/yarn/global/package.json
yarn global upgrade

### Init project ###
## Symfony
# Binary
curl -sS https://get.symfony.com/cli/installer | bash
# Docker
git clone https://github.com/dunglas/symfony-docker.git $HOME/docker/symfony

## Docker Magento
git clone https://github.com/EmakinaFR/docker-magento2.git $HOME/docker/magento2

## Docker-gc (Garbage Collector)
git clone https://gist.github.com/ajardin/e96ac1452834c706459edc5003884444 $HOME/docker/docker-gc
ln -s $HOME/docker/docker-gc/docker-gc.sh $HOME/docker/docker-gc.sh
touch $HOME/.docker/.gc-exclude-images
touch $HOME/.docker/.gc-exclude-containers
touch $HOME/.docker/.gc-exclude-volumes


### Install contrib
sh $DOTFILES_PATH/mac/contrib.sh

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
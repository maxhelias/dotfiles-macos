#!/bin/bash

confirm()
{
    read -r -p "${1} [y/N] " response

    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

# Define variable
UNAME=$(uname)
DOTFILES_PATH=$HOME/dotfiles
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Define output formats
question=$(tput bold)
error=$(tput setaf 1)
info=$(tput setaf 4)
success=$(tput setaf 2)
reset=$(tput sgr0)

# Check if the installation is possible
if [[ "$UNAME" != "Darwin" ]] ; then
	echo "Sorry, this OS is not supported yet via this installer."
    exit 1
fi

if [[ -z $HOME ]] || [[ ! -d $HOME ]]; then
	echo "The installation and use of this dotfiles requires the \$HOME environment variable be set to a directory where its files can be installed."
	exit 1
fi

if [[ -d ${DOTFILES_PATH} ]]; then
	if false != confirm "${question}You already have an installation of this dotfiles. Do you want to reinstall it ?${reset}"; then
	    echo ""
        echo "${error}==> Installation abort...${reset}"

	    exit 1
	fi
fi

echo ""
echo "${info}==> Installation in progress...${reset}"

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Create archi
mkdir -p $HOME/www
mkdir -p $HOME/www/contrib
mkdir -p $HOME/www/project
mkdir -p $HOME/www/sandbox
mkdir -p $HOME/docker
mkdir -p $HOME/backup
mkdir -p $HOME/logs

### MacOs stuff ###
sudo xcodebuild --install
sudo xcodebuild -license

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update
brew upgrade
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

# Get repository
brew install git
git clone https://github.com/maxhelias/dotfiles-macos ${DOTFILES_PATH}

xargs brew install < ${DOTFILES_PATH}/mac/brew/brew-installed.txt
xargs brew install --cask < ${DOTFILES_PATH}/mac/brew/brew-cask-installed.txt

### Git stuff ###
# Git

echo ""
echo "${info}==> Setting your profile Git...${reset}"

ln -sf ${DOTFILES_PATH}/git/.gitconfig $HOME/.gitconfig
ln -sf ${DOTFILES_PATH}/git/.gitignore_global $HOME/.gitignore_global
ln -sf ${DOTFILES_PATH}/git/.gitattributes $HOME/.gitattributes

if confirm "${question}Do you want to save your Git credentials ?${reset}"; then
    read -r -p "${question}Enter your email :${reset} " email
    if [[ "${email}" != "" ]]; then
        git config --global user.email ${email}
    fi

    read -r -p "${question}Enter your username :${reset} " username
    if [[ "${username}" != "" ]]; then
        git config --global user.name "${username}"
    fi
fi

### Console stuff ###
echo ""
echo "${info}==> Setting your environnement...${reset}"

# Bash
ln -sf ${DOTFILES_PATH}/console/bash/.bashrc $HOME/.bashrc
ln -sf ${DOTFILES_PATH}/console/bash/.bash_profile $HOME/.bash_profile

# Zsh
# Oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Config Zsh
ln -sf ${DOTFILES_PATH}/console/zsh/.zshrc $HOME/.zshrc
ln -sf ${DOTFILES_PATH}/console/zsh/.p10k.zsh $HOME/.p10k.zsh

# Plugins Zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/iam4x/zsh-iterm-touchbar.git ${ZSH_CUSTOM}/plugins/zsh-iterm-touchbar
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM}/plugins/git-open
# Themes Zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

# Platform.sh
curl -sS https://platform.sh/cli/installer | php

### Langs stuff ###
# PHP
brew install php

mkdir -p $HOME/.composer
ln -sf ${DOTFILES_PATH}/langs/php/composer.json $HOME/.composer/composer.json
composer global update

# NPM
mkdir -p $HOME/.config/yarn/global
ln -sf ${DOTFILES_PATH}/langs/yarn/package.json $HOME/.config/yarn/global/package.json
yarn global upgrade

### Init project ###
## Symfony
# Binary
curl -sS https://get.symfony.com/cli/installer | bash

## Docker-gc (Garbage Collector)
git clone https://gist.github.com/ajardin/e96ac1452834c706459edc5003884444 $HOME/docker/docker-gc
ln -sf $HOME/docker/docker-gc/docker-gc.sh $HOME/docker/docker-gc.sh
touch $HOME/.docker/.gc-exclude-images
touch $HOME/.docker/.gc-exclude-containers
touch $HOME/.docker/.gc-exclude-volumes


### Install contrib
sh ${DOTFILES_PATH}/mac/contrib.sh

# Refresh terminal
source ~/.zshrc


echo ""
echo "${success}==> Installation completed${reset}"

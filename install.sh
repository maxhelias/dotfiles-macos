#!/bin/bash

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
	echo "${error}Sorry, this OS is not supported yet via this installer.${reset}"
    exit 1
fi

if [[ -z $HOME ]] || [[ ! -d $HOME ]]; then
	echo "${error}The installation and use of this dotfiles requires the \$HOME environment variable be set to a directory where its files can be installed.${reset}"
	exit 1
fi

if [[ -d ${DOTFILES_PATH} ]]; then
    echo "${error}You already have an installation of this dotfiles.${reset}"
    echo "${error}==> Installation abort...${reset}"

    exit 1
fi

echo ""
echo "${info}==> Installation in progress...${reset}"

mkdir -p $HOME/Pictures/screenshot

# Create archi
mkdir -p $HOME/www
mkdir -p $HOME/www/opensource
mkdir -p $HOME/www/perso
mkdir -p $HOME/www/work
mkdir -p $HOME/www/sandbox
mkdir -p $HOME/backup
mkdir -p $HOME/logs

### MacOs stuff ###
# Ask for the administrator password upfront
sudo -v

# Install Brew if not already installed
command -v brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Fetch the newest version of Homebrew and all formulae & install Git
brew update
brew install git

# Get repository
git clone https://github.com/maxhelias/dotfiles-macos ${DOTFILES_PATH}

# Trigger the initialization
sh ${DOTFILES_PATH}/mac/configure.sh
xcodebuild --install
xcodebuild -license

brew bundle install --file ${DOTFILES_PATH}/mac/Brewfile --verbose

### Git stuff ###
echo ""
echo "${info}==> Setting your profile Git...${reset}"

ln -sf ${DOTFILES_PATH}/git/.gitconfig $HOME/.gitconfig
ln -sf ${DOTFILES_PATH}/git/.gitconfig-opensource $HOME/.gitconfig-opensource
ln -sf ${DOTFILES_PATH}/git/.gitconfig-work $HOME/.gitconfig-work
ln -sf ${DOTFILES_PATH}/git/.gitignore_global $HOME/.gitignore_global
ln -sf ${DOTFILES_PATH}/git/.gitattributes $HOME/.gitattributes

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
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM}/plugins/git-open
# Themes Zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

### Langs stuff ###
# GO
curl -sSL https://git.io/g-install | sh -s -- bash

# PHP / Composer
mkdir -p $HOME/.composer
ln -sf ${DOTFILES_PATH}/langs/php/composer.json $HOME/.composer/composer.json
composer global update

# Yarn
mkdir -p $HOME/.config/yarn/global
ln -sf ${DOTFILES_PATH}/langs/yarn/package.json $HOME/.config/yarn/global/package.json
cd (yarn global dir) && yarn install

cd ~ && yarn global upgrade

### Init project ###
### Install opensource
sh ${DOTFILES_PATH}/mac/opensource.sh

### Install Certificationy
composer create-project certificationy/certificationy-cli $HOME/www/perso/certificationy-cli

# Refresh terminal
source ~/.zshrc


echo ""
echo "${success}==> Installation completed${reset}"

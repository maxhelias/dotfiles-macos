<h1 align="center">
  <code>dotfiles</code>
</h1>

<p align="center">
  <a href="install.sh">Install</a>&nbsp;&nbsp;&nbsp;
  <a href="console">Terminal</a>&nbsp;&nbsp;&nbsp;
  <a href="git/.gitconfig">Git configuration</a>&nbsp;&nbsp;&nbsp;
  <a href="mac/brew">Brew install</a>
</p>

## What's inside?
 * A [lot of custom binaries to play](bin)
 * [Aliases](bin) and [aliases](console/_aliases)
 * [Git](git/.gitconfig) configuration
 * Some [php](langs/php) configurations
 * zsh (with suggestions, autocompletion, ...)
 * macOS settings for
   - brew
   - iTerm
 * And much more!


## Install

Run this command : 

```sh
curl -s https://raw.githubusercontent.com/maxhelias/dotfiles-macos/master/install.sh | sh
```

## Usage

#### Bin
```bash
# System
empty_trash # Clear all cache
short_pwd # Display short pwd
update_apps # Update macOS / brew / brew cask / composer & npm global
```

#### Alias
```bash
# System
brew-upgrade # Update all brew package and write all information in upgrade-$( date +%F ).log file

# Move
ll # Display directory with exa
ll # Like ll with hidden
ctree # Display a tree recursive with detail
tmp # Go to /tmp folder

# Info
privateip # Display private IP
publicip # Display public IP
count # Count all file on the directory recursively withou node_modules, tests, var and vendor
weather $1 # Display the weather in $1 city

# Config
zshconfig # Edit ~/.zsh file
ohmyzsh # Edit ~/.oh-my-zsh

# Docker
dc # docker-compose
dc-rmi # Down and remove all images and volume with orphans on the projet directory
blackfire-curl # Run blackfire curl on the current project container
blackfire-run # Run balckfire run on the current project container

# Symfony
sc # Run the Security Checker on the current project
sf # Run Symfony Console on the current project
sfcl # Hard delete cache folder
sfcll # Hard delete log file on logs folder
```

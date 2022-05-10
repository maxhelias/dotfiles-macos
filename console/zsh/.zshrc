# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Dotfiles path
DOTFILES_PATH=$HOME/dotfiles

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/bin:$DOTFILES_PATH/bin:$HOME/.composer/vendor/bin:$HOME/.symfony/bin:/opt/homebrew/opt/mysql-client/bin

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Remove the user name
DEFAULT_USER="$USER"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM="$ZSH/custom"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws brew composer docker docker-compose git git-open node sudo symfony web-search yarn z zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Permet d'éviter les erreurs de timeout lorsqu'on reste sur les logs pendant trop longtemps.
export COMPOSE_HTTP_TIMEOUT=3600

source $DOTFILES_PATH/console/init.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
################
### MY ALIAS ###
################
# ZSH Config
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"

# Brew
alias brew-upgrade="brew upgrade | tee upgrade-$( date +%F ).log"

# Docker
alias dc="docker-compose"
alias dc-rmi="docker-compose down -v --rmi all --remove-orphans"
alias lzd='lazydocker'

# PHP
alias sc="security-checker security:check"

# Symfony
alias sf="php bin/console"
alias sfcl="rm -rf */cache/*"
alias sfcll="rm */logs/*.log"

# Blackfire
alias blackfire-curl="dc exec blackfire blackfire curl"
alias blackfire-run="dc exec php blackfire run"

# Navigation
alias ls="ls -G"
alias ll="ls -lG"

# Other
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias count="cloc . --exclude-dir=node_modules,test,tests,var,vendor"

# Certificationy
alias certificationy="php ~/www/project/certificationy-cli/certificationy.php"

# Automatically added by the Platform.sh CLI installer
export PATH="~/.platformsh/bin:$PATH"
if [ -f '~/.platformsh/shell-config.rc' ]; then . '~/.platformsh/shell-config.rc'; fi


#################
## MY FUNCTION ##
#################
# See the weather 
function weather() {
  if [[ ! -z "$@" ]]; then
    curl wttr.in/~$@
  fi
}

# View versions of docker tools
function docker-version() {
    docker -v && docker-machine -v && docker-compose -v
}

# Go inside one of the services managed by Docker Compose.
docker-go() {
    docker-compose exec $1 bash
}

# Copy an SSH key and automatically start the SSH agent in a container,
# it is necessary to change the name of the container also see the path to the SSH key.
docker-cp() {
    [[ -z "$2" ]] && nb=1 || nb=$2

    docker exec "${$(basename $PWD)//-/}_$1_$nb" sh -c "mkdir -p /root/.ssh" && \
    docker cp ~/.ssh/id_rsa "${$(basename $PWD)//-/}_$1_$nb":/root/.ssh/id_rsa && \
    docker cp ~/.ssh/id_rsa.pub "${$(basename $PWD)//-/}_$1_$nb":/root/.ssh/id_rsa.pub && \
    docker exec "${$(basename $PWD)//-/}_$1_$nb" sh -c "echo 'eval \$(ssh-agent) && ssh-add' >> /root/.bashrc"
}

# Allows you to visualize in real time the use of resources by the started containers.
docker-stats() {
    docker stats $(docker ps --format={{.Names}})
}

# Go to my project folder
gosites() {
    cd ~/www/$1
}

# Update permissions for a Symfony project
sfpermission() {
  chmod 0777 */cache */logs
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

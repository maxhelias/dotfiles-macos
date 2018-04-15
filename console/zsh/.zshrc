# Dotfiles path
DOTFILES_PATH=$HOME/dotfiles

# PHP with homebrew
BREW_PHP=$(brew --prefix php71)/bin

# If you come from bash you might have to change your $PATH.
export PATH=$BREW_PHP:$PATH:$HOME/bin:/usr/local/bin:$DOTFILES_PATH/bin

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

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
plugins=(aws brew composer docker docker-compose git laravel5 node react-native redis-cli sublime symfony web-search yarn zsh-completions zsh-syntax-highlighting zsh-autosuggestions zsh-iterm-touchbar)

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
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
alias dc="docker-compose"
alias grep="grep —color=auto"
alias blackfire-curl="dc exec blackfire blackfire curl"
alias blackfire-run="dc exec php blackfire run"

# Automatically added by the Platform.sh CLI installer
export PATH="~/.platformsh/bin:$PATH"
. '~/.platformsh/shell-config.rc' 2>/dev/null || true


# Function
function meteo() {
  if [[ ! -z "$@" ]]; then
    curl wttr.in/~$@
  fi
}

# Permet d'afficher les versions des outils docker
function docker-version() {
    docker -v && docker-machine -v && docker-compose -v
}

# Permet d'aller à l'intérieur d'un des services gérés par Docker Compose.
function docker-go() {
    docker-compose exec $1 bash
}

# Permet de copier une clé SSH et de démarrer automatiquement le SSH agent dans un conteneur,
# il est nécessaire de changer le nom du conteneur voir aussi le chemin vers la clé SSH. 
docker-cp() {
    [[ -z "$2" ]] && nb=1 || nb=$2

    docker exec "${$(basename $PWD)//-/}_$1_$nb" sh -c "mkdir -p /root/.ssh" && \
    docker cp ~/.ssh/id_rsa "${$(basename $PWD)//-/}_$1_$nb":/root/.ssh/id_rsa && \
    docker cp ~/.ssh/id_rsa.pub "${$(basename $PWD)//-/}_$1_$nb":/root/.ssh/id_rsa.pub && \
    docker exec "${$(basename $PWD)//-/}_$1_$nb" sh -c "echo 'eval \$(ssh-agent) && ssh-add' >> /root/.bashrc"
}

# Permet de visualiser en temps réel l'utilisation des ressources par les conteneurs démarrés.
docker-stats() {
    docker stats $(docker ps --format={{.Names}})
}

function dc-laradock() {
	cd ~/Docker/laradock && dc up -d nginx postgres-postgis redis
}

function dc-laradock-build() {
	cd ~/Docker/laradock && dc build nginx postgres-postgis redis
}

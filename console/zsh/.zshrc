# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

################
#### GLOBAL ####
################
# Dotfiles path
export DOTFILES_PATH=$HOME/dotfiles

# Register all exports
for exportToSource in $DOTFILES_PATH/console/_exports/*; do source $exportToSource; done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fuck
# https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


################
# USER SETTING #
################
# Theme
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Username
DEFAULT_USER="$USER"

# Auto update
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws brew composer docker docker-compose git git-open node sudo symfony web-search yarn z zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

################
### MY ALIAS ###
################
alias c="clear"
alias q="exit"

# ZSH Config
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
# source ~/.zshrc
alias sc="source $HOME/.zshrc"

# Brew
alias brew-upgrade="brew upgrade | tee upgrade-$( date +%F ).log"

# Docker
alias dc="docker compose"
alias dc-rmi="docker compose down -v --rmi all --remove-orphans"

# Symfony
alias sf="php bin/console"
alias sfcl="rm -rf */cache/*"
alias sfcll="rm */logs/*.log"

# Blackfire
alias blackfire-curl="dc exec blackfire blackfire curl"
alias blackfire-run="dc exec php blackfire run"

alias ggo="$GOPATH/bin/g";

# Other
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias count="cloc . --exclude-dir=node_modules,test,tests,var,vendor"

# Certificationy
alias certificationy="php ~/www/perso/certificationy-cli/certificationy.php --training"

# Register all aliases
for aliasToSource in $DOTFILES_PATH/console/_aliases/*; do source $aliasToSource; done

#################
### FUNCTION  ###
#################
# See the weather
weather() {
  if [[ ! -z "$@" ]]; then
    curl wttr.in/~$@
  fi
}

# View versions of docker tools
docker-version() {
    docker -v && docker-compose -v
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

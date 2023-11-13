# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Zsh Custom
export ZSH_CUSTOM="$ZSH/custom"

# Extend PATH
export PATH=$PATH:$HOME/bin:$DOTFILES_PATH/bin:$HOME/.composer/vendor/bin:$HOME/.symfony/bin

# FZF
export FZF_DEFAULT_OPTS='--layout=reverse --ansi'
# FD
export FZF_DEFAULT_COMMAND='fd --type file --color=always --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Docker Compose
# Permet d'éviter les erreurs de timeout lorsqu'on reste sur les logs pendant trop longtemps.
export COMPOSE_HTTP_TIMEOUT=3600

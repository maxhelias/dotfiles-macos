export DOTFILES_PATH=$HOME/dotfiles

# Register all exports
for exportToSource in $DOTFILES_PATH/console/_exports/*; do source $exportToSource; done

# Register all aliases
for aliasToSource in $DOTFILES_PATH/console/_aliases/*; do source $aliasToSource; done

# fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

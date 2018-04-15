# Register all aliases
for aliasToSource in $DOTFILES_PATH/console/_aliases/*; do source $aliasToSource; done
# Register all exports
for exportToSource in $DOTFILES_PATH/console/_exports/*; do source $exportToSource; done
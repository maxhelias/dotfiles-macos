# https://github.com/junegunn/fzf
alias fzf-preview='fzf --preview "bat --color=always --style=numbers --line-range=:80 {}"'
alias fzf-gc='git checkout $(git branch | fzf)'

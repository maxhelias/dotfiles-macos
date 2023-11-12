alias ls='exa -lh --octal-permissions --icons'
alias ll='exa -lha --octal-permissions --icons'
alias ctree='exa -T -l'

# Jumps
alias tmp='cd /tmp'

# PATH
alias mypath='echo -e ${PATH//:/\\n} | sort --unique'

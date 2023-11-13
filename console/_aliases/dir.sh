alias ls='eza -lh --octal-permissions --icons'
alias ll='eza -lha --octal-permissions --icons'
alias tree='eza -T -l --icons'

# Jumps
alias tmp='cd /tmp'

# PATH
alias mypath='echo -e ${PATH//:/\\n} | sort --unique'

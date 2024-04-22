## Basic
alias mv='mv -i'
alias cp='cp -i'

## Spec
mkcd(){
    mkdir $1 && cd $1
}

alias ls='eza -lh --octal-permissions --icons'
alias ll='eza -lha --octal-permissions --icons'
alias tree='eza -T -l --icons'

# Jumps
alias tmp='cd /tmp'

# PATH
alias mypath='echo -e ${PATH//:/\\n} | sort --unique'

# Disk Usage
alias du='du -sh'
alias dusort='du -sh * | sort -hr'
# https://github.com/sharkdp/bat
alias cat='bat --style="header" --paging=never'

batdiff() {
  git diff --name-only --relative --diff-filter=d | xargs bat --diff
}


fpath+=("$(brew --prefix)/share/zsh/site-functions")

PROMPT='%2~ %(?.%F{14}❯.%F{9}❯)%f '
RPROMPT='%F{8} %*%f'

autoload -U compinit; compinit
_comp_options+=(globdots)

setopt always_to_end
setopt hist_ignore_all_dups
setopt login
setopt complete_in_word
setopt always_to_end

source $ZDOTDIR/.zsh_aliases

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

. "$HOME/.local/bin/env"

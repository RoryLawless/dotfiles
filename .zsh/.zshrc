
fpath+=("$(brew --prefix)/share/zsh/site-functions"
			"$ZDOTDIR/.zshfn/")

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

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

. "$HOME/.local/bin/env"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/rory/.opam/opam-init/init.zsh' ]] || source '/Users/rory/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration


fpath+=("$(brew --prefix)/share/zsh/site-functions"
		"$ZDOTDIR/.zshfn/")

autoload -Uz updateR

autoload -U promptinit; promptinit
prompt pure

autoload -U compinit; compinit
_comp_options+=(globdots)

setopt always_to_end
setopt hist_ignore_all_dups
setopt login
setopt complete_in_word
setopt always_to_end

source $ZDOTDIR/.zsh_aliases
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=completion

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor)

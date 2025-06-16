
if [[ $(uname) == "Darwin" ]] ; then

	fpath+=("$(brew --prefix)/share/zsh/site-functions"
			"$ZDOTDIR/.zshfn/")
		
elif [[ $(uname) == "Linux" ]] ; then

	fpath+=("$ZDOTDIR/pure/"
			"$ZDOTDIR/.zshfn/")

fi

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

ZSH_AUTOSUGGEST_STRATEGY=completion
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor)

if [[ $(uname) == "Darwin" ]] ; then

	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

elif [[ $(uname) == "Linux" ]] ; then

	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fi


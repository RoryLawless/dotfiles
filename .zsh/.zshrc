

fpath+=("$(brew --prefix)/share/zsh/site-functions"
		"$ZDOTDIR/.zshfn/")

autoload -Uz updateR

autoload -U promptinit; promptinit
prompt pure

autoload -U compinit; compinit

_comp_options+=(globdots)

source $ZDOTDIR/.zsh_aliases

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

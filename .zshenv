#!/usr/bin/env zsh

if [[ $(uname) == "Darwin" ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
	export PATH="/opt/homebrew/sbin:$PATH"
fi

export EDITOR="micro"
export ZDOTDIR="$HOME/.zsh"

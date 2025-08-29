#!/usr/bin/env zsh

if [[ $(uname) == "Darwin" ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
	export PATH="/opt/homebrew/sbin:$PATH"
fi

export EDITOR="emacs"
export ZDOTDIR="$HOME/.zsh"
export BORG_REPO="op://Private/borg/username"
export BORG_REMOTE_PATH=borg14
export BORG_PASSPHRASE="op://Private/borg/password"
export OPENAI_API_KEY="op://Private/OpenAI API Key/api key"

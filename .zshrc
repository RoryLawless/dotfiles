
# Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

_comp_options+=(globdots)

# Setup git prompt

source "$(brew --prefix git)/etc/bash_completion.d/git-prompt.sh"

function custom_prompts () {
    RPS1='$(__git_ps1 "%s") %F{8}%T%f'
    PS1='%2~ %(?.%F{green}❯.%F{red}❯)%f '
}

precmd_functions+=(custom_prompts)

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=(verbose git)
export GIT_PS1_SHOWCOLORHINTS=true

setopt PROMPT_SUBST

# Environment vars for defaults
export EDITOR="emacs"
export VISUAL="$EDITOR"
export GPG_TTY=$(tty)

# Aliases
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME/'
alias ls='eza --long --header --icons=never'
alias python='python3'
alias rmrf='rm -rf'
alias updateR='Rscript -e "update.packages(repos = c(CRAN = \"https://packagemanager.posit.co/cran/latest\", MV = \"https://community.r-multiverse.org\", STAN = \"https://stan-dev.r-universe.dev\", MM = \"https://milesmcbain.r-universe.dev\", DT = \"https://rdatatable.r-universe.dev\"), ask = FALSE)"'
alias update='brew update && brew upgrade --yes --force --greedy && brew cleanup --prune=3'
alias positron='open /Applications/Positron.app'
alias cat='bat'

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/rory/.opam/opam-init/init.zsh' ]] || source '/Users/rory/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# Extensions

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Mole shell completion
if output="$(mole completion zsh 2>/dev/null)"; then eval "$output"; fi

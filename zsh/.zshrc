eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export POETRY_CONFIG_DIR=~/.config/pypoetry
export POETRY_DATA_DIR=~/.local/share/pypoetry
export POETRY_CACHE_DIR=~/.cache/pypoetry

export EDITOR=code

#alias la=tree
alias cat=bat

# Dirs
alias la="ls -la"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cl='clear'

# Add Cloud SDK to PATH
if [ -f "${HOME}/.local/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/.local/google-cloud-sdk/path.zsh.inc"; fi
# Add Cloud SDK completions
if [ -f "${HOME}/.local/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/.local/google-cloud-sdk/completion.zsh.inc"; fi

#Add ML Tool
if [ -d "${HOME}/.config/fury/" ]; then source ~/.config/fury/setup; fi

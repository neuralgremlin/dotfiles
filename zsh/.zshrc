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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/.local/google-cloud-sdk/path.zsh.inc' ]; then . '~/.local/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '~/.local/google-cloud-sdk/completion.zsh.inc' ]; then . '~/.local/google-cloud-sdk/completion.zsh.inc'; fi

# Add Fury to PATH
if [ -d '~/.config/fury/' ]; then . '~/.config/fury/setup'; fi 

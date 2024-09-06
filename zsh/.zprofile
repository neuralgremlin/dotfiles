
eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(/etc/profiles/per-user/$(whoami)/bin/mise activate zsh)"

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

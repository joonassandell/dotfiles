# ======
# Defaults
# ======
#
# Template found here https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
#

# Add '~/bin' to the '$PATH'
export PATH="$HOME/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh


# ======
# User Configuration
# ======

# Aliases
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias db='cd ~/Dropbox/'
alias git-log='git log --oneline --decorate --all --graph'
alias hosts='sudo $EDITOR /etc/hosts'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ls='ls -aFhlG'
alias repo='cd ~/Repositories/'
alias simulator='open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
alias simple-server='python -m SimpleHTTPServer'
alias npm-upgrade='ncu -u && npm install'
alias npm-reinstall='sudo rm -rf node_modules/ && npm install'

# Load additional dotfiles from Dropbox
source ~/Dropbox/Apps/macOS/.zshrc.secret

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# https://github.com/creationix/nvm#zsh
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Docker
# https://github.com/docker/compose/issues/5696
export COMPOSE_INTERACTIVE_NO_CLI=1

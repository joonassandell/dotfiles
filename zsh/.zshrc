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
alias yarn-reinstall='sudo rm -rf node_modules/ && yarn'

# Load additional dotfiles from Dropbox
source ~/Dropbox/Apps/macOS/.zshrc.secret

# Node version manager
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# Docker
# https://github.com/docker/compose/issues/5696
export COMPOSE_INTERACTIVE_NO_CLI=1

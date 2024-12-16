#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

info "Installing Brewfile packages..."
brew bundle
success "Finished installing Brewfile packages"

info "Installing node packages..."
mkdir -p $HOME/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
nvm install 14.16.0
nvm install --lts
nvm install node
nvm alias default 'lts/*'
success "Finished installing node packages"

#! /usr/bin/env sh

echo "$DIR"
DIR=$(dirname "$0")
cd "$DIR"
echo "$DIR"

. ../scripts/functions.sh

sudo -v

info "Installing Brewfile packages..."
brew bundle
success "Finished installing Brewfile packages."

info "Preinstalling node packages..."
mkdir -p $HOME/.nvm
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
nvm install 14.16.0
nvm install --lts
nvm install node
nvm alias default node
info "Finished preinstalling node packages."
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

info "Installing VS Code extensions..."
code --install-extension shan.code-settings-sync
success "Finished installing VS Code extensions."

info "Preinstalling node packages..."
mkdir -p $HOME/.nvm
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
nvm install 12
nvm install node
nvm alias default node
info "Finished preinstalling node packages."

info "Installing packages from the App Store..."
mas install 417375580 # BetterSnapTool
success "Finished installing packages from the App Store."

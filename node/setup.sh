#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Node..."

# nvm is installed by packages/Brewfile
mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
nvm install --lts
nvm install node
nvm alias default 'lts/*'

# For programs that don't load .zshrc
mkdir -p "$DESTINATION/.local/bin"
symlink "$SOURCE/node" "$DESTINATION/.local/bin/node"

success "Finished configuring Node"

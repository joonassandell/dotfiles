#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

sudo -v

info "Installing Brewfile packages..."
brew bundle
success "Finished installing Brewfile packages"

# To install App Store apps with mas, add `brew 'mas'` to the Brewfile and
# uncomment the lines below.
# info "Installing packages from the App Store..."
# mas install 1494023538 # Plash (https://apps.apple.com/us/app/plash/id1494023538)
# mas install 497799835 # Xcode (https://apps.apple.com/us/app/xcode/id497799835)
# success "Finished installing packages from the App Store."

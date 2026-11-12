#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

# Ask for the administrator password upfront and update the `sudo` timestamp
# until this script has finished
info "Prompting for sudo password..."
if sudo -v; then
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated"
else
    error "Failed to obtain sudo credentials"
fi

# Execute package control
./packages/setup.sh

# Run other individual setup scripts
find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
    ./$setup
done

success_final "Finished installing dotfiles!"

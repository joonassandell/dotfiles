#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring VS Code..."

symlink "$SOURCE/keybindings.json" "$DESTINATION/Library/Application Support/Code/User/keybindings.json"
symlink "$SOURCE/settings.json" "$DESTINATION/Library/Application Support/Code/User/settings.json"
symlink "$SOURCE/snippets" "$DESTINATION/Library/Application Support/Code/User/snippets"

./extensions.sh

success "Finished configuring VS Code"

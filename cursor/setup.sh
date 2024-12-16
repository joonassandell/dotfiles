#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring cursor..."

symlink "$SOURCE/keybindings.json" "$DESTINATION/Library/Application Support/Cursor/User/keybindings.json"
symlink "$SOURCE/settings.json" "$DESTINATION/Library/Application Support/Cursor/User/settings.json"
symlink "$SOURCE/snippets" "$DESTINATION/Library/Application Support/Cursor/User/snippets"

success "Finished configuring cursor"

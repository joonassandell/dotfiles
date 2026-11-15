#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Herdr app..."

# The app writes its own files into this folder, so link only mine
mkdir -p "$DESTINATION/.config/herdr-app/themes"
symlink "$SOURCE/settings.json" "$DESTINATION/.config/herdr-app/settings.json"
symlink "$SOURCE/keys.json" "$DESTINATION/.config/herdr-app/keys.json"
symlink "$SOURCE/themes/tokyo-night.json" "$DESTINATION/.config/herdr-app/themes/tokyo-night.json"

success "Finished configuring Herdr app"

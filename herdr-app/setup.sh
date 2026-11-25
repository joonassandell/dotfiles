#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Herdr app..."

# The app writes its own files into this folder, so link only essentials
mkdir -p "$DESTINATION/.config/herdr-app/themes"
symlink "$SOURCE/settings.json" "$DESTINATION/.config/herdr-app/settings.json"
symlink "$SOURCE/keys.json" "$DESTINATION/.config/herdr-app/keys.json"
symlink "$SOURCE/themes/tokyo-night.json" "$DESTINATION/.config/herdr-app/themes/tokyo-night.json"
symlink "$SOURCE/themes/joonassandell-slate.json" "$DESTINATION/.config/herdr-app/themes/joonassandell-slate.json"
symlink "$SOURCE/themes/joonassandell.json" "$DESTINATION/.config/herdr-app/themes/joonassandell.json"

# Layout and mods
mkdir -p "$DESTINATION/.config/herdr-app/layouts" "$DESTINATION/.config/herdr-app/mods"
symlink "$SOURCE/layouts/joonassandell.json" "$DESTINATION/.config/herdr-app/layouts/joonassandell.json"
symlink "$SOURCE/mods/joonassandell-spaces" "$DESTINATION/.config/herdr-app/mods/joonassandell-spaces"
symlink "$SOURCE/mods/joonassandell-status" "$DESTINATION/.config/herdr-app/mods/joonassandell-status"
symlink "$SOURCE/joonassandell-spaces-avatars.json" "$DESTINATION/.config/herdr-app/joonassandell-spaces-avatars.json"

success "Finished configuring Herdr app"

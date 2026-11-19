#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Starship..."

mkdir -p "$DESTINATION/.config"
symlink "$SOURCE/starship.toml" "$DESTINATION/.config/starship.toml"

success "Finished configuring Starship"

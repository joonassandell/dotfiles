#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Warp..."

mkdir -p "$DESTINATION/.warp"
symlink "$SOURCE/keybindings.yaml" "$DESTINATION/.warp/keybindings.yaml"
symlink "$SOURCE/settings.toml" "$DESTINATION/.warp/settings.toml"

success "Finished configuring Warp"

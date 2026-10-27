#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Ghostty..."

mkdir -p "$DESTINATION/Library/Application Support/com.mitchellh.ghostty"
symlink "$SOURCE/config.ghostty" "$DESTINATION/Library/Application Support/com.mitchellh.ghostty/config.ghostty"

success "Finished configuring Ghostty"

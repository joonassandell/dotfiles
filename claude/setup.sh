#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Claude Code..."

# Settings. Link the file itself, one hop: Claude Code saves through a single symlink (for example `/advisor` or `/model` saving a default), but not through a chain of them.
mkdir -p "$DESTINATION/.claude"
symlink "$SOURCE/settings.json" "$DESTINATION/.claude/settings.json"

# Own theme. Link the file, not the folder: Claude Code may add other themes there.
# Select it with `/theme`, or set "theme": "custom:joonassandell" in settings.json.
mkdir -p "$DESTINATION/.claude/themes"
symlink "$SOURCE/themes/joonassandell.json" "$DESTINATION/.claude/themes/joonassandell.json"

success "Finished configuring Claude Code"

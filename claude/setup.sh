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

# Expect's browser tools for the expect skill (skills/skills.txt): https://github.com/millionco/expect
if command -v claude &> /dev/null && ! claude mcp get expect &> /dev/null; then
  claude mcp add --scope user expect -- npx -y expect-cli@latest mcp > /dev/null && substep_success "Added the expect MCP server"
fi

success "Finished configuring Claude Code"

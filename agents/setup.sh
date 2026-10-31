#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring agents..."

mkdir -p "$DESTINATION/.agents/skills" "$DESTINATION/.claude/skills" "$DESTINATION/.codex"

# Global rules: `~/.agents/AGENTS.md` is the single source for Claude Code and Codex
symlink "$SOURCE/AGENTS.md" "$DESTINATION/.agents/AGENTS.md"
symlink "$DESTINATION/.agents/AGENTS.md" "$DESTINATION/.claude/CLAUDE.md"
symlink "$DESTINATION/.agents/AGENTS.md" "$DESTINATION/.codex/AGENTS.md"

# Repo to text project map. It lives in the synced Projects folder, so link it only once the sync has delivered it
PROJECTS_MAP="$DESTINATION/Joonas Sandell/Projects/PROJECTS.md"
if [ -f "$PROJECTS_MAP" ]; then
    symlink "$PROJECTS_MAP" "$DESTINATION/.agents/PROJECTS.md"
else
    info "Projects map not found yet. Re-run this script after the Projects sync finishes"
fi

# Own skills. Skills installed with `skills add` are handled in `skills/setup.sh`
for skill in "$SOURCE"/skills/*/; do
    name=$(basename "$skill")
    symlink "$SOURCE/skills/$name" "$DESTINATION/.agents/skills/$name"
    symlink "$DESTINATION/.agents/skills/$name" "$DESTINATION/.claude/skills/$name"
done

success "Finished configuring agents"

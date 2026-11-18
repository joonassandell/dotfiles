#!/bin/sh
# Claude Code SessionStart hook: put the caveman skill rules into the session's context.
# Reads ~/.agents/skills/caveman/SKILL.md at session start (so skill edits apply at once),
# drops its YAML front matter and prints the rest. Prints nothing if the file is missing.

SKILL="$HOME/.agents/skills/caveman/SKILL.md"
[ -f "$SKILL" ] || exit 0

echo "Caveman mode is on for this session, until the user says \"stop caveman\" or \"normal mode\". Follow these rules:"
echo
awk 'BEGIN { fm = 0 } /^---[[:space:]]*$/ && fm < 2 { fm++; next } fm >= 2 { print }' "$SKILL"

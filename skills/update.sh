#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SKILLS_FILE="skills.txt"
LOCK_FILE="$HOME/.agents/.skill-lock.json"

if ! command -v bun &> /dev/null; then
  error "Could not find bun command. Install packages first."
  exit 1
fi

info "Updating agent skills..."
if bunx skills update --global --yes > /dev/null; then
  substep_success "Updated installed skills"
else
  substep_error "Failed to update installed skills"
fi
success "Finished updating agent skills"

if [ ! -f "$LOCK_FILE" ]; then
  error "Could not find $LOCK_FILE."
  exit 1
fi

info "Updating agent skills list..."

touch "$SKILLS_FILE"

# Print installed skills from the lock file as `<source> <skill>` lines
INSTALLED_SKILLS=$(bun -e "
  const { skills } = require('$LOCK_FILE')
  for (const [name, { source }] of Object.entries(skills)) console.log(source, name)
")

while read -r source skill; do
  if ! grep -q " $skill$" "$SKILLS_FILE"; then
    echo "$source $skill" >> "$SKILLS_FILE"
    substep_success "Added $skill"
  fi
done <<< "$INSTALLED_SKILLS"

# Skills in the list that are not installed are kept, only reported
while read -r source skill || [ -n "$source" ]; do
  [[ -z "$source" || "$source" == \#* ]] && continue
  grep -q " $skill$" <<< "$INSTALLED_SKILLS" || substep_info "$skill not installed"
done < "$SKILLS_FILE"

LC_ALL=C sort -u -o "$SKILLS_FILE" "$SKILLS_FILE"

success "Finished updating agent skills list"

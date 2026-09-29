#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SKILLS_FILE="skills.txt"
LOCK_FILE="$HOME/.agents/.skill-lock.json"
AGENT="claude-code"

if ! command -v bun &> /dev/null; then
  error "Could not find bun command. Install packages first."
  exit 1
fi

info "Installing agent skills..."

INSTALLED_SKILLS=""
if [ -f "$LOCK_FILE" ]; then
  INSTALLED_SKILLS=$(bun -e "console.log(Object.keys(require('$LOCK_FILE').skills).join('\n'))")
fi

# Each line: <source> <skill>, e.g. `vercel-labs/skills find-skills`
while read -r source skill || [ -n "$source" ]; do
  [[ -z "$source" || "$source" == \#* ]] && continue

  if grep -qxF "$skill" <<< "$INSTALLED_SKILLS"; then
    substep_info "$skill already installed"
    continue
  fi

  if bunx skills add "$source" --skill "$skill" --global --yes --agent "$AGENT" > /dev/null; then
    substep_success "Installed $skill"
  else
    substep_error "Failed to install $skill"
  fi
done < "$SKILLS_FILE"

success "Finished installing agent skills"

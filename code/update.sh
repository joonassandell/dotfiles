#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

EXTENSIONS_FILE="extensions.txt"

if ! command -v code &> /dev/null; then
  error "Could not find code command. Install VS Code and add code to PATH."
  exit 1
fi

info "Updating VS Code extensions list..."

INSTALLED_EXTENSIONS=$(code --list-extensions | tr '[:upper:]' '[:lower:]')

for extension in $INSTALLED_EXTENSIONS; do
  if ! grep -qixF "$extension" "$EXTENSIONS_FILE"; then
    echo "$extension" >> "$EXTENSIONS_FILE"
    substep_success "Added $extension"
  fi
done

# Extensions in the list that are not installed are kept, only reported
while read -r extension || [ -n "$extension" ]; do
  [[ -z "$extension" || "$extension" == \#* ]] && continue
  grep -qixF "$extension" <<< "$INSTALLED_EXTENSIONS" || substep_info "$extension not installed"
done < "$EXTENSIONS_FILE"

LC_ALL=C sort -u -o "$EXTENSIONS_FILE" "$EXTENSIONS_FILE"

success "Finished updating VS Code extensions list"

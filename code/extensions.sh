#!/bin/bash
# https://github.com/rmmgc/vscode-extensions-bulk-install/tree/main

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

EXTENSIONS_FILE="${1:-extensions.txt}"

if ! command -v code &> /dev/null; then
  error "Could not find code command. Install VS Code and add code to PATH."
  exit 1
fi

if [ ! -f "$EXTENSIONS_FILE" ]; then
  error "Could not find $EXTENSIONS_FILE."
  exit 1
fi

if [[ "$EXTENSIONS_FILE" != *.txt ]]; then
  error "$EXTENSIONS_FILE must be a .txt file."
  exit 1
fi

info "Installing VS Code extensions..."

INSTALLED_EXTENSIONS=$(code --list-extensions)

while read -r extension || [ -n "$extension" ]; do
  [[ -z "$extension" || "$extension" == \#* ]] && continue

  if grep -qixF "$extension" <<< "$INSTALLED_EXTENSIONS"; then
    substep_info "$extension already installed"
    continue
  fi

  if code --install-extension "$extension" > /dev/null; then
    substep_success "Installed $extension"
  else
    substep_error "Failed to install $extension"
  fi
done < "$EXTENSIONS_FILE"

success "Finished installing VS Code extensions"

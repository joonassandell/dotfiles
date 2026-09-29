#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

BREWFILE="Brewfile"

# Print names of given type from Brewfile, e.g. `entries brew`
entries() {
  sed -n "s/^$1 '\([^']*\)'.*/\1/p" "$BREWFILE"
}

# Check if name exists in list, comparing without tap prefix (oven-sh/bun/bun → bun)
contains() {
  sed 's|.*/||' <<< "$2" | grep -qxF "${1##*/}"
}

info "Updating Brewfile..."

TAPS=$(entries tap)
BREWS=$(entries brew)
CASKS=$(entries cask)
OTHER=$(grep -vE "^(tap|brew|cask) '|^$" "$BREWFILE")

for tap in $(brew tap | grep -v "^homebrew/"); do
  if ! grep -qxF "$tap" <<< "$TAPS"; then
    TAPS=$(printf "%s\n%s" "$TAPS" "$tap")
    substep_success "Added tap $tap"
  fi
done

for formula in $(brew leaves --installed-on-request); do
  if ! contains "$formula" "$BREWS"; then
    BREWS=$(printf "%s\n%s" "$BREWS" "$formula")
    substep_success "Added brew $formula"
  fi
done

for cask in $(brew list --cask -1); do
  if ! contains "$cask" "$CASKS"; then
    CASKS=$(printf "%s\n%s" "$CASKS" "$cask")
    substep_success "Added cask $cask"
  fi
done

# Entries in Brewfile that are not installed on this machine are kept, only reported
INSTALLED_FORMULAE=$(brew list --formula -1)
INSTALLED_CASKS=$(brew list --cask -1)
for formula in $BREWS; do
  contains "$formula" "$INSTALLED_FORMULAE" || substep_info "brew $formula not installed"
done
for cask in $CASKS; do
  contains "$cask" "$INSTALLED_CASKS" || substep_info "cask $cask not installed"
done

section() {
  sed '/^$/d' <<< "$2" | LC_ALL=C sort -u | sed "s/.*/$1 '&'/"
}

{
  [ -n "$OTHER" ] && printf "%s\n\n" "$OTHER"
  section tap "$TAPS"; echo
  section brew "$BREWS"; echo
  section cask "$CASKS"
} > "$BREWFILE"

success "Finished updating Brewfile"

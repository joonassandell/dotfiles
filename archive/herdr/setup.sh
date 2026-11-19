#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Herdr..."

mkdir -p "$DESTINATION/.config/herdr"
symlink "$SOURCE/config.toml" "$DESTINATION/.config/herdr/config.toml"

# The Hermes plugin needs the Hermes home, which exists after Hermes has run or
# a backup has been imported (`hermes import <backup.zip>`)
if [ -d "$DESTINATION/.hermes" ]; then
    herdr integration install hermes &>/dev/null \
        && substep_success "Installed Herdr integration for Hermes" \
        || substep_error "Failed to install Herdr integration for Hermes"
else
    substep_info "Skipped Hermes integration, run \`herdr integration install hermes\` after setting up Hermes"
fi

success "Finished configuring Herdr"

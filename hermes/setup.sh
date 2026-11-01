#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Hermes..."

# The Hermes home exists after Hermes has run or a backup has been imported
# (`hermes import <backup.zip>`)
if [ -d "$DESTINATION/.hermes" ]; then
    mkdir -p "$DESTINATION/.hermes/hooks"
    symlink "$SOURCE/hooks/webui-restart" "$DESTINATION/.hermes/hooks/webui-restart"

    # Own Desktop/CLI skin. Link the file, not the folder: Hermes may add other skins there
    mkdir -p "$DESTINATION/.hermes/skins"
    symlink "$SOURCE/skins/joonassandell.yaml" "$DESTINATION/.hermes/skins/joonassandell.yaml"

    # The dashboard service is loaded separately, see the README
    mkdir -p "$DESTINATION/Library/LaunchAgents"
    symlink "$SOURCE/launchd/ai.hermes.dashboard.plist" "$DESTINATION/Library/LaunchAgents/ai.hermes.dashboard.plist"
else
    substep_info "Skipped Hermes hooks, run \`hermes/setup.sh\` again after setting up Hermes"
fi

success "Finished configuring Hermes"

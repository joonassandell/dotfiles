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
    # Optional, restarts the WebUI with the gateway (see the README). Uncomment to use:
    # mkdir -p "$DESTINATION/.hermes/hooks"
    # symlink "$SOURCE/hooks/webui-restart" "$DESTINATION/.hermes/hooks/webui-restart"

    # Own Desktop/CLI skin. Link the file, not the folder: Hermes may add other skins there
    mkdir -p "$DESTINATION/.hermes/skins"
    symlink "$SOURCE/skins/joonassandell.yaml" "$DESTINATION/.hermes/skins/joonassandell.yaml"
    symlink "$SOURCE/skins/joonassandell-slate.yaml" "$DESTINATION/.hermes/skins/joonassandell-slate.yaml"

    # The dashboard service is loaded separately, see the README
    mkdir -p "$DESTINATION/Library/LaunchAgents"
    symlink "$SOURCE/launchd/ai.hermes.dashboard.plist" "$DESTINATION/Library/LaunchAgents/ai.hermes.dashboard.plist"

    # Expect's browser tools for the expect skill (skills/skills.txt): https://github.com/millionco/expect
    if command -v hermes &> /dev/null && ! hermes mcp list 2>/dev/null | grep -q "^  expect "; then
        echo y | hermes mcp add expect --command npx --args -y expect-cli@latest mcp > /dev/null && substep_success "Added the expect MCP server"
        # Stop it after 10 idle minutes; the next tool call starts it again
        hermes config set mcp_servers.expect.lazy true > /dev/null
        hermes config set mcp_servers.expect.idle_timeout_seconds 600 > /dev/null
    fi
else
    substep_info "Skipped Hermes hooks, run \`hermes/setup.sh\` again after setting up Hermes"
fi

success "Finished configuring Hermes"

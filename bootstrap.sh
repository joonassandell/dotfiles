#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

# Ask for the administrator password upfront and
# update the `sudo` timestamp until this script finished
info "Prompting for sudo password..."
if sudo -v; then
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated"
    info "Prepare to prompt your password again as it maybe required"
else
    error "Failed to obtain sudo credentials"
fi

# Install XCode Command Line Tools
info "Installing XCode Command Line Tools..."
if xcode-select --print-path &>/dev/null; then
    success "XCode Command Line Tools already installed"
elif xcode-select --install &>/dev/null; then
    success "Finished installing XCode Command Line Tools"
else
    error "Failed to install XCode Command Line Tools"
fi

# Execute package control
./packages/setup.sh

# Run other individual setup scripts
find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
    ./$setup
done

success "Finished installing dotfiles"

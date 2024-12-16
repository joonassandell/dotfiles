#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring zsh..."

symlink "$SOURCE/.zshrc" "$DESTINATION/.zshrc"

set_zsh() {
    if grep --quiet zsh <<< "$SHELL"; then
        substep_success "Zsh is already configured"
    else
        substep_info "Adding zsh executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet "/usr/local/bin/zsh" /etc/shells; then
            substep_success "Zsh executable already exists in /etc/shells"
        else
            if sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"; then
                substep_success "Zsh executable added sto /etc/shells"
            else
                substep_error "Failed adding zsh executable to /etc/shells"
                return 1
            fi
        fi
        substep_info "Changing shell to zsh"
        if sudo chsh -s /usr/local/bin/zsh; then
            substep_success "Changed shell to zsh"
        else
            substep_error "Failed changing shell to zsh"
            return 2
        fi
    fi
}

if set_zsh; then
    success "Successfully configured zsh"
else
    error "Failed to configure zsh"
fi

info "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --keep-zshrc
success "Finished installing oh-my-zsh"

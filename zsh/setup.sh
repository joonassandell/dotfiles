#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting up zsh..."

substep_info "Symlinking .zshrc"
symlink "$SOURCE/.zshrc" "$DESTINATION/.zshrc"

set_zsh() {
    if grep --quiet zsh <<< "$SHELL"; then
        success "Zsh is already set up."
    else
        substep_info "Adding zsh executable to /etc/shells."
        if grep --fixed-strings --line-regexp --quiet "/usr/local/bin/zsh" /etc/shells; then
            substep_success "Zsh executable already exists in /etc/shells."
        else
            if sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"; then
                substep_success "Zsh executable added sto /etc/shells."
            else
                substep_error "Failed adding zsh executable to /etc/shells."
                return 1
            fi
        fi
        substep_info "Changing shell to zsh."
        if sudo chsh -s /usr/local/bin/zsh; then 
            substep_success "Changed shell to zsh."
        else
            substep_error "Failed changing shell to zsh."
            return 2
        fi
    fi
}

if set_zsh; then
    success "Successfully set up zsh."
else
    error "Failed to set up zsh."
fi

info "Setting up oh-my-zsh."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --keep-zshrc
success "Successfully set up oh-my-zsh"

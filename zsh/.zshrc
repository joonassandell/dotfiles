# =======================================
# Zsh config
# =======================================
#
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

# Add '~/bin' to the '$PATH'
export PATH="$HOME/bin:$PATH"

# Add '~/.local/bin' to the '$PATH', e.g. Hermes Agent
export PATH="$HOME/.local/bin:$PATH"

# Add the global Flutter SDK to the '$PATH' (set with 'fvm global <version>')
export PATH="$HOME/fvm/default/bin:$PATH"

# Add the Android SDK platform-tools (adb) to the '$PATH'
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# Plugins
plugins=(
  docker
  git
  ssh-agent
  zsh-shift-select
)

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Path to your Oh My Zsh installation
source $ZSH/oh-my-zsh.sh

# =======================================
# User config
# =======================================

source ~/Joonas\ Sandell/Apps/macOS/.private.zshrc
source ~/Repositories/dotfiles/zsh/aliases.zsh
source ~/Repositories/dotfiles/zsh/ios-android-capture/index.zsh
source ~/Repositories/dotfiles/zsh/npm-bun.zsh
source ~/Repositories/dotfiles/zsh/hermes.zsh
source ~/Repositories/dotfiles/zsh/herdr-app.zsh
source ~/Repositories/dotfiles/zsh/functions.zsh
source ~/Repositories/dotfiles/zsh/keybindings.zsh
source ~/Repositories/dotfiles/zsh/nvm.zsh

# https://www.docker.com
export COMPOSE_INTERACTIVE_NO_CLI=1 # https://github.com/docker/compose/issues/5696

# Bun completions
[ -s "/Users/joonassandell/.bun/_bun" ] && source "/Users/joonassandell/.bun/_bun"

# https://starship.rs
eval "$(starship init zsh)"

# An empty line before every prompt but the first, so a new or cleared terminal
# starts at the top (starship's add_newline is off)
_prompt_spacing() { (( _prompt_spaced )) && print; _prompt_spaced=1; }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_spacing
clear() { command clear "$@"; _prompt_spaced=0; }

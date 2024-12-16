# =======================================
# Zsh config
# =======================================
#
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

# Skip the verification of oh-my-zsh insecure directories
ZSH_DISABLE_COMPFIX="true"

# Add '~/bin' to the '$PATH'
export PATH="$HOME/bin:$PATH"

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  docker
  git
  ssh-agent
)

source $ZSH/oh-my-zsh.sh

# =======================================
# User config
# =======================================

# Load additional dotfiles from NAS
source ~/Joonas\ Sandell/Apps/macOS/.zshrc.secret

# Various aliases
alias cat="bat"
alias csv-json="mlr --icsv --ojson tail" # Add -n2 to limit lines
alias csv-table="mlr --icsv --opprint cat"
alias dotfiles="cursor ~/Repositories/dotfiles"
alias git-log="git log --oneline --decorate --all --graph"
alias headers="httpstat"
alias hosts="sudo cursor /etc/hosts"
alias hw-info="networksetup -listallhardwareports"
alias ip-local="ifconfig | grep broadcast"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias kill-port-3000="bunx kill-port 3000"
alias ls="ls -aFhlG"
alias matrix="bunx matrix-rain"
alias preview="fzf --preview 'bat --color=always {}'"
alias reload="clear && reset && source ~/.zshrc" # Run CMD+K to remove Wrap history
alias repo="cd ~/Repositories/"
alias search="rg -i"
alias show-ssh-keys="ssh-add -l"
alias simple-server="python -m SimpleHTTPServer"
alias simulator="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias top="bunx vtop"
alias zsh-open-secret="cursor ~/Joonas\ Sandell/Apps/macOS/.zshrc.secret"
alias zsh-open="cursor ~/Repositories/dotfiles/zsh/.zshrc"

# Npm aliases
alias npm-check-updates="npx npm-check-updates"
alias npm-reinstall-delete-lock="sudo rm -rf node_modules/ && rm -rf package-lock.json && npm install"
alias npm-reinstall="sudo rm -rf node_modules/ && npm install"
alias npm-upgrade-interactive="npx npm-check-updates -i"
alias npm-upgrade="npx npm-check-updates -u"
alias nrd="DISABLE_OPEN=true npm run dev"
alias nrw="DISABLE_OPEN=true npm run watch"

# Bun aliases
alias bun-check-updates="bunx npm-check-updates"
alias bun-npm-name="bunx npm-name-cli"
alias bun-reinstall-delete-lock="sudo rm -rf node_modules/ && rm -rf bun.lockb && bun install"
alias bun-reinstall="sudo rm -rf node_modules/ && bun install"
alias bun-upgrade-interactive="bunx npm-check-updates -i"
alias bun-upgrade="bunx npm-check-updates -u"

# Copy to clipboard
copy-to-clipboard() {
  if [ -e "$1" ]; then
    cat "$1" | pbcopy
    echo "Contents of $1 copied to clipboard."
  else
    echo "File $1 does not exist."
  fi
}

# React Scan (https://react-scan.com)
react-scan() {
  bunx react-scan@latest $1
}

# NVM (https://github.com/nvm-sh/nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Install the specified Node version when an .nvmrc is found (https://github.com/creationix/nvm#zsh)
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Docker (https://www.docker.com)
export COMPOSE_INTERACTIVE_NO_CLI=1 # https://github.com/docker/compose/issues/5696

# Bun completions
[ -s "/Users/joonassandell/.bun/_bun" ] && source "/Users/joonassandell/.bun/_bun"

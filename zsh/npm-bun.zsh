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

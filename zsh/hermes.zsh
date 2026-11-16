# Hermes aliases
alias hermes="HERDR_AGENT=hermes command hermes" # Lets herdr detect the Hermes desktop launcher
alias hermes-webui-restart="HERMES_WEBUI_PYTHON=/opt/homebrew/bin/python3 ~/Repositories/hermes-webui/ctl.sh restart --no-browser" # For config or password changes; Hermes updates restart it through the gateway hook
alias hermes-webui-stop="~/Repositories/hermes-webui/ctl.sh stop" # Stop the WebUI
alias hermes-dashboard-restart="launchctl kickstart -k gui/$(id -u)/ai.hermes.dashboard" # For config or password changes; updates restart it on their own

# Herdr app terminals: a bar cursor. Herdr has no cursor shape setting, but its
# terminals follow the standard escape code, so the shell sets it before every
# prompt (programs like vim or Claude Code may change it while they run).
# HC_TERMINAL_ID is set only in terminals that run in herdr-core.
if [[ -n "$HC_TERMINAL_ID" ]]; then
  _herdr-app-bar-cursor() { printf '\e[6 q'; }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _herdr-app-bar-cursor

  # The pane's tty, so Hermes can show in the app's Agents list: Hermes sends it with each new
  # session (terminal.client_env_passthrough) and its herdr-app-state plugin writes the state there.
  export HC_TTY=$TTY
fi

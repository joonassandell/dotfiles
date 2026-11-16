# Shift+Enter inserts a newline (Ghostty sends Alt+Enter, see ghostty/config.ghostty)
shift-enter-newline() { LBUFFER+=$'\n' }
zle -N shift-enter-newline
bindkey '^[^M' shift-enter-newline

# Cmd+C copies the zsh-shift-select selection to the system clipboard (Ghostty sends Alt+Ctrl+], see ghostty/config.ghostty)
copy-selection-to-clipboard() {
  ((REGION_ACTIVE)) || return
  zle copy-region-as-kill
  print -rn -- $CUTBUFFER | pbcopy
}
zle -N copy-selection-to-clipboard
bindkey '^[^]' copy-selection-to-clipboard
bindkey -M shift-select '^[^]' copy-selection-to-clipboard

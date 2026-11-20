# Shared by android.zsh and ios.zsh: where screenshots and recordings from a phone are saved.
#
# Settings, read each time. Set them in the private zshrc to customize:
#   DEVICE_REC_DIR          folder for the files. Default: ~/Desktop
#   DEVICE_REC_BY_WORKTREE  set to 1 to save in a subfolder named after the current git worktree
#                           (created if missing). Outside a git repo the files go straight in the folder.

# Prints the folder to save in, and creates it.
_ios-android-capture-dir() {
  local dir="${DEVICE_REC_DIR:-$HOME/Desktop}"
  if [[ -n "$DEVICE_REC_BY_WORKTREE" ]]; then
    local top
    top=$(git rev-parse --show-toplevel 2>/dev/null) && dir="$dir/${top:t}"
  fi
  mkdir -p "$dir" && print -r -- "$dir"
}

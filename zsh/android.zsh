# Record the Android screen and save the video on this Mac: `android-rec [name]`.
# Press Ctrl+C to stop. The phone limits one recording to 3 minutes.
#
# Settings, read each time it runs
#   ANDROID_REC_DIR          folder for the videos. Default: ~/Desktop
#   ANDROID_REC_BY_WORKTREE  set to 1 to save in a subfolder named after the current git worktree
#                            (created if missing). Outside a git repo the videos go straight in the folder.
#   ANDROID_SERIAL           which device to use when several are connected (adb reads it itself)
android-rec() {
  if ! command -v adb >/dev/null; then
    echo "adb not found. Add the Android SDK platform-tools to PATH." >&2
    return 1
  fi

  local dir="${ANDROID_REC_DIR:-$HOME/Desktop}"
  if [[ -n "$ANDROID_REC_BY_WORKTREE" ]]; then
    local top
    top=$(git rev-parse --show-toplevel 2>/dev/null) && dir="$dir/${top:t}"
  fi
  mkdir -p "$dir" || return 1

  local file="$dir/${1:-$(date +%Y-%m-%d_%H-%M-%S)}.mp4"
  local remote="/sdcard/android-rec-$$.mp4"

  # Ctrl+C must stop the recording on the phone, not this function: the pull below still has to run.
  setopt localtraps
  trap ':' INT
  echo "Recording to $file. Press Ctrl+C to stop."
  adb shell screenrecord "$remote"
  trap - INT

  sleep 1 # lets the phone finish writing the file
  if adb pull "$remote" "$file" >/dev/null; then
    adb shell rm "$remote"
    [[ -s "$file" ]] || echo "The video is empty. Is the phone screen on?" >&2
    echo "Saved $file"
  else
    echo "Pull failed. The video is still on the phone at $remote" >&2
    return 1
  fi
}

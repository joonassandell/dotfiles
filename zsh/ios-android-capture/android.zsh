# Record or screenshot the Android screen and save it on this Mac:
#   android-rec [name]    video. Press Ctrl+C to stop. The phone limits one recording to 3 minutes.
#   android-shot [name]   screenshot
# Without a name the file is <model>_<date>_<time>, for example pixel-8a_2026-11-20_14-41-10.mp4.
#
# The folder is set in capture.zsh. Which device to use when several are connected: ANDROID_SERIAL
# (adb reads it itself).

# Checks that adb exists, then prints the folder to save in.
_android-capture-dir() {
  if ! command -v adb >/dev/null; then
    echo "adb not found. Add the Android SDK platform-tools to PATH." >&2
    return 1
  fi
  _ios-android-capture-dir
}

# Prints the phone model as a file name prefix, for example pixel-8a.
_android-prefix() {
  local model
  model=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
  _ios-android-capture-slug "${model:-android}"
}

android-rec() {
  local dir
  dir=$(_android-capture-dir) || return 1

  local file="$dir/${1:-$(_android-prefix)_$(date +%Y-%m-%d_%H-%M-%S)}.mp4"
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

android-shot() {
  local dir
  dir=$(_android-capture-dir) || return 1

  local file="$dir/${1:-$(_android-prefix)_$(date +%Y-%m-%d_%H-%M-%S)}.png"
  if adb exec-out screencap -p > "$file" && [[ -s "$file" ]]; then
    echo "Saved $file"
  else
    rm -f "$file"
    echo "Screenshot failed. Is a phone connected, with the screen on?" >&2
    return 1
  fi
}

# Record or screenshot a physical iPhone and save it on this Mac:
#   ios-rec [name]    video (.mov). Needs a USB cable. Press Ctrl+C to stop.
#   ios-shot [name]   screenshot. Works over USB or Wi-Fi.
# The folder is set in capture.zsh. Both need Xcode and an unlocked phone.
#
# Which phone: IOS_DEVICE (its name, see `xcrun devicectl list devices`).
# If it is not set, the one connected phone is used. With several connected, set IOS_DEVICE.
#
# ios-rec records like QuickTime's "New Movie Recording" (ios-rec.swift, compiled on first use).
# devicectl can't do it: "Screen Recording is not supported by this device" on a physical iPhone.

# This folder, found while sourcing: ios-rec compiles ios-rec.swift from here.
_IOS_ANDROID_CAPTURE_SRC="${${(%):-%x}:A:h}"

# Prints the name of the phone to use.
_ios-device() {
  if [[ -n "$IOS_DEVICE" ]]; then
    print -r -- "$IOS_DEVICE"
    return
  fi
  local -a names
  names=("${(@f)$(xcrun devicectl list devices --json-output - 2>/dev/null | /usr/bin/python3 -c '
import sys, json
for d in json.load(sys.stdin)["result"]["devices"]:
    if d["hardwareProperties"]["reality"] == "physical" and d["connectionProperties"].get("tunnelState") == "connected":
        print(d["deviceProperties"]["name"])
')}")
  if (( ${#names} == 1 )) && [[ -n "${names[1]}" ]]; then
    print -r -- "${names[1]}"
  elif [[ -z "${names[1]}" ]]; then
    echo "No connected iPhone. Connect and unlock it, or set IOS_DEVICE." >&2
    return 1
  else
    echo "Several iPhones connected. Set IOS_DEVICE to one of: ${(j:, :)names}" >&2
    return 1
  fi
}

ios-rec() {
  local dir
  dir=$(_ios-android-capture-dir) || return 1

  # Compiled once, and again whenever the source changes.
  local src="$_IOS_ANDROID_CAPTURE_SRC/ios-rec.swift"
  local bin="$HOME/.cache/ios-android-capture/ios-rec"
  if [[ ! -x "$bin" || "$src" -nt "$bin" ]]; then
    echo "Building ios-rec…"
    mkdir -p "${bin:h}" && xcrun swiftc -O "$src" -o "$bin" || return 1
  fi

  local file="$dir/${1:-ios_$(date +%Y-%m-%d_%H-%M-%S)}.mov"
  echo "Waiting for the iPhone…"
  # The recorder finds the phone itself; IOS_DEVICE narrows it when several are connected.
  "$bin" "$file" ${IOS_DEVICE:+"$IOS_DEVICE"} || return 1
  echo "Saved $file"
}

ios-shot() {
  local dir device
  dir=$(_ios-android-capture-dir) || return 1
  device=$(_ios-device) || return 1

  local file="$dir/${1:-ios_$(date +%Y-%m-%d_%H-%M-%S)}.png"
  if xcrun devicectl device capture screenshot --device "$device" --destination "$file" >/dev/null; then
    echo "Saved $file"
  else
    rm -f "$file"
    echo "Screenshot failed. Is $device connected and unlocked?" >&2
    return 1
  fi
}

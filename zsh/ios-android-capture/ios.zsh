# Screenshot a physical iPhone and save it on this Mac: `ios-shot [name]`.
# The folder is set in capture.zsh. Needs Xcode (devicectl) and an unlocked, connected phone.
#
# Which phone: IOS_DEVICE (name or UDID, see `xcrun devicectl list devices`).
# If it is not set, the one connected phone is used. With several connected, set IOS_DEVICE.
#
# There is no ios-rec: devicectl cannot record the screen of an iPhone 14 Pro on iOS 27.3
# ("Screen Recording is not supported by this device").

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

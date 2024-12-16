# Dotfiles of Joonas Sandell

I maintain this repository as my personal dotfiles. Last tested succesfully with macOS `Sequoia 15.1`.

## Getting started

Make sure you're connected to the internet and logged in to App Store.

```shell
# 1. Install brew and follow the instructions for adding `brew` to the path
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install git, and then a open new terminal window
brew install git

# 3. Create `Repositories` directory and clone this repository
mkdir ~/Repositories && cd ~/Repositories
git clone https://github.com/joonassandell/dotfiles.git && cd dotfiles

# 4. Setup and install packages
./bootstrap.sh
```

## Manual setup

In addition to the bootstrapped `macos/setup.sh` do the following manual setups.

- Synology Drive, configure first
  - Check the `Locally deleted files will be removed from your NAS` and `Use minimalist tray icon`
  - Add `Sync files and folders with the prefix "."` to all synced folders
  - Sync initially only essential folders: `Drive/1Password` and `Joonas Sandell/Design Resources/Fonts`
- Keyboard shortcuts
  - Modifier Keys:
    - `Control key ^` → `Command ⌘`,
    - `Command ⌘` -> `Control key ^`
    - `Function (fn)` / `Globe` -> `Command ⌘`
  - App Shortcuts: `Sleep` -> `^ ⌥ ⌘ Q` under `All Applications` for Stream Deck
  - Uncheck `Show Spotligh search` and `Show Finder search window`
  - Uncheck `Turn Dock hiding on/off`
  - Uncheck all the Screenshot shortcuts for CleanShot X
- System Settings
  - Configure Lock Screen, Screen Saver, Background, Mouse Tracking and Scrolling speed, and Hot corners
  - Check `Use scroll gesture with modifier keys to zoom`
  - Configure Finder sidebar: Add essential folders and remove Recents etc.
- Install [One Password 6](https://c.1password.com/dist/1P/mac4/1Password-6.8.9.pkg) and sync it to `~/Drive/1Password`
- Brave:
  - Sync and set it as the default browser
  - Install SoundCloud web app
- Raycast: Import settings from `~/Joonas Sandell/Apps/Raycast`
- Stream Deck:
  - Import Stream Deck profiles from `~/Joonas Sandell/Apps/Stream Deck`
  - Add all the plugins and icon packs
- CleanShot X:
  - [Change the license](https://licenses.maketheweb.io)
  - Check `Start at login`
  - Add shorcut: `Capture Area & Copy to Clipboard` to `^ ⇧ ⌘ 4`
  - Add export location to: `~/Joonas Sandell/Photos/Screenshots`
- Camera Hub: Add Snapshop Location to NAS
- Symlink Sequel Pro favorites: `ln -s ~/Joonas\ Sandell/Apps/Sequel\ Pro ~/Library/Application\ Support/Sequel\ Pro`
- Install `Operator Mono` and other fonts from NAS
- Cursor:
  - Install extensions from `cursor/profile/Default.code-profile` at Cursor Profiles
- Sync Visual Studio Code settings with the native [Settings Sync](https://code.visualstudio.com/docs/editor/settings-sync). I'm not very happy with this approach since it uses [dedicated service](https://code.visualstudio.com/docs/editor/settings-sync#_can-i-use-a-different-backend-or-service-for-settings-sync) and I'd rather like to sync to my own repository.
- Create a standalone Twitch app: `cd /Applications && bunx nativefier https://www.twitch.tv && mv Twitch-darwin-arm64 Twitch`
- Configure Slack
- Configure Warp
  - Keyboard Shortcuts:
    - Clear `Move Cursor End Within an Executing Command`
    - Clear `Move Cursor Home Within an Executing Command`
    - `Activate Next Tab` -> `⌥ ⌘ →`
    - `Activate Previous Tab` -> `⌥ ⌘ ←`
    - `Move to Start of Line` -> `⌘ ←`
    - `Move to End of Line` -> `⌘ →`

There are probably essential settings that are missing from this guide so do whatever is necessary.

## Copyright

Copyright © [Joonas Sandell](https://x.com/joonassandell)

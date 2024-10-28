# Dotfiles of Joonas Sandell for macOS

I maintain this repository as my personal dotfiles.

## Getting started

Log in to App Store and install everything by running:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
git clone https://github.com/joonassandell/dotfiles.git && cd dotfiles
./bootstrap.sh
```

Alternatively you may run individual `setup.sh` files found in subfolders. Bootstrapping last tested succesfully w/ macOS Catalina v10.15.7.

## Notes

- Cursor settings are synced with [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
- Visual Studio Code settings are synced with the native [Settings Sync](https://code.visualstudio.com/docs/editor/settings-sync). However, I'm not very happy with this approach since it uses [dedicated service](https://code.visualstudio.com/docs/editor/settings-sync#_can-i-use-a-different-backend-or-service-for-settings-sync) and I'd rather like to sync to my own repository.
- Manually synced (NAS and symlinks)
  - Raycast settings
  - 1Password vault
  - Sequel Pro favorites `$ ln -s ~/Joonas\ Sandell/Apps/Sequel\ Pro ~/Library/Application\ Support/Sequel\ Pro`

## Thanks to

- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [aleksik/dotfiles](https://github.com/aleksik/dotfiles)

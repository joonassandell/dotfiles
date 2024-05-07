# Dotfiles of Joonas Sandell for macOS

I maintain this repository as my personal dotfiles.

## Getting started

Sign in to App Store and install everything by running:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install git
git clone https://github.com/joonassandell/dotfiles.git && cd dotfiles
./bootstrap.sh
```

Alternatively you may run individual `setup.sh` files found in subfolders. Bootstrapping last tested succesfully w/ macOS Catalina v10.15.7.

## Manually needed installs

- I'm syncing my Visual Studio Code settings with [Settings Sync](https://code.visualstudio.com/docs/editor/settings-sync). However, I'm not very happy with this approach since it uses [dedicated service](https://code.visualstudio.com/docs/editor/settings-sync#_can-i-use-a-different-backend-or-service-for-settings-sync) and I'd rather like to sync to my own repository.
- I'm syncing Raycast settings and 1Password vault with my NAS
- Manually synced (w/ NAS & symlinks)
  - Extra secret shell settings
  - Sequel Pro favorites (e.g. `$ ln -s ~/Joonas\ Sandell/Apps/Sequel\ Pro ~/Library/Application\ Support/Sequel\ Pro`)

## Thanks to

- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [aleksik/dotfiles](https://github.com/aleksik/dotfiles)

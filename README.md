# Dotfiles of [Joonas Sandell](https://joonassandell.com) for macOS

I maintain this repo as my personal dotfiles, so fork this to your own needs. Last tested succesfully w/ macOS Catalina v10.15.7.

## Getting started

Sign in to App Store and install everything by running:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install git
git clone https://github.com/joonassandell/dotfiles.git && cd dotfiles
./bootstrap.sh
```

Alternatively you may run individual `setup.sh` files found in subfolders.

## Manually needed installs

- I'm syncing my Visual Studio settings with [Settings Sync](https://code.visualstudio.com/docs/editor/settings-sync). However, I'm not very happy with this approach since it uses [dedicated service](https://code.visualstudio.com/docs/editor/settings-sync#_can-i-use-a-different-backend-or-service-for-settings-sync) and I'd rather like to sync to my own repository.
- I'm syncing my iTerm2 preferences, Raycast settings and 1Password vault with my NAS
- Manually synced (w/ NAS & symlinks)
  - Extra secret shell settings
  - Sequel Pro favorites (e.g. `$ ln -s ~/Joonas\ Sandell/Apps/Sequel\ Pro ~/Library/Application\ Support/Sequel\ Pro`)
- Might start using [Warp](https://www.warp.dev) later

## Thanks to

- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [aleksik/dotfiles](https://github.com/aleksik/dotfiles)

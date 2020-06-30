# My dotfiles for macOS

I maintain this repo as my personal dotfiles, so fork this to your own needs. Tested succesfully w/ macOS High Sierra v10.13.6. 

## Getting started

Sign in to App Store and install everything by running:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install git
git clone git@github.com:joonassandell/dotfiles.git && cd dotfiles
./bootstrap.sh
```

Alternatively you may run individual `setup.sh` files found in subfolders.

## Manually needed installs

* My [VS Code settings](https://gist.github.com/joonassandell/379b80eee8560b28b45ddcbe407fbee2) synced with [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) (which obviously needs to be synced with the plugin)
* I'm syncing my iTerm prefs, Alfred settings and 1Password vault with Dropbox
* Manually synced (w/ Dropbox & symlinks)
    - Extra secret shell settings
    - Sketch plugins & templates (e.g. `$ ln -s ~/Dropbox/Apps/Sketch/Plugins ~/Library/Application\ Support/com.bohemiancoding.sketch/Plugins`)
    - Sequel Pro favorites (e.g. `$ ln -s ~/Dropbox/Apps/Sequel\ Pro ~/Library/Application\ Support/Sequel\ Pro`)
    - Transmit favorites (e.g. `$ ln -s ~/Dropbox/Apps/Transmit/Favorites ~/Library/Application\ Support/Transmit/Favorites`)

## Thanks to

* [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
* [aleksik/dotfiles](https://github.com/aleksik/dotfiles)

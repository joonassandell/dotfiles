#!/bin/bash
# https://macos-defaults.com
# https://git.herrbischoff.com/awesome-macos-command-line/about

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

info "Configuring macOS..."

# Close any open System Preferences panes, to prevent them from overriding
# settings that are about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.setup` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# =======================================
# Create essential directories
# =======================================

mkdir -p $HOME/.ssh
mkdir -p $HOME/Joonas\ Sandell
mkdir -p $HOME/Drive

# =======================================
# General UI
# =======================================

# Disable natural scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# =======================================
# Finder
# =======================================

# Set the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Joonas%20Sandell/"

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Remove "Recent Tags" from the Finder sidebar
defaults write com.apple.finder ShowRecentTags -bool false && killall Finder

# Use column view in all Finder windows by default. Unsure if this has effect.
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Enable Stacks by kind on the desktop
defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy Kind

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Set the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# =======================================
# Dock
# =======================================

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Make the animation when hiding/showing the Dock faster
defaults write com.apple.dock autohide-time-modifier -float 0.5s

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

# =======================================
# Kill affected applications
# =======================================

for app in "Finder" \
	"Dock"; do
	killall "${app}" &> /dev/null
done

success "Finished configuring macOS, some changes may require a logout or restart to take effect."

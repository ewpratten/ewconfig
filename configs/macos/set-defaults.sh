#! /bin/bash
set -ex

# Apple Screenshots
defaults write com.apple.screencapture location -string '~/Pictures/Screenshots'
defaults write com.apple.screencapture location-last -string '~/Pictures/Screenshots'
defaults write com.apple.screencaptureui NSNavLastRootDirectory -string '~/Pictures/Screenshots'

# Accessibility
defaults write com.apple.Accessibility ReduceMotionEnabled -bool true

# Trackpad Tap to Click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Make my mice linear again!
defaults write -g com.apple.mouse.linear -bool true

# Gestures
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Dock
defaults write com.apple.dock tilesize -int 47
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock launchanim -bool false

# Desktop
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true

# Mos: Trackpad & Mouse Settings
defaults write com.caldis.Mos precision -int 1
defaults write com.caldis.Mos reverse -int 0
defaults write com.caldis.Mos smooth -int 1
defaults write com.caldis.Mos speed -int 3
defaults write com.caldis.Mos step -int 35
defaults write com.caldis.Mos duration -float 3.9

# iTerm2
defaults write com.googlecode.iterm2 FocusFollowsMouse -bool true
defaults write com.googlecode.iterm2 HideScrollbar -bool true
defaults write com.googlecode.iterm2 NeverBlockSystemShutdown -bool true

# Don't write .DS_Store files to network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

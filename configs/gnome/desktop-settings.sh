#! /bin/sh
# This script configures GNOME to my liking
set -e

# Require gsettings
if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings is not installed, skipping some GNOME configuration"
    exit 0
fi

# Mouse settings
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true # Middle click paste
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false # Allow touchpad while typing
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false # Disable natural scrolling on touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true # Enable tap-to-click on touchpad
gsettings set org.gnome.desktop.interface show-battery-percentage true # Show battery percentage

# Disable application switching with Super+num keyy
gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"

# Keyboard settings
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']" # Close windows with Mod+Shift+q
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>exclam']" # Move a window to ws 1
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>at']" # Move a window to ws 2
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>numbersign']" # Move a window to ws 3
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>dollar']" # Move a window to ws 4
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']" # Switch to ws 1
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']" # Switch to ws 2
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']" # Switch to ws 3
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']" # Switch to ws 4

# Generate custom keybinds if they do not yet exist
keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [ "$keybindings" = "[]" ] || [ "$keybindings" = "@as []" ]; then
    # Define the list of custom keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

    # Allow Mod+Enter to open a terminal
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>Return"

    # Allow Mod+d to launch rofi
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "Rofi"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "rofi -show drun"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Super>d"
fi

# Top Bar settings
gsettings set org.gnome.desktop.interface clock-format 24h # 24 hour clock
gsettings set org.gnome.desktop.interface clock-show-date true # Show date in top bar
gsettings set org.gnome.desktop.interface clock-show-weekday true # Show weekday in top bar

# Window settings
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy' # Focus windows on mouse hover
gsettings set org.gnome.desktop.wm.preferences auto-raise false # Don't auto-raise windows

# Desktop settings
gsettings set org.gnome.desktop.interface enable-hot-corners false # Disable hot corners
gsettings set org.gnome.mutter edge-tiling true # Enable edge tiling
gsettings set org.gnome.mutter dynamic-workspaces false # Use a fixed number of workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4 # Use 4 workspaces
gsettings set org.gnome.mutter workspaces-only-on-primary true # Only use workspaces on primary monitor

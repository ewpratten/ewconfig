#! /bin/sh
set -e

# Check if dconf is available
if ! command -v dconf >/dev/null 2>&1; then
    echo "dconf is not installed, skipping GNOME configuration"
    exit 0
fi

# Configure gnome-terminal
echo "Writing gnome-terminal settings..."
dconf load "/org/gnome/terminal/" < configs/gnome/terminal/terminal.dconf

# Configure GNOME itself
echo "Writing GNOME settings..."
sh ./configs/gnome/desktop-settings.sh
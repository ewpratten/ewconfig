#! /bin/sh
set -e

# Get the path to this script
SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Check if dconf is available
if ! command -v dconf >/dev/null 2>&1; then
    echo "dconf is not installed, skipping GNOME configuration"
    exit 0
fi

# Configure gnome-terminal
echo "Writing gnome-terminal settings..."
dconf load "/org/gnome/terminal/" < $SCRIPT_PATH/terminal/terminal.dconf

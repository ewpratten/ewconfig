#! /bin/sh
# Installs the SSH config file
set -e

# Link the SSH config file
echo "Linking SSH config file..."
mkdir -p "$HOME/.ssh"
ln -sf "$(pwd)/configs/ssh/config" "$HOME/.ssh/config"

# Set the correct permissions
echo "Setting SSH config file permissions..."
chmod 644 "$HOME/.ssh/config"
chown "$USER:$USER" "$HOME/.ssh/config"
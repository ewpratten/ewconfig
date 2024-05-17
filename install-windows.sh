#! /bin/sh
set -e
export EWCONFIG_ROOT=$(dirname $(readlink -f $0))

# Pull git submodules if needed
echo "Syncing git submodules..."
git submodule update --init --recursive

# Make sure scripts are all executable
chmod +x $EWCONFIG_ROOT/scripts/*
chmod +x $EWCONFIG_ROOT/configs/nautilus/scripts/*

# -- Directory Setup --
set -x

# Ensure that needed directories exist
mkdir -p ~/bin          # Personal bin dir. Reduces the risk of breaking ~/.local/bin
mkdir -p ~/projects     # For my projects

# Build the directory structure if ~/.config
mkdir -p ~/.config/git
mkdir -p ~/.config/git/config-fragments
mkdir -p ~/.cargo
mkdir -p ~/.ssh

# -- Config Linking --

# Configure the shell
ln -sf $EWCONFIG_ROOT/configs/.zshrc ~/.zshrc
ln -sf $EWCONFIG_ROOT/configs/.zshrc ~/.bashrc
mkdir -p $LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
ln -sf $EWCONFIG_ROOT/configs/windows-terminal/settings.json $LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json

# Configure Git
ln -sf $EWCONFIG_ROOT/configs/git/.gitconfig ~/.gitconfig
ln -sf $EWCONFIG_ROOT/configs/sssh/allowed_signers ~/.ssh/allowed_signers || true
ln -sf $EWCONFIG_ROOT/configs/git/.mailmap ~/.config/git/.mailmap

# Configure Vim
ln -sf $EWCONFIG_ROOT/configs/vim/.vimrc ~/.vimrc

# Remove Microsoft's fake python executables
rm $LOCALAPPDATA/Microsoft/WindowsApps/python.exe || true
rm $LOCALAPPDATA/Microsoft/WindowsApps/python3.exe || true

# Copy the global mailmap file once
if [ ! -f ~/.config/git/config-fragments/global-mailmap.gitconfig ]; then
    cp $EWCONFIG_ROOT/configs/git/config-fragments/global-mailmap.gitconfig ~/.config/git/config-fragments/global-mailmap.gitconfig
fi

# Configure SSH
ln -sf $EWCONFIG_ROOT/configs/ssh/config ~/.ssh/config
chmod 644 "$HOME/.ssh/config"
chown "$USER:$USER" "$HOME/.ssh/config"
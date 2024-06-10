#! /bin/sh
set -e
export EWCONFIG_ROOT=$(dirname $(readlink -f $0))

# -- Ensure that deps exist --

# Pull git submodules if needed
if type -p git > /dev/null; then
    # If we have permission to run git
    if [ -d "$EWCONFIG_ROOT/.git" ]; then
        echo "Syncing git submodules..."
        git submodule update --init --recursive
    fi
fi

# Make sure scripts are all executable
chmod +x $EWCONFIG_ROOT/scripts/*
chmod +x $EWCONFIG_ROOT/configs/nautilus/scripts/*
chmod +x $EWCONFIG_ROOT/modules/*/bin/*

# -- Directory Setup --
set -x

# Ensure that needed directories exist
mkdir -p ~/Downloads    # For downloads
mkdir -p ~/bin          # Personal bin dir. Reduces the risk of breaking ~/.local/bin
mkdir -p ~/projects     # For my projects
mkdir -p ~/src          # For compiling other people's projects

# Build the directory structure if ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/termux
mkdir -p ~/.config/logid
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/glab-cli
mkdir -p ~/.config/user-tmpfiles.d
mkdir -p ~/.config/gqrx
mkdir -p ~/.cargo
mkdir -p ~/.ssh

# Mac-specific dirs
if [ "$(uname)" == "Darwin" ]; then
    mkdir -p ~/Library/Preferences
fi

# Build directory structure for program plugins
mkdir -p ~/.local/share/nautilus/scripts/

# -- Config Linking --

# Configure the shell
ln -sf $EWCONFIG_ROOT/configs/.zshrc ~/.zshrc
ln -sf $EWCONFIG_ROOT/configs/.zshrc ~/.bashrc

if ! uname | grep -q "Darwin"; then
    ln -sf $EWCONFIG_ROOT/configs/.inputrc ~/.inputrc
fi

# Configure Git
ln -sf $EWCONFIG_ROOT/configs/.gitconfig ~/.gitconfig

# Configure SSH
ln -sf $EWCONFIG_ROOT/configs/ssh/config ~/.ssh/config
touch ~/.ssh/config.local
chmod 644 "$HOME/.ssh/config"
if type -p chown > /dev/null; then chown $USER "$HOME/.ssh/config"; fi 

# Configure (neo)Vim
ln -sf $EWCONFIG_ROOT/configs/vim/.vimrc ~/.vimrc
ln -sf $EWCONFIG_ROOT/configs/nvim/init.vim ~/.config/nvim/init.vim
ln -snf $EWCONFIG_ROOT/configs/nvim/pack ~/.config/nvim/pack
ln -snf $EWCONFIG_ROOT/configs/nvim/third_party ~/.config/nvim/third_party

# Nautilus right-click scripts
ln -sf $EWCONFIG_ROOT/configs/nautilus/scripts/* ~/.local/share/nautilus/scripts/

# XDG User Directories
ln -sf $EWCONFIG_ROOT/configs/user-dirs.dirs ~/.config/user-dirs.dirs

# Tabset configs
ln -nsf $EWCONFIG_ROOT/configs/tabset ~/.config/tabset

# Rofi configs
ln -nsf $EWCONFIG_ROOT/configs/rofi ~/.config/rofi

# Cargo
ln -sf $EWCONFIG_ROOT/configs/cargo/config.toml ~/.cargo/config.toml

# Termux
ln -sf $EWCONFIG_ROOT/configs/termux/termux.properties ~/.config/termux/termux.properties

# Set up user-tempfiles configs
ln -sf $EWCONFIG_ROOT/configs/user-tmpfiles.d/* ~/.config/user-tmpfiles.d/

# Logid config
ln -sf $EWCONFIG_ROOT/configs/logid/logid.cfg ~/.config/logid/logid.cfg

# GQRX
ln -sf $EWCONFIG_ROOT/configs/gqrx/bookmarks.csv ~/.config/gqrx/bookmarks.csv

# Systemd
ln -sf $EWCONFIG_ROOT/configs/systemd/user/* ~/.config/systemd/user/
ln -nsf $EWCONFIG_ROOT/configs/systemd/scripts ~/.config/systemd/scripts

# GitLab CLI
ln -sf $EWCONFIG_ROOT/configs/glab-cli/aliases.yml ~/.config/glab-cli/aliases.yml

# iTerm2
if [ "$(uname)" == "Darwin" ]; then
    ln -sf $EWCONFIG_ROOT/configs/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
fi

# Launchpad Scripts
chmod +x $EWCONFIG_ROOT/configs/launchpad-scripts/*
ln -nsf $EWCONFIG_ROOT/configs/launchpad-scripts ~/.config/launchpad-scripts

# Minecraft global configs
ln -nsf $EWCONFIG_ROOT/configs/minecraft ~/.config/minecraft
if [ -d ~/.var/app/org.prismlauncher.PrismLauncher ]; then
    flatpak override --user --filesystem=~/.config/minecraft org.prismlauncher.PrismLauncher
fi

# Tmux
ln -sf $EWCONFIG_ROOT/configs/tmux/.tmux.conf ~/.tmux.conf

# OBS Studio
if [ -d ~/.var/app/com.obsproject.Studio ]; then
    # NOTE: OBS Flatpak can't work with symlinks
    cp $EWCONFIG_ROOT/configs/obs-studio/basic/scenes/Webcam_Controls.json ~/.var/app/com.obsproject.Studio/config/obs-studio/basic/scenes/Webcam_Controls.json
fi
if [ -d ~/.config/obs-studio ]; then
    ln -sf $EWCONFIG_ROOT/configs/obs-studio/basic/scenes/Webcam_Controls.json ~/.config/obs-studio/basic/scenes/Webcam_Controls.json
fi

# Link houdini scripts for appropriate versions
if [ -d ~/houdini19.5 ]; then mkdir -p ~/houdini19.5/scripts; ln -sf $EWCONFIG_ROOT/configs/houdini19.5/scripts/* ~/houdini19.5/scripts; fi

# Link blender scripts for appropriate versions
if [ -d ~/.config/blender/3.6 ]; then ln -sf $EWCONFIG_ROOT/configs/blender/3.x/scripts/addons/* ~/.config/blender/3.6/scripts/addons/; fi

# -- Finalization --

# On systems that need it, configure Gnome
sh ./configs/gnome/gnome-terminal-settings.sh || true
sh ./configs/gnome/desktop-settings.sh || true

# Attempt to force a termux settings reload on Android devices
termux-reload-settings || true

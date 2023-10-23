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
chmod +x $EWCONFIG_ROOT/configs/scripts/*
chmod +x $EWCONFIG_ROOT/configs/nautilus/scripts/*

# -- Directory Setup --
set -x

# Ensure that needed directories exist
mkdir -p ~/Downloads    # For downloads
mkdir -p ~/bin          # Personal bin dir. Reduces the risk of breaking ~/.local/bin
mkdir -p ~/projects     # For my projects
mkdir -p ~/src          # For compiling other people's projects
mkdir -p ~/services     # Service dir for servers mostly

# Build the directory structure if ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/termux
mkdir -p ~/.config/logid
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/git
mkdir -p ~/.config/git/config-fragments
mkdir -p ~/.config/user-tmpfiles.d
mkdir -p ~/.cargo
mkdir -p ~/.ssh

# Build directory structure for program plugins
mkdir -p ~/.local/share/nautilus/scripts/

# -- Config Linking --

# Configure the shell
ln -sf $EWCONFIG_ROOT/configs/shells/zsh/.zshrc ~/.zshrc
ln -sf $EWCONFIG_ROOT/configs/shells/bash/.bashrc ~/.bashrc

# Configure Git
ln -sf $EWCONFIG_ROOT/configs/git/.gitconfig ~/.gitconfig
ln -sf $EWCONFIG_ROOT/configs/sssh/allowed_signers ~/.ssh/allowed_signers
ln -sf $EWCONFIG_ROOT/configs/git/.mailmap ~/.config/git/.mailmap

# Copy the global mailmap file once
if [ ! -f ~/.config/git/config-fragments/global-mailmap.gitconfig ]; then
    cp $EWCONFIG_ROOT/configs/git/config-fragments/global-mailmap.gitconfig ~/.config/git/config-fragments/global-mailmap.gitconfig
fi

# Check if GIT is installed > 2.34
set +x
if type -p git > /dev/null; then
    # If sort has a -V option
    if man sort | grep -q -- -V; then
        # If GIT has SSH signing support, enable it
        git_version=$(git --version | cut -d' ' -f3 | cut -d'.' -f1-2)
        minimum_version=2.34
        if [ "$(printf '%s\n' "$minimum_version" "$git_version" | sort -V | head -n1)" = "$minimum_version" ]; then
            set -x
            ln -sf $EWCONFIG_ROOT/configs/git/config-fragments/enable-signing.gitconfig ~/.config/git/config-fragments/enable-signing.gitconfig
        fi
    fi
fi

# Configure SSH
ln -sf $EWCONFIG_ROOT/configs/ssh/config ~/.ssh/config
chmod 644 "$HOME/.ssh/config"
if type -p chown > /dev/null; then chown "$USER:$USER" "$HOME/.ssh/config"; fi 

# Configure (neo)Vim
ln -sf $EWCONFIG_ROOT/configs/nvim/init.vim ~/.config/nvim/init.vim
unlink ~/.config/nvim/pack || true;         ln -sf $EWCONFIG_ROOT/configs/nvim/pack ~/.config/nvim/pack
unlink ~/.config/nvim/third_party || true;  ln -sf $EWCONFIG_ROOT/configs/nvim/third_party ~/.config/nvim/third_party

# Nautilus right-click scripts
ln -sf $EWCONFIG_ROOT/configs/nautilus/scripts/* ~/.local/share/nautilus/scripts/

# Tabset configs
unlink ~/.config/tabset || true; ln -sf $EWCONFIG_ROOT/configs/tabset ~/.config/tabset

# Rofi configs
unlink ~/.config/rofi || true; ln -sf $EWCONFIG_ROOT/configs/rofi ~/.config/rofi

# Cargo
ln -sf $EWCONFIG_ROOT/configs/cargo/config.toml ~/.cargo/config.toml

# Termux
ln -sf $EWCONFIG_ROOT/configs/termux/termux.properties ~/.config/termux/termux.properties

# Set up user-tempfiles configs
ln -sf $EWCONFIG_ROOT/configs/user-tmpfiles.d/* ~/.config/user-tmpfiles.d/

# Logid config
ln -sf $EWCONFIG_ROOT/configs/logid/logid.cfg ~/.config/logid/logid.cfg

# Minecraft global configs
unlink ~/.config/minecraft || true; ln -sf $EWCONFIG_ROOT/configs/minecraft ~/.config/minecraft
if [ -d ~/.var/app/org.prismlauncher.PrismLauncher ]; then
    flatpak override --user --filesystem=~/.config/minecraft org.prismlauncher.PrismLauncher
fi

# -- Optional Configs --
set +x

# If ~/.config/git/config-fragments/personal-info.gitconfig does not exist
if [ ! -f ~/.config/git/config-fragments/personal-info.gitconfig ]; then
    # Ask if the user wants to install personal GIT config
    echo "Do you want to install the personal GIT config? (y/n)"
    read -r install_git_config
    if [ "$install_git_config" = "y" ]; then
        ln -sf $EWCONFIG_ROOT/configs/git/config-fragments/personal-info.gitconfig ~/.config/git/config-fragments/personal-info.gitconfig
    fi
fi

# Link houdini scripts for appropriate versions
if [ -d ~/houdini19.5 ]; then mkdir -p ~/houdini19.5/scripts; ln -sf $EWCONFIG_ROOT/configs/houdini19.5/scripts/* ~/houdini19.5/scripts; fi

# Link blender scripts for appropriate versions
if [ -d ~/.config/blender/3.6 ]; then ln -sf $EWCONFIG_ROOT/configs/blender/3.x/scripts/addons/* ~/.config/blender/3.6/scripts/addons/; fi

# -- Finalization --

# On systems that need it, configure Gnome
sh ./helpers/configure-gnome.sh

# Attempt to force a termux settings reload on Android devices
termux-reload-settings || true

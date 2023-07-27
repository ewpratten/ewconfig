#! /bin/bash
set -e

if [[ "$HOSTNAME" == "fedora" ]] || [[ "$HOSTNAME" == "ewpratten-laptop" ]]; then 
    mkdir -p $HOME/.config/git/features
    ln -sf $EWCONFIG_ROOT/configs/git/features/enable-signing.gitconfig $HOME/.config/git/features/enable-signing.gitconfig
fi
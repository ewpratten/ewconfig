# *ew*pratten's *config* files

This repository stores most of my common config files. It is designed to be deployable to pretty much any system. Assuming ideal conditions, any machine is one `sh ./install-<os>` away from behaving like my personal workstation.

*I know its called ew**config**, but at this point, its more of a monorepo of scripts*

## Setup

The scripts in this repository have the following dependencies:

- Git (optional, extremely recommended)
- ZSH (optional, recommended)
- Neovim (optional, recommended)
- `zsh-vcs` (*required on Alpine Linux*)

Install and link everything with:

```sh
mkdir -p ~/.config && cd ~/.config
git clone https://github.com/ewpratten/ewconfig
cd ewconfig

# Linux & BSD & MacOS
sh ./install-linux.sh

# Windows, with GIT BASH
sh ./install-windows.sh
```

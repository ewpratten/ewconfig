# Evan Pratten's Shell RC file
#
# This file is designed to work in *both* ZSH and Bash.
# This way, I can just drop this on a remote machine if needed
# without bringing the entirety of ewconfig along.
#
# That being said, if you are reading this on a machine I've done that on, you
# might want to check out the main repository for more information about what
# you are looking at: https://github.com/ewpratten/ewconfig
#
# This file has controlled my shell experience since 2015-ish, and originally targeted crosh.
# Since then, I've adapted things to work in Bash and ZSH, and on a variety of systems that arent ChromeOS.

# Firstly, if this machine has a copy of ewconfig, keep track of its location
[[ -d "$HOME/.config/ewconfig" ]] && export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# Put ZSH into "emacs mode" to fix macos keybinds
[[ -z "$ZSH_VERSION" ]] && bindkey -e

# Configure default binary and library paths
export GOPATH="$HOME/go"
export PATH="$EWCONFIG_ROOT/scripts:$EWCONFIG_ROOT/rust-bin:$HOME/bin:$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH"
[[ -s "$GOPATH/bin" ]] && export PATH="$GOPATH/bin:$PATH"
[[ -s "$HOME/.docker/bin" ]] && export PATH="$HOME/.docker/bin"
# [[ -f "$EWCONFIG_ROOT/configs/python/python_startup.py" ]] && export PYTHONSTARTUP="$EWCONFIG_ROOT/configs/python/python_startup.py"

# Display operating system and architecture information
echo -e "\033[0;32mPlatform:\033[0m $(uname -s) $(uname -r) $(uname -p)"

# Displaying uptime is a little more complicated because only some systems support `uptime -p`.
# To get around this, we can fall back to using `sed` to get a rough estimate if needed.
if [ -x "$(command -v uptime)" ]; then
    if [ "$(uptime -p 2>/dev/null)" ]; then
        echo -e "\033[0;32mUptime:\033[0m $(uptime -p)"
    else
        echo -e "\033[0;32mUptime:\033[0m $(uptime | awk '{print $3 " " $4}' | sed 's/,//g')"
    fi
fi

# Get the binary name of the current shell
SHELL_NAME=$(basename $SHELL)
[ -n "$ZSH_VERSION" ] && SHELL_NAME="zsh"
[ -n "$BASH_VERSION" ] && SHELL_NAME="bash"

# If a shell specifier is set, wrap it in brackets
# Don't show ZSH unless EWP_SHELL_TYPE is also set
if [ -n "$EWP_SHELL_TYPE" ]; then
    SHELL_SPECIFIER="($EWP_SHELL_TYPE $SHELL_NAME) "
else
    [[ -z "$ZSH_VERSION" ]] && SHELL_SPECIFIER="($SHELL_NAME) "
fi

# Determine the hostname color based on the current session info
HOST_COLOR=$'\033[0;32m' # Green
[[ -n "$SSH_CLIENT" ]] && HOST_COLOR=$'\033[0;33m' # Yellow
[[ $(id -u) -eq 0 ]] && HOST_COLOR=$'\033[0;31m' # Red

# Set the prompt to display basic info about this session.
PS1="\[\033[0m\]${SHELL_SPECIFIER}\[${HOST_COLOR}\]\u@\h \[\033[0;36m\]\w \$ \[\033[0m\]"
if [ -n "$ZSH_VERSION" ]; then
    PROMPT=$'%{\033[0m%}'"${SHELL_SPECIFIER}%{${HOST_COLOR}%}"$'%n@%m %{\033[0;36m%}%~ \$ %{\033[0m%}'
fi

# Additionally, add some extra info to the right of the prompt in zsh
if [ -n "$ZSH_VERSION" ]; then
    # Configure the vcs_info plugin to show branch info (only if we aren't in ISH on iPadOS)
    if [ $(uname -r | grep -c "\-ish$") -eq 0 ]; then
        autoload -Uz vcs_info
        zstyle ':vcs_info:*' actionformats '%F{244}[%F{2}%b%F{3}|%F{1}%a%F{244}]%f '
        zstyle ':vcs_info:*' formats '%F{244}[%F{2}%b%F{244}]%f '
        zstyle ':vcs_info:*' enable git
        vcs_info_wrapper() {
            vcs_info
            if [ -n "$vcs_info_msg_0_" ]; then
                echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
            fi
        }
    else
        vcs_info_wrapper() {
            echo ""
        }
    fi
    
    setopt prompt_subst
    export RPROMPT=$'%T $(vcs_info_wrapper)%?'
fi

# Set my preferred editor in order of preference if found
[[ -x "$(command -v nano)" ]] && export EDITOR="nano"
[[ -x "$(command -v vi)" ]] && export EDITOR="vi"
[[ -x "$(command -v vim)" ]] && export EDITOR="vim"
[[ -x "$(command -v nvim)" ]] && export EDITOR="nvim"

# If we have neovim, use it as the manpage viewer
if type -p nvim > /dev/null; then
    export MANPAGER="nvim +Man!"
    export MANWIDTH=80
fi

# If ls can output color, enable it
[[ -x "$(command -v dircolors)" ]] && eval "$(dircolors -b)"

# Basic aliases
alias ll="ls -l"
alias la="ls -a"
alias :q=exit
alias :wq=exit
alias cls=clear
alias snvim="sudoedit"
alias genuuid="python -c 'import uuid; print(uuid.uuid4())'"
alias nvim-tmp="$EDITOR $(mktemp)"
alias vim-tmp="$EDITOR $(mktemp)"

# Some aliases only make sense if their parent command exists
[[ -x "$(command -v wg)" ]] && alias wg-easykeys="wg genkey | tee >(wg pubkey)"
[[ -x "$(command -v systemd-resolve)" ]] && alias flush-dns="sudo systemd-resolve --flush-caches"
[[ -x "$(command -v ykman)" ]] && alias yk-totp="ykman oath accounts code"
[[ -x "$(command -v ufw)" ]] && alias ufw-status="sudo ufw status numbered"
[[ -x "$(command -v xclip)" ]] && alias clipboard="xclip -selection clipboard"

# "Magic" reload commands
alias ewp-reload-shell-rc="source ~/.${SHELL_NAME}rc"
alias zshreload=ewp-reload-shell-rc
alias bashreload=ewp-reload-shell-rc

# A few functions that keep me sane
mkcd() {
    if [ $# != 1 ]; then
        echo "Usage: mkcd <dir>"
    else
        mkdir -p $1 && cd $1
    fi
}
source_env() {
    env=${1:-.env}
    [ ! -f "${env}" ] && { echo "Env file ${env} doesn't exist"; return 1; }
    eval $(sed -e '/^\s*$/d' -e '/^\s*#/d' -e 's/=/="/' -e 's/$/"/' -e 's/^/export /' "${env}")
}
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xvjf $1 ;;
            *.tar.gz) tar xvzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xvf $1 ;;
            *.tbz2) tar xvjf $1 ;;
            *.tgz) tar xvzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *.tar.zst) tar --use-compress-program=unzstd -xvf $1 ;;
            *.zst) zstd -d $1 ;;
            *.rpm) rpm2cpio $1 | cpio -idmv ;;
            *) echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
proc-grep() {
    if [ $# != 1 ]; then
        echo "Usage: proc-grep <regex>"
    else
        ps u | head -1
        ps aux | grep $1
    fi
}

# Search for and load any additional modules
if [ -d "$EWCONFIG_ROOT/modules" ]; then
    for module in $(find $EWCONFIG_ROOT/modules -maxdepth 1 -mindepth 1 -type d); do
        [[ -d "$module/bin" ]] && export PATH="$module/bin:$PATH"
        [[ -f "$module/.zshrc" ]] && source "$module/.zshrc"
    done
fi

# Set up a common command history
HISTFILE="$HOME/.histfile"
HISTSIZE=100000
SAVEHIST=100000
HISTFILESIZE=100000

# Ignore duplicates & instantly append to history
if [ -n "$ZSH_VERSION" ]; then
    setopt INC_APPEND_HISTORY
    setopt HIST_FIND_NO_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
else
    HISTCONTROL=ignoreboth
    shopt -s histappend
    export PROMPT_COMMAND='history -a'
fi

# Set up the auto-complete directories
mkdir -p ~/.local/share/bash-completion/completions
mkdir -p ~/.zfunc
fpath+=~/.zfunc

# If we have rustup, generate its auto-complete scripts
if [ -x "$(command -v rustup)" ]; then
    rustup completions bash > ~/.local/share/bash-completion/completions/rustup
    rustup completions bash cargo > ~/.local/share/bash-completion/completions/cargo
    rustup completions zsh > ~/.zfunc/_rustup
    rustup completions zsh cargo > ~/.zfunc/_cargo
fi

# Enable ZSH auto-complete
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
fi

# ZSH keybindings
if [ -n "$ZSH_VERSION" ]; then
    # Ctrl + Arrow
    bindkey "\e[1;5C" forward-word
    bindkey "^[[1;5C" forward-word
    bindkey "\e[1;5D" backward-word
    bindkey "^[[1;5D" backward-word
    
    # Ctrl + Delete
    bindkey "\e[3;5~" kill-word
    
    # Ctrl + Backspace
    bindkey '^H' backward-kill-word
    
    # Ctrl + Shift + Delete
    bindkey "\e[3;6~" kill-line
    
    # Home & End
    bindkey  "^[[H"   beginning-of-line
    bindkey  "^[[F"   end-of-line
    
    # Delete
    bindkey  "^[[3~"  delete-char
    
    # Allow up arrow to be used to go back in history based on current line contents
    autoload -U up-line-or-beginning-search
    autoload -U down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search # Up
    bindkey "^[[B" down-line-or-beginning-search # Down
    bindkey "^[OA" up-line-or-beginning-search # Up over SSH connection
    bindkey "^[OB" down-line-or-beginning-search # Down over SSH connection
fi

# hledger
export LEDGER_FILE="$HOME/Documents/finances/finances.journal"

# Homebrew needs to be initialized now
[[ -s "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# If this is macos, alias `mtr` to `sudo mtr` (if mtr exists)
[[ $(uname -s) == "Darwin"  &&  -x "$(command -v mtr)" ]] && alias mtr="sudo mtr"

# If the Tailscale CLI exists, alias it
[[ -s "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Various tools think they need to live here too. I shall appease them..
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
[[ -s "$HOME/pkg/flutter/bin" ]] && export PATH="$HOME/pkg/flutter/bin:$PATH"
[[ -s "$HOME/.rye/env" ]] && source "$HOME/.rye/env"
[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"


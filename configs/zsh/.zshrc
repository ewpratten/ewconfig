
# There are some important env vars that need to exist
export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# Load my custom prompt and macros
. $EWCONFIG_ROOT/configs/zsh/prompt.sh
. $EWCONFIG_ROOT/configs/zsh/macros.sh
. $EWCONFIG_ROOT/configs/zsh/keybinds.sh
. $EWCONFIG_ROOT/configs/zsh/autocomplete.sh

# Load per-host configuration
if [ -f $EWCONFIG_ROOT/configs/zsh/by_host/$HOSTNAME.sh ]; then
  . $EWCONFIG_ROOT/configs/zsh/by_host/$HOSTNAME.sh
fi

# Show some host info
. $EWCONFIG_ROOT/configs/zsh/info.sh

# I always want my ~/bin to be in my PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Configure a sane default editor
if type -p nvim > /dev/null; then
  export EDITOR="nvim"
elif type -p vim > /dev/null; then
  export EDITOR="vim"
elif type -p vi > /dev/null; then
  export EDITOR="vi"
elif type -p nano > /dev/null; then
  export EDITOR="nano"
fi

# If we have neovim, use it as the manpage viewer
if type -p nvim > /dev/null; then
    export MANPAGER="nvim +Man!"
    export MANWIDTH=80
fi

# SDKMAN!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Flutter
[[ -s "$HOME/pkg/flutter/bin" ]] && export PATH="$HOME/pkg/flutter/bin:$PATH"

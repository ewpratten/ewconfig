
# There are some important env vars that need to exist
export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# Load my custom prompt and macros
. $EWCONFIG_ROOT/configs/zsh/prompt.sh
. $EWCONFIG_ROOT/configs/zsh/macros.sh

# Load per-host configuration
if [ -f $EWCONFIG_ROOT/configs/zsh/by_host/$HOSTNAME.sh ]; then
  . $EWCONFIG_ROOT/configs/zsh/by_host/$HOSTNAME.sh
fi
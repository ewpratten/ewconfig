# This is a somewhat hacky bashrc that is used to provide some of the conveniences from my zshrc on machines that I can't get zsh on
export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# Show some host info
echo "info"
. $EWCONFIG_ROOT/configs/shells/bash/info.sh

# Load macros
echo "macros"
. $EWCONFIG_ROOT/configs/shells/bash/macros.sh

# I always want my ~/bin to be in my PATH
export PATH="$HOME/bin:$PATH"
export PATH="$EWCONFIG_ROOT/configs/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# A basic prompt to display user@host dir sign
export PS1="(bash) \[\e[0;32m\]\u@\h \[\e[0;36m\]\w \[\e[0;36m\]\$ \[\e[0m\]"

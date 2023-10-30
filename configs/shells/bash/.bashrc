# This is a somewhat hacky bashrc that is used to provide some of the conveniences from my zshrc on machines that I can't get zsh on
export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# Show some host info
. $EWCONFIG_ROOT/configs/shells/bash/info.sh

# Load macros
. $EWCONFIG_ROOT/configs/shells/bash/macros.sh

# I always want my ~/bin to be in my PATH
export PATH="$HOME/bin:$PATH"
export PATH="$EWCONFIG_ROOT/configs/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# A basic prompt to display user@host dir sign
export PS1="(${PS1_CTX:-bash}) \[\e[0;32m\]\u@\h \[\e[0;36m\]\w \[\e[0;36m\]\$ \[\e[0m\]"

# If found, load studio python
if [ -d "/c/Programs/software/win/core/python/python_3.7.7" ]; then export PATH="/c/Programs/software/win/core/python/python_3.7.7:$PATH"; fi

# If `python --version` starts with `Python 3`
if [[ $(python --version) == Python\ 3* ]]; then
    # If we don't have python3 in our path
    if ! command -v python3 &> /dev/null; then
        # Make an alias for python3
        alias python3=python
    fi
fi

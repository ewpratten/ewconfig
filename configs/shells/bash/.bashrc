# This is a somewhat hacky bashrc that is used to provide some of the conveniences from my zshrc on machines that I can't get zsh on
export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# Show some host info
. $EWCONFIG_ROOT/configs/shells/bash/info.sh

# Load macros
. $EWCONFIG_ROOT/configs/shells/bash/macros.sh

# I always want my ~/bin to be in my PATH
export PATH="$HOME/bin:$PATH"
export PATH="$EWCONFIG_ROOT/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# I want to be able to load my custom python modules
export PYTHONPATH="$EWCONFIG_ROOT/python_modules:$PYTHONPATH"
export PYTHONSTARTUP="$EWCONFIG_ROOT/configs/python/python_startup.py"

# A basic prompt to display user@host dir sign
export PS1="(${PS1_CTX:-bash}) \[\e[0;32m\]\u@\h \[\e[0;36m\]\w \[\e[0;36m\]\$ \[\e[0m\]"

# Search for ewconfig modules that need to be loaded
for module in $(find $EWCONFIG_ROOT/modules -maxdepth 1 -mindepth 1 -type d); do
    # If this module contains a `bin` directory, add it to the PATH
    if [ -d "$module/bin" ]; then
        export PATH="$module/bin:$PATH"
    fi
done
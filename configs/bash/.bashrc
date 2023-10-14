# This is a somewhat hacky bashrc that is used to provide some of the conveniences from my zshrc on machines that I can't get zsh on
export EWCONFIG_ROOT="$HOME/.config/ewconfig"

# I always want my ~/bin to be in my PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Makes a directory, then moves into it
mkcd() {
    if [ $# != 1 ]; then
        echo "Usage: mkcd <dir>"
    else
        mkdir -p $1 && cd $1
    fi
}

# A basic prompt to display user@host dir sign
export PS1="(bash) \[\e[0;32m\]\u@\h \[\e[0;36m\]\w \[\e[0;36m\]\$ \[\e[0m\]"

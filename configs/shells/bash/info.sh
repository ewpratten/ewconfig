
# Define red and green based on the shell
if [ -n "$BASH_VERSION" ]; then
    red='\033[0;31m'
    green='\033[0;32m'
    reset_color='\033[0m'
    elif [ -n "$ZSH_VERSION" ]; then
    red="$fg[red]"
    green="$fg[green]"
fi

# Different OSes have different ways of displaying info
if [ $(uname -s | grep -c BSD) -gt 0 ]; then # BSD
    echo -e "${green}Platform:$reset_color $(uname -s) $(uname -r) $(uname -p)"
    
elif [ $(uname -s | grep -c MINGW) -gt 0 ]; then # Windows
    echo -e "${green}Platform:$reset_color $(uname -o) $(uname -r)"
    
else # Linux-y things
    echo -e "${green}Platform:$reset_color $(uname -o) $(uname -r)"

    # If the `uptime` binary is *not* busybox, we can show it
    if [ $(uptime -V 2>&1 | grep -c busybox) -eq 0 ]; then
        echo -e "${green}Uptime:$reset_color $(uptime -p)"
    fi
fi

# Determine if $EWCONFIG_ROOT contains uncommitted changes
# Skip this if on Windows
if [ -d $EWCONFIG_ROOT/.git ]; then
    if [ $(uname -s | grep -c MINGW) -eq 0 ]; then
        if [ -n "$(git -C $EWCONFIG_ROOT status --porcelain)" ]; then
            echo -e "${red}ewconfig contains uncommitted changes$reset_color"
        fi
    fi
fi


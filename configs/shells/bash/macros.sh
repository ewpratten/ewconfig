# If ls has `--color` support
if ls --color > /dev/null 2>&1; then
    alias ls="ls --color=auto"
fi

# Main aliases
alias ll="ls -l"
alias la="ls -a"
alias :q="exit"
alias :wq="exit"
alias cls=clear
alias bashreload="source ~/.bashrc"
alias wg-easykeys="wg genkey | tee >(wg pubkey)"
alias nvim-tmp="nvim $(mktemp)"
alias flush-dns="sudo systemd-resolve --flush-caches"
alias lsgrep="ls | grep"
alias git-diff-nvim="git diff | nvim -R -d -c 'set filetype=diff' -"
alias yk-totp="ykman oath accounts code"
alias flush-dns-cache="sudo systemd-resolve --flush-caches"
alias ufw-status="sudo ufw status numbered"
alias genuuid="python -c 'import uuid; print(uuid.uuid4())'"
alias clipboard="xclip -selection clipboard"
alias snvim="sudoedit"

# WHOIS macros
alias whois-afrinic="whois -h whois.afrinic.net"
alias whois-altdb="whois -h whois.altdb.net"
alias whois-aoltw="whois -h whois.aoltw.net"
alias whois-ampr="whois -h whois.ampr.org"
alias whois-apnic="whois -h whois.apnic.net"
alias whois-arin="whois -h rr.arin.net"
alias whois-bell="whois -h whois.in.bell.ca"
alias whois-bboi="whois -h irr.bboi.net"
alias whois-bgptools="whois -h bgp.tools"
alias whois-canarie="whois -h whois.canarie.ca"
alias whois-epoch="whois -h whois.epoch.net"
alias whois-jpirr="whois -h jpirr.nic.ad.jp"
alias whois-lacnic="whois -h irr.lacnic.net"
alias whois-level3="whois -h rr.level3.net"
alias whois-nestegg="whois -h whois.nestegg.net"
alias whois-panix="whois -h rrdb.access.net"
alias whois-radb="whois -h whois.radb.net"
alias whois-reach="whois -h rr.telstraglobal.net"
alias whois-ripe="whois -h whois.ripe.net"

# Neo-aliases
if [ -x "$(command -v nvim)" ]; then alias vim="nvim"; fi
if [ -x "$(command -v neomutt)" ]; then alias mutt="neomutt"; fi

# If python exists, configure an alias for python3 if needed
if [ -x "$(command -v python)" ]; then
    # If `python --version` starts with `Python 3`
    if [[ $(python --version) == Python\ 3* ]]; then
        # If we don't have python3 in our path
        if ! command -v python3 &> /dev/null; then
            # Make an alias for python3
            alias python3=python
        fi
    fi
fi

# If we are running in a studio environment
if [ ! -z "$EWP_IN_GURU_ENVIRONMENT" ]; then
    alias guru_launcher3="python $GURU_PYTHON_ROOT/env/guru_launcher3.py"
    alias cd-dev="cd /s/development/epratten"
fi


# Makes a directory, then moves into it
mkcd() {
    if [ $# != 1 ]; then
        echo "Usage: mkcd <dir>"
    else
        mkdir -p $1 && cd $1
    fi
}

# Sources a .env
source_env() {
    env=${1:-.env}
    [ ! -f "${env}" ] && { echo "Env file ${env} doesn't exist"; return 1; }
    eval $(sed -e '/^\s*$/d' -e '/^\s*#/d' -e 's/=/="/' -e 's/$/"/' -e 's/^/export /' "${env}")
}

# Auto-extract anything
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

# Updates ewconfig
ewconfig-pull() {
    cwd=$(pwd)
    cd ~/.config/ewconfig
    git pull
    cd $cwd
}

# Updates the ewconfig on machines that don't have git
ewconfig-pull-zip(){
    cwd=$(pwd)
    # If $EWCONFIG_ROOT/.git exists, don't let the user run this
    if [ -d $EWCONFIG_ROOT/.git ]; then
        echo "You can't run this command when ~/.config/ewconfig is a git repo!"
        return 1
    fi
    
    # Download the latest zip
    cd ~/Downloads
    curl -L https://ewp.fyi/config.zip -o ewconfig.zip
    rm -rf ~/.config/ewconfig
    unzip ewconfig.zip
    mv ewconfig-master ~/.config/ewconfig
    rm ewconfig.zip
    
    # Return to the original directory
    cd $cwd
}

# Temporairly hop to the ewconfig directory to run a command
ewconfig-run() {
    cwd=$(pwd)
    cd ~/.config/ewconfig
    $@
    cd $cwd
}

# Re-run the install script from anywhere
ewconfig-reinstall() {
    # Require an argument (linux, windows)
    if [ $# != 1 ]; then
        echo "Usage: ewconfig-reinstall <platform>"
        return 1
    fi
    
    # Execute through ewconfig-run
    ewconfig-run sh ./install-$1.sh
}

# If `gh` is not installed, fake it so that I can save my muscle memory
if ! command -v gh &> /dev/null; then
    gh() {
        if [ $# != 3 ]; then
            echo "You don't have gh installed. Emulating its functionality."
            echo "Usage: gh repo clone <user>/<repo>"
        else
            git clone https://github.com/$3
        fi
    }
fi

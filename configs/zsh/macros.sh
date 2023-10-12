alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias :q="exit"
alias :wq="exit"
alias cls=clear
alias zshreload="source ~/.zshrc"
alias wg-easykeys="wg genkey | tee >(wg pubkey)"
alias nvim-tmp="nvim $(mktemp)"
alias flush-dns="sudo systemd-resolve --flush-caches"
alias showsizes="du -h --max-depth=1"
alias lsgrep="ls | grep"
alias sheridan-rdp='firefox --new-window "ext+container:name=College&url=https://client.wvd.microsoft.com/arm/webclient/index.html"'
alias git-diff-nvim="git diff | nvim -R -d -c 'set filetype=diff' -"
alias yk-totp="ykman oath accounts code"
alias flush-dns-cache="sudo systemd-resolve --flush-caches"
alias ewconfig-pull="cd ~/.config/ewconfig; git pull"

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

# Kill via pgrep
nkill() {
    if [ $# != 1 ]; then
        echo "Usage: nkill <name>"
    else
        kill -9 $(pgrep $1) 
    fi
}

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
        *) echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Generate a password
genpass() {
    if [ $# != 1 ]; then
        echo "Usage: genpass <len>"
    else
        echo $(openssl rand -base64 $1 | tr -d "\n")
    fi

}

# Sign a file with an SSH key
ssh-sign(){
    if [ $# != 2 ]; then
        echo "Usage: ssh-sign <key_file> <file>"
    else
        if [ -f $2 ]; then
            cat $2 | ssh-keygen -Y sign -f $1 -n file -
        else
            >&2 echo "File not found: $2"
        fi
    fi
}

# Verify a file, using the ~/.ssh/allowed_signers file
ssh-verify(){
    if [ $# != 3 ]; then
        echo "Usage: ssh-verify <author> <sigfile> <file>"
    else
        ssh-keygen -Y verify -f ~/.ssh/allowed_signers -n file -I $1 -s $2 < $3
    fi
}

# Fully restart a wireguard link
wg-restart() {
    if [ $# != 1 ]; then
        echo "Usage: wg-restart <interface>"
    else
        wg-quick down $1 || true;
        wg-quick up $1
    fi
}

# Reload a wireguard link without stopping it
wg-reload() {
    if [ $# != 1 ]; then
        echo "Usage: wg-reload <interface>"
    else
        wg syncconf $1 <(wg-quick strip $1)
    fi
}

# Edit a wireguard config file
wg-edit() {
    if [ $# != 1 ]; then
        echo "Usage: wg-edit <interface>"
    else
        sudo nvim /etc/wireguard/$1.conf
    fi
} 

# Print a wireguard config file
wg-cat() {
    if [ $# != 1 ]; then
        echo "Usage: wg-cat <interface>"
    else
        sudo cat /etc/wireguard/$1.conf
    fi
}

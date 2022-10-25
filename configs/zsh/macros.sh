alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias :q="exit"
alias :wq="exit"
alias cls=clear
alias p4='ping 8.8.8.8 -c 4'
alias quickhttp='sudo python -m SimpleHTTPServer 443'
alias zshreload="source ~/.zshrc"
alias wg-easykeys="wg genkey | tee >(wg pubkey)"
alias nvim-tmp="nvim $(mktemp)"

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

# Kill via pgrep
nkill() {
    kill -9 $(pgrep $1) 
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
        *) echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

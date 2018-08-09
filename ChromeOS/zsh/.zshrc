# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/chronos/user/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
#source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias gitpsswd="cat /media/removable/SD\ Card/gitpsswd"

# prompt stuff
autoload -U colors && colors
NEWLINE=$'\n'
export PROMPT="%{$fg[green]%}%n@%M %{$fg[cyan]%}%~ $ %{$reset_color%}"
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
export RPROMPT=$'%@ $(vcs_info_wrapper) %?'
#other stuff

# clear
# screenfetch

#dont mess with this
alias ls="ls --color=auto"

alias pip="python3 -m pip"

# aliases

#pandoc
alias docx="pandoc -s -o"

alias school="cd /media/removable/SD\ Card/School"
alias sdcard="cd /media/removable/SD\ Card/"
alias ll="ls -l"
alias la="ls -a"
alias please='sudo $(history -p !!)'
# alias vi=vim
alias :q="exit"
alias :wq="exit"
alias cls=clear
alias zshreload="source ~/.zshrc"
alias lip="ip addr | grep inet | grep wlan0"
alias p4='ping 4.2.2.2 -c 4'

sci(){
	if [ $# != 1 ]; then
                crew -h
        else
                crew install $1
        fi
}

search(){
	if [ $# != 1 ]; then
		echo "please enter a name to search for"
	else
		ls | grep "$1"
	fi
}

csearch(){
	if [ $# != 1 ]; then
                echo "Usage: csearch <search term>"
        else
        	crew search | grep -e "$1"
        fi
}

mkcd() {
        if [ $# != 1 ]; then
                echo "Usage: mkcd <dir>"
        else
                mkdir -p $1 && cd $1
        fi
}

cl()
{
        last_dir="$(ls -Frt | grep '/$' | tail -n1)"
        if [ -d "$last_dir" ]; then
                cd "$last_dir"
        fi
}

sud() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}
#cls
#screenfetch
#source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /home/chronos/user/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval $(thefuck --alias)
export PATH=/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/local/share/texlive/2017/bin/x86_64-linux
export MANPATH=/usr/local/share/man:/usr/share/man:/usr/local/share/texlive/2017/bin/texmf-dist/doc/man

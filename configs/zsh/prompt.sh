# This is some kind of dark magic.
# I have no memory of whats going on here, but this has been my config since 2015-ish, so it shall not be touched.

autoload -U colors && colors
NEWLINE=$'\n'
export PROMPT="%{$fg[green]%}%n@%M %{$fg[cyan]%}%~ $ %{$reset_color%}"
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
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

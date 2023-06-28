# Make all shells append to history file instantly
setopt INC_APPEND_HISTORY

# Handles case-insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Configure command history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Ignore duplicates in history search, and dont't write them either
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Ignore commands starting with a space
setopt HIST_IGNORE_SPACE

# Allow up arrow to be used to go back in history based on current line contents
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

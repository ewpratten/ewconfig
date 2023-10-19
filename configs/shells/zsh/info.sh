
# If `uname -s` is a BSD
if [ uname -s | grep BSD - > /dev/null ]; then
  echo "$fg[green]Platform:$reset_color $(uname -s) $(uname -r) $(uname -p)"
else # Linux
  echo "$fg[green]Platform:$reset_color $(uname -o) $(uname -r)"
  echo "$fg[green]Uptime:$reset_color $(uptime -p)"
fi

# Determine if $EWCONFIG_ROOT contains uncommitted changes
if [ -d $EWCONFIG_ROOT/.git ]; then
  if [ -n "$(git -C $EWCONFIG_ROOT status --porcelain)" ]; then
    echo "$fg[red]ewconfig contains uncommitted changes$reset_color"
  fi
fi

# # Determine if $EWCONFIG_ROOT is up-to-date with origin. Only do this if we have network connectivity.
# if [ -d $EWCONFIG_ROOT/.git ]; then
#   if ping -c 1 -W 1 git.github.com &> /dev/null; then
#     if [ -n "$(git -C $EWCONFIG_ROOT fetch --dry-run 2>&1 | grep -v 'up to date')" ]; then
#       echo "$fg[yellow]ewconfig is not up-to-date with origin$reset_color"
#     fi
#   fi
# fi
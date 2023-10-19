# We are compatible with bash, so first load the bash-specific macros
. $EWCONFIG_ROOT/configs/shells/bash/macros.sh

# Search for a process
proc-grep() {
    if [ $# != 1 ]; then
        echo "Usage: proc-grep <regex>"
    else
        ps aux | { head -1; grep $1 }
    fi
}

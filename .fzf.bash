# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tofid/.fzf/bin* ]]; then
  export PATH="$PATH:/home/tofid/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/tofid/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/tofid/.fzf/shell/key-bindings.bash"


#!/bin/bash

# clears screen after running "tmux-session.sh"
clear

# sets directories to look in
DIRS=(
  "$HOME"
  "$HOME/.config"
  "$HOME/Documents"
  "$HOME/Documents/projects"
  "$HOME/Documents/projects/c"
  "$HOME/Documents/projects/cs"
  "$HOME/Documents/projects/rust"
)

# looks at all directories specified using the DIRS array, allows user to fuzzy find
selected=$(fd --type=dir --max-depth=1 --full-path --hidden --exclude ".git" --exclude ".cache" --exclude ".vim" . "${DIRS[@]}" |
  sed "s|^$HOME/||" |
  sk --color bw --ansi --reverse --prompt="λ ")
[[ $selected ]] && selected="$HOME/$selected"

# if no directory is selected, exit
[[ ! $selected ]] && exit 0

# setting name for tmux session
selected_name=$(basename "$selected" | tr . _)

# if session does not exist
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
  # create session
  tmux new-session -ds "$selected_name" -c "$selected"
fi

# if tmux is already running, switch to selected session
if [[ -n $TMUX ]]; then
  tmux switch-client -t "$selected_name"
else
  # if not, attach to selected session
  tmux attach -t "$selected_name"
fi

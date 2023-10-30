#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "$HOME/repos/" "$HOME/workspace/" "$HOME/.config" "$HOME/godot" "$HOME/work" "$HOME/.local/share/" "$HOME/polytech/" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

# selected_name=$(basename "$selected" | tr . _)
# tmux_running=$(pgrep tmux)

# if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
#     tmux new-session -s "$selected_name" -c "$selected"
#     exit 0
# 
# fi
#  

# if ! tmux has-session -t="$selected_name" 2> /dev/null; then
#     tmux new-session -ds "$selected_name" -c "$selected"
# fi

# tmux switch-client -t "$selected_name"

selected_name=$(basename "$selected" | tr . _)
 tmux_running=$(pgrep tmux)

 # tmux is not running
 if [[ -z $tmux_running ]]; then
     tmux new-session -s $selected_name -c "$selected"
     exit 0
 fi

 # tmux is running but client is not attached, session with selected_name does not exist
 if [[ -z $TMUX ]] && ! tmux has-session -t=$selected_name 2> /dev/null; then
     tmux new-session -s $selected_name -c "$selected"
     tmux a -t $selected_name
     exit 0
 fi

 # tmux is running but client is not attached, session with selected_name exists
 if [[ -z $TMUX ]] && tmux has-session -t=$selected_name 2> /dev/null; then
     tmux a -t $selected_name
     exit 0
 fi

 # tmux is running and client is attached, session with selected_name does not exist
 if [[ ! -z $TMUX ]] && ! tmux has-session -t=$selected_name 2> /dev/null; then
     tmux new-session -ds $selected_name -c "$selected"
     tmux switch-client -t $selected_name
     exit 0
 fi

 # tmux is running and client is attached, session with selected_name exists
 if [[ ! -z $TMUX ]] && tmux has-session -t=$selected_name 2> /dev/null; then
     tmux switch-client -t $selected_name
     exit 0
 fi

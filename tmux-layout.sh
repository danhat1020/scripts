#!/bin/bash

tmux split-window -h -c "#{pane_current_path}"
tmux split-window -v -c "#{pane_current_path}"
tmux resize-pane -R 35
tmux resize-pane -U 10
tmux select-pane -L

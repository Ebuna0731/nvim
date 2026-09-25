#!/bin/sh
[ "$(tmux display -p '#{window_zoomed_flag}')" = 1 ] && tmux resize-pane -Z

W=$(tmux display -p '#{window_width}')
cur=$(tmux display -p -t '{top-right}' '#{pane_width}')
pct=$((cur * 100 / W))

if [ "$pct" -ge 42 ]; then
  next=33
elif [ "$pct" -ge 28 ]; then
  next=22
else
  next=50
fi

tmux resize-pane -t '{left}' -x $((W - W * next / 100 - 1))

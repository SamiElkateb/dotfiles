#!/bin/sh

[ -z "$TMUX_PANE" ] && exit
style=default
case "$1" in
    prod_* )
        style='bg=#111122'
        ;;
    dev_* )
        style='bg=#112222'
        ;;
    none )
        style='bg='
        ;;
    * )
        style='bg=#000035'
        ;;
esac   
tmux select-pane -P "$style" -t "$TMUX_PANE"

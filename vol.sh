#!/bin/env bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute
# $./volume.sh disp

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    bar=$(seq -s "──" $(($volume / 6)) | sed 's/[0-9]//g')
    dunstify -i audio-volume-high -a volume -t 1 -r 300 "  $bar"
}

case $1 in
    up)
 amixer -D pulse sset Master 5%+ > /dev/null
 send_notification
 ;;
    down)
 amixer -D pulse sset Master 5%- > /dev/null
 send_notification
 ;;
    mute)
     # Toggle mute
 amixer -D pulse set Master 1+ toggle > /dev/null
 if is_mute ; then
     dunstify -i /usr/share/icons/Numix/24/status/audio-volume-muted-panel.svg -t 1 -r 300 -u normal "  Muted"
 else
     send_notification
 fi
 ;;
esac

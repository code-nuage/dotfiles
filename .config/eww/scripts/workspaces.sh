#!/bin/bash

update() {
  hyprctl workspaces -j | jq -c .
}

update

socat -U - UNIX-CONNECT:/run/user/1000/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock |
  while read -r line; do
    case "$line" in
      *workspace*)
        update
        ;;
    esac
  done

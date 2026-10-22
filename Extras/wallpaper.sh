#!/bin/bash
# usage: wallpaper.sh next | prev | (no argument = apply the saved wallpaper)

wall_dir="$HOME/.config/innes/current-theme/wallpapers"
state="$HOME/.config/innes/current-wallpaper"

shopt -s nullglob nocaseglob
walls=("$wall_dir"/*.png "$wall_dir"/*.jpg "$wall_dir"/*.jpeg "$wall_dir"/*.webp)
count=${#walls[@]}
[ "$count" -eq 0 ] && exit 1

current=""
[ -f "$state" ] && current="$(cat "$state")"

index=0
for i in "${!walls[@]}"; do
    if [ "${walls[$i]}" = "$current" ]; then
        index=$i
    fi
done

case "$1" in
    next) index=$(( (index + 1) % count )) ;;
    prev) index=$(( (index - 1 + count) % count )) ;;
esac

echo "${walls[$index]}" > "$state"
pkill swaybg || true
swaybg -i "${walls[$index]}" -m fill &
disown

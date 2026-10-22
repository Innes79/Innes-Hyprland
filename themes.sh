#!/bin/bash

installed_themes_dir="/$HOME/.config/innes/themes"
mkdir -p "$home/.config/innes/scripts"
cp "$project_dir/Tools/wallpaper.sh" "$HOME/.config/innes/scripts/wallpaper.sh"
chmod +x "$HOME/.config/innes/scripts/wallpaper.sh" 
theme=distopian





echo "Installing themes"
sudo pacman -S --noconfirm swaybg
mkdir -p "$installed_themes_dir"
echo $themes_dir/*
for dir in "$themes_dir"/*/; do
    dir_name="${dir%/}"
    folder_name="${dir_name##*/}"
    echo "$folder_name"
    backup "$installed_themes_dir/$folder_name"
    mkdir -p "$installed_themes_dir/$folder_name"
done
echo ""
echo ""

cp -r "$themes_dir"/* "$installed_themes_dir"
ln -sfn "$installed_themes_dir/$theme" "$HOME/.config/innes/current-theme"

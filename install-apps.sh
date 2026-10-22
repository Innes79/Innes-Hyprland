#!/bin/bash

set -e

clear
echo $sys_size
echo $terminal_emulator
echo $AUR_helper
echo $app_launcher
echo $taskbar
echo $rofi_source
echo $GPU
echo $AMD_drivers

echo "Creating directories"
mkdir -p ~/.config/hypr/
echo ""
echo""

echo "Editing pacman config files"
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' | sudo tee -a /etc/pacman.conf > /dev/null
fi


echo "Setting variables"
scripts_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &> /dev/null && pwd)"
project_dir="$(dirname -- "$scripts_dir")"
applications_dir="$project_dir/Applications"
templates_dir="$project_dir/Templates"
backups_dir="$project_dir/Backup"
themes_dir="$project_dir/Themes"
echo ""
echo ""

echo "Creating directories"
mkdir -p "$applications_dir" "$backups_dir"
kernel="$(uname -r)"
headers=linux-headers
sleep 1
echo ""
echo ""

backup() {
    if [ -e "$1" ]; then
        mv "$1" "$backups_dir/$(basename "$1").$(date +%Y%m%d-%H%M%S)"
    fi
}



echo "installing dependencies and updating packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git base-devel
echo ""
echo ""

echo "installing hyprland variables and scripts"
sudo pacman -S --noconfirm hyprland
sudo pacman -S --noconfirm hyprlock
echo ""
echo ""


echo "Filling necesary directories"
cd -- "$templates_dir"
backup ~/.config/hypr/hyprland.lua
cp "$templates_dir/keybindings.lua" ~/.config/hypr/Keybindings.lua


if [ "$taskbar" = 1 ]; then
    cp "$templates_dir/eww/hyprland.lua" ~/.config/hypr/hyprland.lua
fi

if [ "$taskbar" = 2 ]; then
    cp "$templates_dir/waybar/hyprland.lua" ~/.config/hypr/hyprland.lua
fi

if [ "$taskbar" = 3 ]; then
    cp "$templates_dir/hyprland.lua" ~/.config/hypr/hyprland.lua
fi


echo ""
echo ""
cd -- "$scripts_dir"
sleep 2




if [ "$terminal_emulator" = 1 ]; then
    sudo pacman -S --noconfirm ghostty
fi

if [ "$terminal_emulator" = 2 ]; then
    sudo pacman -S --noconfirm alacritty
fi

if [ "$terminal_emulator" = 3 ]; then
    sudo pacman -S --noconfirm kitty
fi





if [ "$AUR_helper" = 1 ]; then
    rm -rf "$applications_dir/yay"
    git clone https://aur.archlinux.org/yay.git "$applications_dir/yay"
    cd "$applications_dir/yay"
    makepkg -si --noconfirm
fi

if [ "$AUR_helper" = 2 ]; then
    rm -rf "$applications_dir/yay-bin"
    git clone https://aur.archlinux.org/yay-bin.git "$applications_dir/yay-bin"
    cd "$applications_dir/yay-bin"
    makepkg -si --noconfirm
fi

if [ "$AUR_helper" = 3 ]; then
    rm -rf "$applications_dir/paru"
    git clone https://aur.archlinux.org/paru.git "$applications_dir/paru"
    cd "$applications_dir/paru"
    makepkg -si --noconfirm
fi





if [ "$rofi_source" = y ]; then
    if [ "$app_launcher" = 1 ]; then
        rm -rf "$applications_dir/rofi"
        sudo pacman -S --noconfirm gcc meson ninja pkgconf flex bison check glib2 wayland-protocols
        sudo pacman -S --noconfirm pango cairo glib2 gdk-pixbuf2 startup-notification libxkbcommon libxcb xcb-util xcb-util-wm xcb-util-cursor xcb-imdkit
        git clone --recursive  https://github.com/davatorium/rofi.git "$applications_dir/rofi"
        cd "$applications_dir/rofi"
        meson setup build
        ninja -C build
        sudo ninja -C build install
        cd -- "$scripts_dir"
    fi
fi

if [ "$rofi_source" = n ]; then
    if [ "$app_launcher" = 1 ]; then
        sudo pacman -S --noconfirm rofi
    fi
fi

if [ "$app_launcher" = 2 ]; then
    sudo pacman -S --noconfirm jq
    curl -fsSL https://vicinae.com/install | bash
fi

if [ "$app_launcher" = 3 ]; then
    case "$AUR_helper" in
        1|2) yay -S --noconfirm elephant walker ;;
        3)   paru -S --noconfirm elephant walker ;;
    esac
fi





if [ "$taskbar" = 1 ]; then
    backup ~/.config/eww
    rm -rf ~/eww-git
    rm -rf ~/eww
    cd
    git clone https://aur.archlinux.org/eww-git.git
    cd eww-git
    makepkg -si --noconfirm
    mkdir -p ~/.config/eww
    cd -- "$scripts_dir"
fi

if [ "$taskbar" = 2 ]; then
    sudo pacman -S --noconfirm waybar
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
    backup ~/.config/waybar
    mkdir -p ~/.config/waybar
    cp -r /etc/xdg/waybar/* ~/.config/waybar/
fi





if [ "$GPU" = 1 ]; then
    if [ "$AMD_drivers" = y ]; then
        sudo pacman -S --noconfirm  mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
    fi
    if [ "$AMD_drivers" = n ]; then
        sudo pacman -S --noconfirm mesa vulkan-radeon
    fi
fi





if [ "$GPU" = 2 ]; then
    if [[ "$kernel" == *lts* ]]; then
        headers=linux-lts-headers
    fi
    if [[ "$kernel" == *zen* ]]; then
        headers=linux-zen-headers
    fi
    if [[ "$kernel" == *hardened* ]]; then
        headers=linux-hardened-headers
    fi
    sudo pacman -S --noconfirm "$headers" nvidia-open-dkms
    sudo mkinitcpio -P
fi




if [ "$sys_size" = 1 ]; then
    echo "installing small system packages due to your selection"
    sudo pacman -S --noconfirm iwd fastfetch
    sudo pacman -S steam
   
fi

if [ "$sys_size" = 2 ]; then
    echo "installing large system packages due to your selection"
    sudo pacman -S --noconfirm discord iwd prismlauncher fastfetch
    sudo pacman -S steam
   
fi

echo "Finishing"
sudo pacman -Syu --noconfirm


source "$scripts_dir/themes.sh"

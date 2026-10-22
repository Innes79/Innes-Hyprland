#!/bin/bash
clear


echo "What size of system would you like to install (benefits are listed in information file)"
echo "1. small"
echo "2. large"
while true; do
    read -r  -n 1 -p "[1 or 2]:" sys_size
    echo ""
    case $sys_size in
        1|2) break ;;
        *) echo "Invalid. Please enter 1 or 2." ;;
    esac
done
echo ""
echo ""


echo "What terminal-emulator"
echo "1. ghostty"
echo "2. alacritty"
echo "3. kitty"
echo "4. none"
while true; do
    read -r  -n 1 -p "[1, 2, 3 or 4]:" terminal_emulator
    echo ""
    case $terminal_emulator in
        1|2|3|4) break ;;
        *) echo "Invalid. Please enter 1, 2, 3, or 4." ;;
    esac
done
echo ""
echo ""


echo "What AUR helper"
echo "1. yay"
echo "2. yay-bin"
echo "3. paru"
echo "4. none"
while true; do
    read -r  -n 1 -p "[1, 2, 3 or 4]:" AUR_helper
    echo ""
    case $AUR_helper in
        1|2|3|4) break ;;
        *) echo "Invalid. Please enter 1, 2, 3, or 4." ;;
    esac
done
echo ""
echo ""

while true; do
    echo "What app-launcher"
    echo "1. rofi"
    echo "2. vicinae"
    echo "3. walker (requires aur helper)"
    echo "4. none"
    while true; do
        read -r  -n 1 -p "[1, 2, 3 or 4]:" app_launcher
        echo ""
        case $app_launcher in
            1|2|3|4) break ;;
            *) echo "Invalid. Please enter 1, 2, 3, or 4." ;;
        esac
    done

    if [ "$app_launcher" != 3 ] || [ "$AUR_helper" != 4 ]; then
        break
    fi

    echo ""
    while true; do
        read -r  -n 1 -p "would you like to not use walker [1] or change AUR helper [2]:" walker_conflict
        echo ""
        echo ""
        case $walker_conflict in
            1|2) break ;;
            *) echo "Invalid. Please enter 1 or 2" ;;
        esac
    done


    if [ "$walker_conflict" = 2 ]; then
        echo ""
        echo ""

        echo "What AUR helper"
        echo "1. yay"
        echo "2. yay-bin"
        echo "3. paru"
        echo "4. none"
        while true; do
            read -r  -n 1 -p "[1, 2, 3 or 4]:" AUR_helper
            echo ""
            case $AUR_helper in
                1|2|3|4) break ;;
                *) echo "Invalid. Please enter 1, 2, 3, or 4." ;;
            esac
        done
    fi
done

echo ""
echo ""

if [ "$app_launcher" = 1 ]; then
    while true; do
        read -r  -n 1 -p "would you like to build from source [y/n]:" rofi_source
        echo ""
        case $rofi_source in
            y|n) break ;;
            *) echo "Invalid. Please enter y or n" ;;
        esac
    done
fi

echo "What taskbar application"
echo "1. EWW"
echo "2. waybar"
echo "3. none"
while true; do
    read -r  -n 1 -p "[1, 2 or 3]:" taskbar
    echo ""
    case $taskbar in
        1|2|3) break ;;
        *) echo "Invalid. Please enter 1, 2 or 3." ;;
    esac
done
#echo $sys_size
#echo $terminal_emulator
#echo $AUR_helper
#echo $app_launcher
#echo $taskbar

echo ""
echo ""
echo -e "nothing has been done to your system yet\nif you wish to continue accept this\n"
while true; do
    read -r  -n 1 -p "accept [y/n]:" confirm_changes
    echo ""
    case $confirm_changes  in
        y) break ;;
        n) clear; echo "ok"; sleep 2.5;clear; exit ;;
        *) echo "Invalid. Please enter y or n" ;;
    esac
done
export sys_size terminal_emulator AUR_helper app_launcher taskbar rofi_source GPU AMD_drivers
bash install-apps.sh

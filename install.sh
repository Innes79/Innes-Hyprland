#!/bin/bash
clear
echo "My HyDE"
echo ""
echo "Welcome to The INNES project, press enter:"
read -p ""
clear


echo "what brand is your gpu"
echo "1. AMD"
echo "2. Nvidia"
echo "3. none"
while true; do
    read -r  -n 1 -p "[1, 2 or 3]" GPU
    echo ""
    case $GPU in
        1|2|3) break ;;
        *) echo "Invalid. Please enter 1, 2 or 3.." ;;
    esac
done

if [ "$GPU" = 1 ]; then
    echo "would you like game ready drivers or just base drivers"
    while true; do
        read -r  -n 1 -p "[y/n]" AMD_drivers
        echo ""
        case $AMD_drivers in
            y|n) break ;;
            *) echo "Invalid. Please enter y or n." ;;
        esac
    done
fi
echo "drivers will be installed based on your gpu later"
echo "if your gpu is not listed install it manually before running this script (ctrl + c)"



read -p "press enter to resume"
clear


export GPU AMD_drivers
bash config.sh


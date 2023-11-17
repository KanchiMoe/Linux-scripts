#!/bin/bash

MSG_S="\e[32m[✓]\e[0m"
MSG_F="\e[31m[✗]\e[0m"
MSG_I="\e[38;5;39m[-]\e[0m"
windows_path="$APPDATA\\syncplay.ini"
linux_path=".config"

function check_os {
    if [ "$(uname)" == "Linux" ]; then
        echo -e "$MSG_I Operating System: Linux"
        linux_check_syncplay_installed
    elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
        echo -e "$MSG_I Operating System: Windows"
        windows_check_syncplay
    else
        echo "\e[31m[✗]\e[0m Unsupported operating system."
    fi
}

function linux_check_syncplay_installed {
    if pacman -Qs syncplay >/dev/null 2>&1; then
        echo -e "$MSG_S Syncplay is installed"
        linux_check_syncplay_opened
    else
        echo "is not installed"
    fi
}

function linux_check_syncplay_opened {
    linux_path="$HOME/$linux_path"
    if [ -f "$linux_path/syncplay.ini" ]; then
        echo -e "$MSG_S Syncplay.ini exists"
    else
        echo -e "$MSG_F Syncplay.ini exists. Open Syncplay at least once and try again."
    fi
}

function windows_check_syncplay {
    if [ -e "$windows_path" ]; then
        echo -e "\e[32m[✓]\e[0m Syncplay.ini exists."
        windows_check_server_host
    else
        echo -e "\e[31m[✗]\e[0m Syncplay.ini does not exist."
    fi
}

function windows_check_server_host {
    if grep -qE "host\s*=\s*syncplay.pl" "$windows_path"; then
        echo -e "\e[32m[✓]\e[0m Host is set to syncplay.pl"
        windows_check_server_port
    else
        echo -e "\e[31m[✗]\e[0m Host is not set to syncplay.pl. Correcting..."
        sed -i 's/\(host\s*=\s*\S\+\)/host = syncplay.pl/' "$windows_path"
        windows_check_server_host
    fi
}

function windows_check_server_port {
    if grep -qE "port\s*=\s*8998" "$windows_path"; then
        echo -e "\e[32m[✓]\e[0m Port is set to 8998"
        windows_check_server_password
    else
        echo -e "\e[31m[✗]\e[0m Port is not 8998. Correcting..."
        sed -i 's/\(port\s*=\s*\S\+\)/port = 8998/' "$windows_path"
        windows_check_server_port
    fi
}

function windows_check_server_password {
    if grep -qE "password\s*=\s*None" "$windows_path"; then
        echo -e "\e[32m[✓]\e[0m No password is set"
    else
        echo -e "\e[31m[✗]\e[0m A password is detected, unsetting..."
        sed -i 's/\(password\s*=\s*\S\+\)/password = None/' "$windows_path"
        windows_check_server_password
    fi
}

check_os

# Keep the terminal open
read -p "Press Enter to exit..."

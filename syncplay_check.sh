#!/bin/bash

windows_path="$APPDATA\\syncplay.ini"

function check_os {
    if [ "$(uname)" == "Linux" ]; then
        echo -e "\e[38;5;39m[-]\e[0m Operating System: Linux"
    elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
        echo -e "\e[38;5;39m[-]\e[0m Operating System: Windows"
        windows_check_syncplay
    else
        echo "\e[31m[✗]\e[0m Unsupported operating system."
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

#!/bin/bash

DEBUG_MSGS=true

# Echo prefixes
MSG_S="\e[32m[✓]\e[0m"
MSG_F="\e[31m[✗]\e[0m"
MSG_I="\e[38;5;39m[-]\e[0m"

echo "$MSG_I Updating Discord..."

DiscordYumUpdate() {
    echo "$MSG_I Updating Discord using yum..."
    sudo yay -Sy discord --noconfirm
    echo "$MSG_S Discord updated successfully!"
}

# Check if Discord is running first
if pgrep -x "Discord" > /dev/null; then
    DISCORD_RUNNING=true
    [ "$DEBUG_MSGS"=true ] && echo "$MSG_I Discord is running."
else
    DISCORD_RUNNING=false
    [ "$DEBUG_MSGS"=true ] && echo "$MSG_I Discord is not running."
fi

case "$DISCORD_RUNNING" in
    true)
        [ "$DEBUG_MSGS"=true ] && echo "$MSG_I Killing Discord..."
        pkill Discord
        sleep 1

        # Check if Discord closed
        if pgrep -x "Discord" > /dev/null; then
            [ "$DEBUG_MSGS"=true ] && echo "$MSG_F Failed to close Discord."
            exit 1
        else
            [ "$DEBUG_MSGS"=true ] && echo "$MSG_S Discord closed successfully"
        fi
        DiscordYumUpdate
        ;;
    false)
        DiscordYumUpdate
        ;;
    *)
        echo "$MSG_S Unknown status."
        ;;
esac

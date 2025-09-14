#!/usr/bin/env bash

# Set theme based on argument or time of day

set_theme() {
    local theme_type=$1
    # Wait for the user's graphical session to be ready
    # export DISPLAY=:0
    # export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

    if [[ "$theme_type" == "light" ]]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    elif [[ "$theme_type" == "dark" ]]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    fi
}

if [[ -n "$1" ]]; then
    # If an argument is provided (light/dark), use it.
    set_theme "$1"
else
    # Otherwise, determine theme based on the current hour.
    hour=$(date +%H)
    if (( hour >= 8 && hour < 18 )); then
        set_theme "light"
    else
        set_theme "dark"
    fi
fi

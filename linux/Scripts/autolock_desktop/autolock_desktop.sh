#!/bin/bash

varCurrentIP=$(ifconfig)
varHome=$(echo $varCurrentIP | grep -c 10.10.10.10)

echo "ifconfig contents: $varCurrentIP"
 
if [[ $varHome -eq 0 ]]; then
    #gsettings set org.gnome.desktop.session idle-delay 120
    gsettings set org.cinnamon.desktop.session idle-delay 120
    echo "idle-delay set to 120 seconds"
else
    #gsettings set org.gnome.desktop.session idle-delay 0
    gsettings set org.cinnamon.desktop.session idle-delay 0
    echo "idle-delay disabled"
fi

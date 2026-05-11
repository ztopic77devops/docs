## this script will keep your laptop unlocked on your local network and lock it after 2 minutes on every other network

# create a script with content:

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


##############################################################

# create systemd service

mkdir -p ~/.config/systemd/user

vim ~/.config/systemd/user/autolock.service

# add

[Unit]
Description=Autolock Script

[Service]
Type=simple
ExecStart=/home/<user>/<path-to>/autolock_desktop.sh
Restart=on-failure

[Install]
WantedBy=default.target

##############################################################

# make script executable

chmod +x /home/<user>/<path-to>/autolock_desktop.sh

# reload systemd

systemctl --user daemon-reload

# enable at login

systemctl --user enable autolock.service

# start service

systemctl --user start autolock.service

# check status

systemctl --user status autolock.service

# logs

journalctl --user -u autolock.service -f

# Ubuntu 22.04 LTS, virtual display

## First, install xserver-xorg-video-dummy package
```
apt install xserver-xorg-video-dummy
```

## Create config file /usr/share/X11/xorg.conf.d/dummy-1920x1080.conf
```
Section "Monitor"
  Identifier "Monitor0"
  HorizSync 28.0-80.0
  VertRefresh 48.0-75.0
  # https://arachnoid.com/modelines/
  # 1920x1080 @ 60.00 Hz (GTF) hsync: 67.08 kHz; pclk: 172.80 MHz
  Modeline "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
EndSection

Section "Device"
  Identifier "Card0"
  Driver "dummy"
  VideoRam 256000
EndSection

Section "Screen"
  DefaultDepth 24
  Identifier "Screen0"
  Device "Card0"
  Monitor "Monitor0"
  SubSection "Display"
    Depth 24
    Modes "1920x1080_60.00"
  EndSubSection
EndSection
```

## Make sure there are no running xservers. To close an existing xserver, stop the GDM using it. Optionally, disable it.
```
systemctl stop gdm
systemctl disable gdm
```

## Start xserver with the newly created config
```
sudo X -config /usr/share/X11/xorg.conf.d/dummy-1920x1080.conf
```

## or to choose which display number you are going to use, use
```
sudo X :0 -config /usr/share/X11/xorg.conf.d/dummy-1920x1080.conf
```

## Create /home/<user>/.startDummyDisplay.sh script with ubuntu as owner and 755 permissions
```
#!/bin/bash

X :10.0 -config /usr/share/X11/xorg.conf.d/dummy-1920x1080.conf
```

## Create /lib/systemd/system/dummyDisplay.service file with root as owner and 644 permissions
```
[Unit]
Description=Dummy X11 server

[Service]
ExecStart=/home/ubuntu/.startDummyDisplay.sh

[Install]
WantedBy=multi-user.target
```

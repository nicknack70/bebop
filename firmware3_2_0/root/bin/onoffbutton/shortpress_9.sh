#!/bin/sh

echo "Restoring pristine files" | logger -s -t "Shortpress_9" -p user.info

# Red-Orange-Green LED 
(BLDC_Test_Bench -G 1 0 0 >/dev/null; sleep 2; BLDC_Test_Bench -G 1 1 0 >/dev/null; sleep 2; BLDC_Test_Bench -G 0 1 0 >/dev/null) &

# Remount filesystem with wrirte permissions
Mount -o remount,rw /

# Copy saved files over edited/damaged files
### adjust this list to your own needs ###
cp /data/ftp/internal_000/emergency/dragon_shell.sh /bin/dragon_shell.sh
cp /data/ftp/internal_000/emergency/dragon.conf /data/dragon.conf
cp /data/ftp/internal_000/emergency/system.conf /data/system.conf
cp /data/ftp/internal_000/emergency/DragonStarter.sh /usr/bin/DragonStarter.sh
cp -R /data/ftp/internal_000/emergency/onoffbutton /bin/

# Red-Orange-Red LED
(BLDC_Test_Bench -G 1 0 0 >/dev/null; sleep 2; BLDC_Test_Bench -G 1 1 0 >/dev/null; sleep 2; BLDC_Test_Bench -G 1 0 0 >/dev/null; sleep 2) &

# reboot
./bin/reboot.sh &
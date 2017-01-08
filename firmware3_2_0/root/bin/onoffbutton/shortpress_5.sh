#! /bin/sh
# This script copies your media files to an external USB stick
# Red LED = script starts
(BLDC_Test_Bench -G 1 0 0 >/dev/null) &
 
INT_MEM_DIRECTORY=/data/ftp/internal_000/
BOP_MEDIA_DIRECTORY=/data/ftp/internal_000/Bebop_Drone/media/
USB_OTG_DIRECTORY=
 
# search for USB OTG directory using pattern *_nnn
for directory in $(find /data/ftp/ -maxdepth 1 -type d -regex ".*_[0-9][0-9]*"); do
       if [ "$directory/" != "$INT_MEM_DIRECTORY"Bebop_Drone/media/ ]; then
       USB_OTG_DIRECTORY="$directory"/Bebop_Drone/media/
       break
       fi
done
 
# copy the files if we have USB OTG drive mounted
if [ -d "$USB_OTG_DIRECTORY" ]; then
       echo "Moving media to USB OTG drive ($USB_OTG_DIRECTORY)..."
       # Orange LED during copy
       (BLDC_Test_Bench -G 1 1 0 >/dev/null) &

       cp -f "$BOP_MEDIA_DIRECTORY"* "$USB_OTG_DIRECTORY"
       # Green LED = copy finished
       (BLDC_Test_Bench -G 0 1 0 >/dev/null) &
       #creates copy_ok file when the copy process is finished
       touch "$INT_MEM_DIRECTORY"Bebop_Drone/copy_ok
else
       echo "USB OTG drive not mounted!"
       # Red LED flashes  to notify the error
       (BLDC_Test_Bench -G 1 0 0 >/dev/null; usleep 100000; BLDC_Test_Bench -G 0 0 0 >/dev/null; usleep 100000; BLDC_Test_Bench -G 1 0 0 >/dev/null; usleep 100000; BLDC_Test_Bench -G 0 0 0 >/dev/null; usleep 100000; BLDC_Test_Bench -G 1 0 0 >/dev/null; usleep 100000; BLDC_Test_Bench -G 0 0 0 >/dev/null; usleep 100000; BLDC_Test_Bench -G 0 1 0 >/dev/null)&

fi

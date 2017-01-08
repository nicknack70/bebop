#! /bin/sh
# Red LED = script starts
(BLDC_Test_Bench -G 1 0 0 >/dev/null) &

INTERNAL_MEMORY_DIRECTORY=/data/ftp/internal_000/
MEDIA_DIRECTORY="$INTERNAL_MEMORY_DIRECTORY"Bebop_Drone/media/
USB_OTG_DIRECTORY=

# search for USB OTG directory using pattern *_nnn
for directory in $(find /data/ftp/ -maxdepth 1 -type d -regex "*_[0-9][0-9]*"); do
   if [ "$directory/" != "$INTERNAL_MEMORY_DIRECTORY" ]; then
       USB_OTG_DIRECTORY="$directory/"
       break
   fi
done

# copy the files if we have USB OTG drive mounted
if [ -d "$USB_OTG_DIRECTORY" ]; then
   echo "Copying media to USB OTG drive ($USB_OTG_DIRECTORY)..."
   # Orange LED during copy
   (BLDC_Test_Bench -G 1 1 0 >/dev/null) &

   cp -f "$MEDIA_DIRECTORY"* "$USB_OTG_DIRECTORY"
   # Green LED = copy finished
   (BLDC_Test_Bench -G 0 1 0 >/dev/null) &
else
   echo "USB OTG drive not mounted!"
   # Red LED flashes for 3 seconds
   (BLDC_Test_Bench -G 1 0 1 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &

fi
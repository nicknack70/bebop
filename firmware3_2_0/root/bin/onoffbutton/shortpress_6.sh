#! /bin/sh
# This script deletes your media files if they have previously been copied to a USB stick
# Red LED = script starts 
(BLDC_Test_Bench -G 1 0 0 >/dev/null) &

INT_BOP_DIR=/data/ftp/internal_000/Bebop_Drone/

if [ -e "$INT_BOP_DIR"copy_ok ]; then
   echo "Previous copy was successful"
   # delete the files
   echo "Deleting contents of media directory"
   # Orange LED flashing during deletion
   (BLDC_Test_Bench -G 1 1 1 >/dev/null) &
   # delete all media files 
   rm -R "$INT_BOP_DIR"thumb/*
   # delete all thumb files
   rm -R "$INT_BOP_DIR"media/*
   # delete file copy_ok  
   rm -f "$INT_BOP_DIR"copy_ok
   # Green LED flashes= delete OK
   (BLDC_Test_Bench -G 0 1 1 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &
else
	echo "Media were not previously copied! Nothing has been deleted"
	# Red LED flashes for 3 seconds
(BLDC_Test_Bench -G 1 0 1 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &
 
fi
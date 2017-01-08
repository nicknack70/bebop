#! /bin/sh
# Red LED = script starts
(BLDC_Test_Bench -G 1 0 0 >/dev/null) &

if [ -e /data/ftp/internal_000/copy_ok ]; then
   echo "Previous copy was successful"
   # delete the files
   echo "Deleting contents of media directory"
   # Orange LED flashing during deletion
   (BLDC_Test_Bench -G 1 1 1 >/dev/null) &

   rm -R "$MEDIA_DIRECTORY"*
   # delete copy_ok file
   rm -f /data/ftp/internal_000/copy_ok
   # Green LED flashes= delete OK
   (BLDC_Test_Bench -G 0 1 1 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &
else
    echo "Media were not previously copied! Nothing has been deleted"
    # Red LED flashes for 3 seconds
(BLDC_Test_Bench -G 1 0 1 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &

fi
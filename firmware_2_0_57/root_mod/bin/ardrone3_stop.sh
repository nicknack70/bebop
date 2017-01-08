#!/bin/sh

source /bin/ardrone3_shell.sh
source /sbin/emmc_lib.sh

eMMC_is_mounted ${ARDRONE3_MOUNT_PATH}
mmcOK=$?
pipe="/tmp/.dragon-pipe-in"
pipe_msg="dragon_shutdown"

#redirect coredump to /tmp to avoid fake coredumps due to shutdown
echo "/tmp/core/%e.%p" > /proc/sys/kernel/core_pattern

# Shut down the GPS
echo '!' > /tmp/gps_debug &

# Shutdown Dragon Prog
echo "Shutdown Dragon" | logger -s -t "shutdown" -p user.info
pid=$(pidof dragon-prog)
if [ $? -eq 0 ]
then
  # Send a message to Dragon for a clean stop
  echo "Asking Dragon to stop..." | logger -s -t "shutdown" -p user.info
  if [ -p $pipe ]
  then
    echo $pipe_msg > $pipe &
  fi
  i=0
  # Wait for Dragon to stop
  while kill -0 $pid 2> /dev/null; do
    if [ $i -gt 3 ]
    then
      echo "Timeout" | logger -s -t "shutdown" -p user.info
      break
    fi
    sleep 1
    i=$(($i+1))
  done  
fi
# We timed out the clean stop. Kill Dragon.
pid=$(pidof dragon-prog)
if [ $? -eq 0 ]
then
  killall -KILL dragon-prog
fi

if [ ${mmcOK} -eq 0 ]
then
  # stopping all processes using eMMC
  echo "Stopping users of eMMC" | logger -s -t "shutdown" -p user.info
  eMMC_release ${ARDRONE3_MOUNT_PATH}
fi

# Synchronise filesystems
echo "Synchronise filesystems" | logger -s -t "shutdown" -p user.info
sync
echo "3" > /proc/sys/vm/drop_caches

# umount all filesystems

# umount eMMC
[ ${mmcOK} -eq 0 ] && eMMC_umount

# umount NAND flash partitions
umount /update
umount /data
umount /factory

# remount / as read-only
mount -o remount,ro /

# Script to reboot the ardrone3 clean
bcmwl reboot

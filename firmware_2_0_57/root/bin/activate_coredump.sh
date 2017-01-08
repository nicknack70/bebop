#!/bin/sh
# source this script to activate coredump
# source /usr/bin/activate_coredump.sh
source /bin/ardrone3_shell.sh
source /sbin/emmc_lib.sh

eMMC_is_mounted ${ARDRONE3_MOUNT_PATH}
mmcOK=$?

echo "Activate coredump..." | logger -s -t "Debug" -p user.info
if [ ${mmcOK} -eq 0 ]
then
  coredir="${ARDRONE3_CORES_PATH}"
  mkdir -p ${coredir}
  echo "${coredir}/%e.%p" > /proc/sys/kernel/core_pattern | logger -s -t "Debug" -p user.info
fi
echo "Core pattern: $(cat /proc/sys/kernel/core_pattern)" | logger -s -t "Debug" -p user.info
ulimit -c unlimited
ulimit -a | grep core

#no exit because this script has to be sourced

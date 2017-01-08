#! /bin/sh

source /bin/ardrone3_shell.sh
source /sbin/emmc_lib.sh
source /sbin/debug_lib.sh

# Creating debug folder
DEBUG_CreateDir

config="/etc/debug.conf"

eMMC_is_mounted ${ARDRONE3_MOUNT_PATH}
mmcOK=$?
if [ -f ${config} ]
then
  echo "Setting debug" | logger -s -t "Debug" -p user.info
  dmesg_level=1
  source ${config}
  dmesg -n ${dmesg_level}
  # we should redirect syslog to ulogger
  /usr/bin/ckcmd_redirect.sh

  [ ${start_telnetd} -eq 1 ] && telnetd -l /bin/login.sh  # Start telnet deamon
  [ ${start_adbd} -eq 1 ] && adbd.sh &  # Start ADB deamon
  [ ${dynamic_debug} -eq 1 -a ${mmcOK} -eq 0 ] && /usr/bin/dynamic_debug.sh
  [ ${kmemleak} -eq 1 -a ${mmcOK} -eq 0 ] && /usr/bin/kmemleak.sh
  [ ${meminfo} -eq 1 -a ${mmcOK} -eq 0 ] && /usr/bin/meminfo.sh
  [ ${ckcmd} == "tcp" -o ${ckcmd} == "both" -o ${ckcmd} == "file" ] && /usr/bin/ckcm_log.sh $ckcmd
  [ ${BLACKBOX} -eq 1 -a ${mmcOK} -eq 0 ] && mkdir -p $ARDRONE3_BLACKBOX_PATH
fi

echo "Debug is set" | logger -s -t "Debug" -p user.info

exit 0

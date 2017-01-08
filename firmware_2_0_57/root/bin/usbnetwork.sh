#!/bin/sh

echo "Activating Network over USB..." | logger -s -t "NetworkUSB" -p user.info

dir="/sys/devices/virtual/android_usb/android0"
functions=${dir}/functions
interface="rndis0"
ipaddr="192.168.43.1"

grep -q "rndis" ${functions}
if [ $? -ne 0 ]
then
  f=$(cat ${functions})
  if [ "z${f}Z" != "zZ" ]
  then
    f="${f},rndis"
  else
    f="rndis"
  fi
  echo 0 > ${dir}/enable
  echo ${f} > ${functions}
  echo 1 > ${dir}/enable
  echo "rndis enabled" | logger -s -t "NetworkUSB" -p user.info
else
  echo "rndis already enabled" | logger -s -t "NetworkUSB" -p user.info
fi

tmpfile="/tmp/.${interface}.log"
ifconfig ${interface} >${tmpfile}
if [ $? -ne 0 ]
then
  echo "Network over USB activating..." | logger -s -t "NetworkUSB" -p user.info
  ifconfig ${interface} up
  ifconfig ${interface} ${ipaddr}
  udhcpd /etc/udhcpd.conf.${interface} &
  echo "Network over USB activated" | logger -s -t "NetworkUSB" -p user.info
else
  echo "Network over USB reactivating..." | logger -s -t "NetworkUSB" -p user.info
  grep -q "UP " ${tmpfile}
  [ $? -ne 0 ] && ifconfig ${interface} up
  grep -q "inet addr:${ipaddr}" ${tmpfile}
  [ $? -ne 0 ] && ifconfig ${interface} ${ipaddr}
  ps|grep -q "[u]dhcpd /etc/udhcpd.conf.${interface}"
  if [ $? -ne 0 ]
  then
    udhcpd /etc/udhcpd.conf.${interface} &
  fi
  echo "Network over USB reactivated" | logger -s -t "NetworkUSB" -p user.info
fi

exit 0

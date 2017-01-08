#!/bin/sh

echo "Button activating..." | logger -s -t "ShortPressDebug" -p user.info
/bin/usbnetwork.sh

pid=$(pidof telnetd)
if [ $? -ne 0 ]
then
  /usr/sbin/telnetd -l /bin/login.sh
fi

echo "Button activated" | logger -s -t "ShortPressDebug" -p user.info

#!/bin/sh

echo "Button activating..." | ulogger -t "ShortPressDebug" -p I
/bin/usbnetwork.sh
echo "Button activated" | ulogger -t "ShortPressDebug" -p I
echo "activating read-write permissions"
mount -o remount,rw /
echo "write permissions active"
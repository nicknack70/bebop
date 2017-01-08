#!/bin/sh

echo "Restarting Dragon for FPV" | logger -s -t "ShortPress_3" -p user.info

# Red LED for 2 seconds
(BLDC_Test_Bench -G 1 0 0 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &

kill -9 `ps | grep dragon | grep '/' | awk '{print $1}'`

/usr/bin/dragon-prog -S 0 -s 1024x520 -V 115 -I off &

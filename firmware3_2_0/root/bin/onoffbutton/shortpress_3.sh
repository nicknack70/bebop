#!/bin/sh

echo "Restarting Dragon" | logger -s -t "Shortpress 3" -p user.info

# Red LED for 3 seconds
(BLDC_Test_Bench -G 1 0 0 >/dev/null; sleep 3; BLDC_Test_Bench -G 0 1 0 >/dev/null) &

kill -9 `ps | grep dragon | grep '/' | awk '{print $1}'`

/usr/bin/dragon-prog&

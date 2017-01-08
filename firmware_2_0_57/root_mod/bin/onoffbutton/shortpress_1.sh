#!/bin/sh
# Script called when pressing the ON/OFF button once

echo "Triggered shutdown" | logger -s -t "ShortPress" -p user.info

/bin/ardrone3_shutdown.sh

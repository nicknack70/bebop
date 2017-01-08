#!/bin/sh

# Blink orange/green while stopping all properly
(
  while true
  do
    BLDC_Test_Bench -G 1 1 0 >/dev/null 2>&1 # orange
    usleep 100000				 # flash 0.1 second
    BLDC_Test_Bench -G 0 1 0 >/dev/null 2>&1 # back to green
    usleep 100000				 # flash 0.1 second
  done
) &

/bin/ardrone3_stop.sh

# Make the Cypress chip turn off the GPIO which keeps the P7 alive at reboot
/usr/bin/BLDC_Test_Bench -G 0 0 0 >/dev/null 2>&1

# Call the system reboot procedure
unalias reboot
reboot

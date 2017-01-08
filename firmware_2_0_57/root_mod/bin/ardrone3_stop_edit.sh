#!/bin/sh
#
# Changes for ardrone3_stop.sh - v2.0.57
#

# add the following not-commented lines after the shutdown gps/echo lines in the ardrone3_stop.sh script

gps_file_path=/data/ftp/internal_000/log/
gps_file=furuno-nmea-out.txt
#gps_file_path=/home/gord/dev/furuno2057/
#gps_file="furuno-nmea-out.txt"

#So, check for furuno-nmea-out.txt, if exists, mv furuno-nmea-out.txt  furuno-nmea-out-`extract_rmc_date.sh furuno-nmea-out.txt`.txt. 
#echo ${gps_file_path}
#echo ${gps_file}

if [ -e ${gps_file_path}${gps_file}  ] 
then
  new_gps_filename="furuno-nmea-out-`/bin/extract_rmc_date.sh ${gps_file_path}${gps_file}`.txt"
  #echo ${gps_file_path}${new_gps_filename}
  mv ${gps_file_path}${gps_file} ${gps_file_path}${new_gps_filename}
fi
echo "====== DEMO USB FLASHING SCRIPT ====="


usbcounter=$(lsusb | wc -l)

if [ "$usbcounter" != "3" ];
then
echo "USB device detected !"
while [ ! -e /dev/sda ]; do echo "Waiting for USB key..."; sleep 1; done
fi

if [ -e /dev/sda ]; then
echo
echo "==== Updating demo settings from USB key ===="
echo

while [ ! -e /tmp/udev/dev/sda ]; do echo "Waiting for USB key to be mounted..."; sleep 1; done
umount /tmp/udev/dev/sda1 2> /dev/null
mkdir -p /usb
mount /tmp/udev/dev/sda1 /usb
if [ $? -ne 0 ]
then
    umount /tmp/udev/dev/sda 2> /dev/null
    mount /tmp/udev/dev/sda /usb
fi

if [ -e /usb/ardrone ]
then
    echo " - ARDrone directory found"
    if [ -d /usb/ardrone/skel ]
    then
        echo "Copying files from skel..."

        cp /usb/ardrone/skel/dragon-prog /usr/bin/dragon-prog

        cp /usb/ardrone/skel/demo.xml /data/demo.xml

        mkdir -p /data/video
        cp -R /usb/ardrone/skel/magic_c*.txt /data/video/

        mkdir -p /data_us
        cp /usb/ardrone/skel/default-config.xml /data_us/
        cp /usb/ardrone/skel/threshold_0.txt /data_us/
        cp /usb/ardrone/skel/threshold_1.txt /data_us/

        sync

        BLDC_Test_Bench -G 1 1 0 > /dev/null; usleep 500000;  BLDC_Test_Bench -G 0 0 0 > /dev/null; usleep 500000;
        BLDC_Test_Bench -G 1 1 0 > /dev/null; usleep 500000;  BLDC_Test_Bench -G 0 0 0 > /dev/null; usleep 500000;
        BLDC_Test_Bench -G 1 1 0 > /dev/null; usleep 500000;  BLDC_Test_Bench -G 0 0 0 > /dev/null; usleep 500000;

        BLDC_Test_Bench -G 0 1 0 > /dev/null;
    fi
fi

umount /usb
fi

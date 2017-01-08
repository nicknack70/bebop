#! /bin/sh
grep -q debugfs /proc/mounts || mount -t debugfs none /sys/kernel/debug
modprobe avi_debugfs

def_iface="usb_eth"
def_remote_date="192.168.42.2"
def_remote_srv="192.168.42.2"
def_remote_path="/srv/nfs"
def_mount_point="/mnt"

iface=${def_iface}
remote_date=${def_remote_date}
remote_srv=${def_remote_srv}
remote_path=${def_remote_path}
mount_point=${def_mount_point}

O=$(getopt -- i:d:s:m:p:a:h ``$@'') || exit 1
eval set -- "$O"
while true
do case "$1" in
    -i)  iface="$2";shift 2;;
    -d)  remote_date="$2";shift 2;;
    -s)  remote_srv="$2";shift 2;;
    -a)  remote_date="$2";remote_srv="$2";shift 2;;
    -m)  mount_point="$2";shift 2;;
    -p)  remote_path="$2";shift 2;;
    --)  shift;break;;
    -h)
      printf "Usage: $0 [options]\n" >&2
      printf "\t-i <interface> [default: %s]\n" ${def_iface} >&2
      printf "\t-d <rdate server IP> [default: %s]\n" ${def_remote_date} >&2
      printf "\t-s <NFS server IP> [default: %s]\n" ${def_remote_srv} >&2
      printf "\t-a <rdate/NFS server IP> [default: %s]\n" ${def_remote_srv} >&2
      printf "\t-p <NFS remote path> [default: %s]\n" ${def_remote_path} >&2
      printf "\t-m <mount point> [default: %s]\n" ${def_mount_point} >&2
      exit 1;;
    esac
done

remote_fs="${remote_srv}:${remote_path}"
[ ! -d ${mount_point} ] && mkdir -p ${mount_point}


ifconfig ${iface} && /bin/asix_setup.sh remove_net_interface && udhcpc --interface ${iface} -S 2>/dev/null

(ping -c2 ${remote_date} >/dev/null && rdate -s ${remote_date} && echo "Date is: $(date -R)") &

grep -q "${remote_fs}" /proc/mounts || (ping -c2 ${remote_srv} >/dev/null && mount -t nfs -o nolock,proto=tcp,addr=${remote_srv} ${remote_fs} ${mount_point} && grep "${remote_path}" /proc/mounts) &

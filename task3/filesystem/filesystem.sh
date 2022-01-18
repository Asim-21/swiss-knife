. ./variables.sh
sudo rm -rf ${mount_ext4}
sudo rm -rf ${mount_btrfs}
mkdir ${mount_ext4}
mkdir ${mount_btrfs}
echo '<--------------------> Formatting Partitions with ext4 and btrfs fs <-------------------->'
. ./format.sh
echo '<--------------------> Running fio on ext4 and btrfs fs <-------------------->'
. ./fio.sh
echo '<--------------------> Running phoronix disk benchmark suite on ext4 fs <--------------------> '
. ./phoronix.sh

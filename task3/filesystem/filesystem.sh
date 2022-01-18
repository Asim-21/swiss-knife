. ./variables
sudo rm -rf ${mount_ext4}
sudo rm -rf ${btrfs}
mkdir ${mount_ext4}
mkdir ${btrfs}
echo '<--------------------> Starting partitioning and creating ext4 and btrfs fs <-------------------->'
. ./format.sh
echo '<--------------------> Running fio on ext4 and btrfs fs <-------------------->'
. ./fio.sh
echo '<--------------------> Running phoronix disk benchmark suite on ext4 fs <--------------------> '
. ./phoronix.sh

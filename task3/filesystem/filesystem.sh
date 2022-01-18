echo '<--------------------> Starting partitioning and creating ext4 and btrfs fs <-------------------->'
. ./format.sh
echo '<--------------------> Running fio on ext4 and btrfs fs <-------------------->'
. ./fio.sh
echo '<--------------------> Running phoronix disk benchmark suite on ext4 fs <--------------------> '
. ./phoronix.sh

#file systems
fs='/dev/mapper/swissknife-teamf'

mount_ext4='ext4'
mount_btrfs='btrfs'

# result directories

random='results_fio/random_'${n}
sequential='results_fio/sequential_'${n}
phoronix='results_phoronix/Disk-benchmarking_'${m}

# output files for FIO
bs_ext4_file=${random}'/bs_ext4'
bs_btrfs_file=${random}'/bs_btrfs'
io_depth_ext4_file=${random}'/io_depth_ext4'
io_depth_btrfs_file=${random}'/io_depth_btrfs'
rw_ext4_file=${random}'/rw_ext4'
rw_btrfs_file=${random}'/rw_btrfs'
bs_ext4_fileIOdirectzero=${random}'/bs_ext4-IOdirectzero'
bs_btrfs_fileIOdirectzero=${random}'/bs_btrfs-IOdirectzero'

bs_ext4_seq=${sequential}'/bs_ext4'
bs_btrfs_seq=${sequential}'/bs_btrfs'
rw_ext4_seq=${sequential}'/rw_ext4'
rw_btrfs_seq=${sequential}'/rw_btrfs'

#fio files
randread='fio/randread.fio'
randread_IOdirect='fio/randread_IOdiect.fio'
randwrite='fio/randwrite.fio'
randrw='fio/randrw.fio'
seqread='fio/seqread.fio'
seqwrite='fio/seqwrite.fio'

blocksize=('4k', '64k', '256k', '2m')
io_depth=('16', '128', '256')


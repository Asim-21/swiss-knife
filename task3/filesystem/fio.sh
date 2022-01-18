echo "<---------------------------> Enter results filename version here (v1 v2 etc.) <--------------------------->"
read n
. ./variables.sh
nix-env -iA nixos.fio

mkdir -p ${random}
mkdir -p ${sequential}

echo "<---------------------------> FIO-Random read/write <--------------------------->"
for ((i=0; i<=3; i=i+1)); do
	echo "running with blocksize = ${blocksize[i]} (Random read, io_depth = 16, IOdirect = 1, numjobs=4)"
	echo "${blocksize[i]} $(sudo fio ${randread} --directory=${mount_ext4} --iodepth=${io_depth[0]} --bs=${blocksize[i]} | tail -n -6 | head -1)" >> ${bs_ext4_file}
	echo "${blocksize[i]} $(sudo fio ${randread} --directory=${mount_btrfs} --iodepth=${io_depth[0]} --bs=${blocksize[i]} | tail -1)" >> ${bs_btrfs_file}
done

for ((i=0; i<=2; i=i+1)); do
	echo "running with io_depth = ${io_depth[i]} (Random read, blocksize=4k, IOdirect = 1, numjobs=4)"
	echo "${io_depth[i]} $(sudo fio ${randread} --directory=${mount_ext4} --iodepth=${io_depth[i]} --bs=${blocksize[0]} | tail -n -6 | head -1)" >> ${io_depth_ext4_file}
	echo "${io_depth[i]} $(sudo fio ${randread} --directory=${mount_btrfs} --iodepth=${io_depth[i]} --bs=${blocksize[0]} | tail -1)" >> ${io_depth_btrfs_file}
done

for ((i=0; i<=3; i=i+1)); do
	echo "running with blocksize = ${blocksize[i]} (Random read, io_depth = 16, IOdirect = 0, numjobs=4)"
	echo "${blocksize[i]} $(sudo fio ${randread-IOdirectzero} --directory=${mount_ext4} --iodepth=${io_depth[0]} --bs=${blocksize[i]} | tail -n -6 | head -1)" >> ${bs_ext4_fileIOdirectzero}
	echo "${blocksize[i]} $(sudo fio ${randread-IOdirectzero} --directory=${mount_btrfs} --iodepth=${io_depth[0]} --bs=${blocksize[i]} | tail -1)" >> ${bs_btrfs_fileIOdirectzero}
done
echo -e "\n" | sh format.sh > /dev/null

for ((i=0; i<=3; i=i+1)); do
	echo "running with blocksize = ${blocksize[0]} (Randomwrite, io_depth = 16, IOdirect = 1, numjobs=4)"
	echo "${blocksize[i]} $(sudo fio ${randwrite} --directory=${mount_ext4} --iodepth=${io_depth[0]} --bs=${blocksize[0]} | tail -n -6 | head -1)" >> ${rw_ext4_file}
	echo "${blocksize[i]} $(sudo fio ${randwrite} --directory=${mount_btrfs} --iodepth=${io_depth[0]} --bs=${blocksize[0]} | tail -1)" >> ${rw_btrfs_file}
	echo -e "\n" | sh format.sh > /dev/null
done

echo "<---------------------------> Sequential read/write <--------------------------->"
for ((i=0; i<=3; i=i+1)); do
	echo "running with blocksize = ${blocksize[i]} (Sequential read, io_depth = 16, IOdirect = 1, numjobs=4)"
	echo "${blocksize[i]} $(sudo fio ${seqread} --directory=${mount_ext4} --iodepth=${io_depth[0]} --bs=${blocksize[i]} | tail -n -6 | head -1)" >> ${bs_ext4_seq}
	echo "${blocksize[i]} $(sudo fio ${seqread} --directory=${mount_btrfs} --iodepth=${io_depth[0]} --bs=${blocksize[i]} | tail -1)" >> ${bs_btrfs_seq}
done

echo "running with Sequential Write (blocksize=4k, io_depth = 16, IOdirect = 1, numjobs=4)"
echo "Seqwrite $(sudo fio ${seqwrite} --directory=${mount_ext4} --iodepth=${io_depth[0]} --bs=${blocksize[0]} | tail -n -6 | head -1)" >> ${rw_ext4_seq}
echo "Seqwrite $(sudo fio ${seqwrite} --directory=${mount_btrfs} --iodepth=${io_depth[0]} --bs=${blocksize[0]} | tail -1)" >> ${rw_btrfs_seq}
echo -e "\n" | sh format.sh > /dev/null

echo '<---------------------> Plotting <--------------------->'
nix-shell --run "python3 plot_fio_bs.py -p ${bs_ext4_file} -g ${bs_btrfs_file} -n ${random}"
nix-shell --run "python3 plot_fio_iodepth.py -p ${io_depth_ext4_file} -g ${io_depth_btrfs_file} -n ${random}"
nix-shell --run "python3 plot_fio_rw.py -p  ${rw_ext4_file} -g ${rw_btrfs_file} -n ${random}"
nix-shell --run "python3 plot_fio_bs_seq.py -p ${bs_ext4_seq} -g ${bs_btrfs_seq} -n ${sequential}"
nix-shell --run "python3 plot_fio_seq_write.py -p ${rw_ext4_seq} -g ${rw_btrfs_seq} -n ${sequential}"
nix-shell --run "python3 plot_fio_bs_directzero.py -p ${bs_ext4_fileIOdirectzero} -g ${bs_btrfs_fileIOdirectzero} -n ${random}"








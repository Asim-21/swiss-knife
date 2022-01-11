. ./variables.sh
nix-env -iA nixos.btrfs-progs
sudo modprobe btrfs
echo -e "n\np\n1\n\n+100GB\nw\n" | sudo fdisk -c ${fs}
sudo partprobe ${fs}
echo -e "n\np\n2\n\n+100GB\nw\n" | sudo fdisk -c ${fs}
sudo partprobe ${fs}

sudo mkfs -t ext4 ${fs}1
sudo mount ${fs}1 ${mount_ext4}

sudo mkfs.btrfs -f -y ${fs}2
sudo mount ${fs}2 ${mount_btrfs}
sudo partprobe ${fs}2
sudo partprobe ${fs}1
sudo partprobe ${fs}
sudo chown -R "$(whoami)":users ~/swiss-knife

. ./format.sh
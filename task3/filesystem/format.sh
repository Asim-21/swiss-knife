#!/bin/sh
. ./variables.sh

sudo umount ${fs}2
sudo mkfs.btrfs -f ${fs}2
sudo mount ${fs}2 ${mount_btrfs}

sudo umount ${fs}1
echo -e 'y\n\' | sudo mkfs -t ext4 ${fs}1
sudo mount ${fs}1 ${mount_ext4}
sudo partprobe ${fs}2
sudo partprobe ${fs}1


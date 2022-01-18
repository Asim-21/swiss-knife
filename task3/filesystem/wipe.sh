#!/bin/sh
. ./variables.sh

sudo umount -l ${fs}2
sudo umount -l ${fs}1
sudo wipefs -af --all ${fs}1
sudo wipefs -af --all ${fs}2
#echo -e 'd\n\nw\n' | sudo fdisk -c ${fs}
#echo -e 'd\n\nw\n' | sudo fdisk -c ${fs}
sleep 5s
sudo partprobe ${fs

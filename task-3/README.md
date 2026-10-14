# Занятие 3. Работа с LVM

## 1. Уменьшить том под / до 8G.
```
root@ubuntu-vm:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  64G  0 disk
├─sda1                      8:1    0   1M  0 part
├─sda2                      8:2    0   2G  0 part /boot
└─sda3                      8:3    0  62G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0  31G  0 lvm  /
sdb                         8:16   0  10G  0 disk
sdc                         8:32   0  10G  0 disk
sdd                         8:48   0  10G  0 disk
sde                         8:64   0  10G  0 disk
root@ubuntu-vm:~# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
root@ubuntu-vm:~# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created
root@ubuntu-vm:~# lvcreate -n lv_root -l +100%FREE /dev/vg_root
  Logical volume "lv_root" created.
root@ubuntu-vm:~# mkfs.ext4 /dev/vg_root/lv_root
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 2620416 4k blocks and 655360 inodes
Filesystem UUID: bc45a4a3-9d7c-42ff-9440-283f570eadab
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

root@ubuntu-vm:~# mount /dev/vg_root/lv_root /mnt
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:~# df -hT
Filesystem                        Type    Size  Used Avail Use% Mounted on
tmpfs                             tmpfs   197M  996K  196M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv ext4     31G  4.4G   25G  16% /
tmpfs                             tmpfs   984M     0  984M   0% /dev/shm
tmpfs                             tmpfs   5.0M     0  5.0M   0% /run/lock
/dev/sda2                         ext4    2.0G  103M  1.7G   6% /boot
vagrant                           vboxsf  690G  588G  103G  86% /vagrant
tmpfs                             tmpfs   197M   16K  197M   1% /run/user/0
/dev/mapper/vg_root-lv_root       ext4    9.8G   24K  9.3G   1% /mnt
root@ubuntu-vm:~# rsync -axHAX / /mnt
root@ubuntu-vm:~# ls /mnt
bin                home               mnt   sbin.usr-is-merged  usr
bin.usr-is-merged  lib                opt   snap                vagrant
boot               lib64              proc  srv                 var
cdrom              lib.usr-is-merged  root  swap.img
dev                lost+found         run   sys
etc                media              sbin  tmp
root@ubuntu-vm:~# for i in /proc/ /sys/ /dev/ /run/ /boot/; \
> do mount --bind $i /mnt/$i; done
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:~# chroot /mnt
root@ubuntu-vm:/# grub-mkconfig -o /boot/grub/grub.cfg
Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.8.0-86-generic
Found initrd image: /boot/initrd.img-6.8.0-86-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
root@ubuntu-vm:/# update-initramfs -u
update-initramfs: Generating /boot/initrd.img-6.8.0-86-generic
root@ubuntu-vm:/# exit
exit
root@ubuntu-vm:~# reboot
root@ubuntu-vm:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  64G  0 disk
├─sda1                      8:1    0   1M  0 part
├─sda2                      8:2    0   2G  0 part /boot
└─sda3                      8:3    0  62G  0 part
  └─ubuntu--vg-ubuntu--lv 252:1    0  31G  0 lvm
sdb                         8:16   0  10G  0 disk
└─vg_root-lv_root         252:0    0  10G  0 lvm  /
sdc                         8:32   0  10G  0 disk
sdd                         8:48   0  10G  0 disk
sde                         8:64   0  10G  0 disk
root@ubuntu-vm:~# lvremove /dev/ubuntu-vg/ubuntu-lv
Do you really want to remove and DISCARD active logical volume ubuntu-vg/ubuntu-lv? [y/n]: y
  Logical volume "ubuntu-lv" successfully removed.
root@ubuntu-vm:~# lvcreate -n ubuntu-vg/ubuntu-lv -L 8G /dev/ubuntu-vg
WARNING: ext4 signature detected on /dev/ubuntu-vg/ubuntu-lv at offset 1080. Wipe it? [y/n]: y
  Wiping ext4 signature on /dev/ubuntu-vg/ubuntu-lv.
  Logical volume "ubuntu-lv" created.
root@ubuntu-vm:~# mkfs.ext4 /dev/ubuntu-vg/ubuntu-lv
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 2097152 4k blocks and 524288 inodes
Filesystem UUID: 989aae01-33ef-43d9-923a-7ed22f73808d
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

root@ubuntu-vm:~# mount /dev/ubuntu-vg/ubuntu-lv /mnt
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:~# rsync -axHAX / /mnt
root@ubuntu-vm:~# for i in /proc/ /sys/ /dev/ /run/ /boot/; \
> do mount --bind $i /mnt/$i; done
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:~# chroot /mnt
root@ubuntu-vm:/# grub-mkconfig -o /boot/grub/grub.cfg
Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.8.0-86-generic
Found initrd image: /boot/initrd.img-6.8.0-86-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
root@ubuntu-vm:/# update-initramfs -u
update-initramfs: Generating /boot/initrd.img-6.8.0-86-generic
W: Couldn't identify type of root file system for fsck hook
root@ubuntu-vm:/# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  64G  0 disk
├─sda1                      8:1    0   1M  0 part
├─sda2                      8:2    0   2G  0 part /boot
└─sda3                      8:3    0  62G  0 part
  └─ubuntu--vg-ubuntu--lv 252:1    0   8G  0 lvm  /
sdb                         8:16   0  10G  0 disk
└─vg_root-lv_root         252:0    0  10G  0 lvm
sdc                         8:32   0  10G  0 disk
sdd                         8:48   0  10G  0 disk
sde                         8:64   0  10G  0 disk
root@ubuntu-vm:/# df -hT
Filesystem                        Type   Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv ext4   7.8G  4.4G  3.0G  60% /
tmpfs                             tmpfs  197M 1000K  196M   1% /run
/dev/sda2                         ext4   2.0G   77M  1.8G   5% /boot
```

## 2. Выделить том под /home.
```
root@ubuntu-vm:/# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  ubuntu-vg   1   1   0 wz--n- <62.00g <54.00g
  vg_root     1   1   0 wz--n- <10.00g      0
root@ubuntu-vm:/# lvcreate -n lv_home -L 2G /dev/ubuntu-vg
  Logical volume "lv_home" created.
root@ubuntu-vm:/# mkfs.ext4 /dev/ubuntu-vg/lv_home
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 524288 4k blocks and 131072 inodes
Filesystem UUID: d7fd4f87-be46-4059-a98b-60c1dd9057e1
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

root@ubuntu-vm:/# mount /dev/ubuntu-vg/lv_home /mnt
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:/# cp -aR /home/* /mnt
root@ubuntu-vm:/# ls /mnt
lost+found  vagrant
root@ubuntu-vm:/# rm -rf /home/*
root@ubuntu-vm:/# ls /home
root@ubuntu-vm:/# umount /mnt
root@ubuntu-vm:/# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  64G  0 disk
├─sda1                      8:1    0   1M  0 part
├─sda2                      8:2    0   2G  0 part /boot
└─sda3                      8:3    0  62G  0 part
  ├─ubuntu--vg-ubuntu--lv 252:1    0   8G  0 lvm  /
  └─ubuntu--vg-lv_home    252:2    0   2G  0 lvm
sdb                         8:16   0  10G  0 disk
└─vg_root-lv_root         252:0    0  10G  0 lvm
sdc                         8:32   0  10G  0 disk
sdd                         8:48   0  10G  0 disk
sde                         8:64   0  10G  0 disk
root@ubuntu-vm:/# mount /dev/ubuntu-vg/lv_home /home
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:/# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  64G  0 disk
├─sda1                      8:1    0   1M  0 part
├─sda2                      8:2    0   2G  0 part /boot
└─sda3                      8:3    0  62G  0 part
  ├─ubuntu--vg-ubuntu--lv 252:1    0   8G  0 lvm  /
  └─ubuntu--vg-lv_home    252:2    0   2G  0 lvm  /home
sdb                         8:16   0  10G  0 disk
└─vg_root-lv_root         252:0    0  10G  0 lvm
sdc                         8:32   0  10G  0 disk
sdd                         8:48   0  10G  0 disk
sde                         8:64   0  10G  0 disk
root@ubuntu-vm:/# ls /home
lost+found  vagrant
```

## 3. Выделить том под /var - сделать в mirror.
```
root@ubuntu-vm:/# pvcreate /dev/sdc /dev/sdd
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdd" successfully created.
root@ubuntu-vm:/# vgcreate vg_var /dev/sdc /dev/sdd
  Volume group "vg_var" successfully created
root@ubuntu-vm:/# lvcreate -L 950M -m1 -n lv_var vg_var
  Rounding up size to full physical extent 952.00 MiB
  Logical volume "lv_var" created.
root@ubuntu-vm:/# mkfs.ext4 /dev/vg_var/lv_var
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 243712 4k blocks and 60928 inodes
Filesystem UUID: 73ac9434-dc26-45ee-9ff7-5ea1ffe7ef48
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

root@ubuntu-vm:/# mount /dev/vg_var/lv_var /mnt
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:/# cp -aR /var/* /mnt
root@ubuntu-vm:/# ls /mnt
backups  crash  local  log         mail  run   spool
cache    lib    lock   lost+found  opt   snap  tmp
root@ubuntu-vm:/# mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
root@ubuntu-vm:/# ls /tmp/oldvar/
backups  crash  local  log   opt  snap   tmp
cache    lib    lock   mail  run  spool
root@ubuntu-vm:/# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   62G  0 part
  ├─ubuntu--vg-ubuntu--lv 252:1    0    8G  0 lvm  /
  └─ubuntu--vg-lv_home    252:2    0    2G  0 lvm  /home
sdb                         8:16   0   10G  0 disk
└─vg_root-lv_root         252:0    0   10G  0 lvm
sdc                         8:32   0   10G  0 disk
├─vg_var-lv_var_rmeta_0   252:3    0    4M  0 lvm
│ └─vg_var-lv_var         252:7    0  952M  0 lvm  /mnt
└─vg_var-lv_var_rimage_0  252:4    0  952M  0 lvm
  └─vg_var-lv_var         252:7    0  952M  0 lvm  /mnt
sdd                         8:48   0   10G  0 disk
├─vg_var-lv_var_rmeta_1   252:5    0    4M  0 lvm
│ └─vg_var-lv_var         252:7    0  952M  0 lvm  /mnt
└─vg_var-lv_var_rimage_1  252:6    0  952M  0 lvm
  └─vg_var-lv_var         252:7    0  952M  0 lvm  /mnt
sde                         8:64   0   10G  0 disk
root@ubuntu-vm:/# umount /dev/vg_var/lv_var
root@ubuntu-vm:/# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   62G  0 part
  ├─ubuntu--vg-ubuntu--lv 252:1    0    8G  0 lvm  /
  └─ubuntu--vg-lv_home    252:2    0    2G  0 lvm  /home
sdb                         8:16   0   10G  0 disk
└─vg_root-lv_root         252:0    0   10G  0 lvm
sdc                         8:32   0   10G  0 disk
├─vg_var-lv_var_rmeta_0   252:3    0    4M  0 lvm
│ └─vg_var-lv_var         252:7    0  952M  0 lvm
└─vg_var-lv_var_rimage_0  252:4    0  952M  0 lvm
  └─vg_var-lv_var         252:7    0  952M  0 lvm
sdd                         8:48   0   10G  0 disk
├─vg_var-lv_var_rmeta_1   252:5    0    4M  0 lvm
│ └─vg_var-lv_var         252:7    0  952M  0 lvm
└─vg_var-lv_var_rimage_1  252:6    0  952M  0 lvm
  └─vg_var-lv_var         252:7    0  952M  0 lvm
sde                         8:64   0   10G  0 disk
root@ubuntu-vm:/# mount /dev/vg_var/lv_var /var
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:/# ls /var
backups  crash  local  log         mail  run   spool
cache    lib    lock   lost+found  opt   snap  tmp
```

## 4. /home - сделать том для снапшотов.
```
root@ubuntu-vm:/# touch /home/file{1..20}
root@ubuntu-vm:/# ls /home
file1   file12  file15  file18  file20  file5  file8       vagrant
file10  file13  file16  file19  file3   file6  file9
file11  file14  file17  file2   file4   file7  lost+found
root@ubuntu-vm:/# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  ubuntu-vg   1   2   0 wz--n- <62.00g <52.00g
  vg_root     1   1   0 wz--n- <10.00g      0
  vg_var      2   1   0 wz--n-  19.99g  18.12g
root@ubuntu-vm:/# lvcreate -L 100MB -s -n home_snap /dev/ubuntu-vg/lv_home
  Logical volume "home_snap" created.
root@ubuntu-vm:/# lsblk
NAME                         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                            8:0    0   64G  0 disk
├─sda1                         8:1    0    1M  0 part
├─sda2                         8:2    0    2G  0 part /boot
└─sda3                         8:3    0   62G  0 part
  ├─ubuntu--vg-ubuntu--lv    252:1    0    8G  0 lvm  /
  ├─ubuntu--vg-lv_home-real  252:8    0    2G  0 lvm
  │ ├─ubuntu--vg-lv_home     252:2    0    2G  0 lvm  /home
  │ └─ubuntu--vg-home_snap   252:10   0    2G  0 lvm
  └─ubuntu--vg-home_snap-cow 252:9    0  100M  0 lvm
    └─ubuntu--vg-home_snap   252:10   0    2G  0 lvm
sdb                            8:16   0   10G  0 disk
└─vg_root-lv_root            252:0    0   10G  0 lvm
sdc                            8:32   0   10G  0 disk
├─vg_var-lv_var_rmeta_0      252:3    0    4M  0 lvm
│ └─vg_var-lv_var            252:7    0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_0     252:4    0  952M  0 lvm
  └─vg_var-lv_var            252:7    0  952M  0 lvm  /var
sdd                            8:48   0   10G  0 disk
├─vg_var-lv_var_rmeta_1      252:5    0    4M  0 lvm
│ └─vg_var-lv_var            252:7    0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_1     252:6    0  952M  0 lvm
  └─vg_var-lv_var            252:7    0  952M  0 lvm  /var
sde                            8:64   0   10G  0 disk
```

## 5. Прописать монтирование в fstab. Попробовать с разными опциями и разными файловыми системами (на выбор).
```
root@ubuntu-vm:/# cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-NZGKxWDOlEtVYowX6ENyvhgdKoPp9mR0ft4hDK52ZzWhFMdnFM02xJc1pqS1q2QK / ext4 defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/faa6fb15-30f8-41f3-be06-314a34d8f020 /boot ext4 defaults 0 1
/swap.img	none	swap	sw	0	0
#VAGRANT-BEGIN
# The contents below are automatically generated by Vagrant. Do not modify.
vagrant /vagrant vboxsf uid=1000,gid=1000,_netdev 0 0
#VAGRANT-END
root@ubuntu-vm:/# blkid | grep var:
/dev/mapper/vg_var-lv_var: UUID="73ac9434-dc26-45ee-9ff7-5ea1ffe7ef48" BLOCK_SIZE="4096" TYPE="ext4"
root@ubuntu-vm:/# echo "`blkid | grep var: | awk '{print $2}'` \
> /var ext4 defaults 0 0" >> /etc/fstab
root@ubuntu-vm:/# blkid | grep lv_home
/dev/mapper/ubuntu--vg-lv_home: UUID="d7fd4f87-be46-4059-a98b-60c1dd9057e1" BLOCK_SIZE="4096" TYPE="ext4"
root@ubuntu-vm:/# echo "`blkid | grep lv_home | awk '{print $2}'` \
/home ext4 defaults 0 0" >> /etc/fstab
root@ubuntu-vm:/# cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-NZGKxWDOlEtVYowX6ENyvhgdKoPp9mR0ft4hDK52ZzWhFMdnFM02xJc1pqS1q2QK / ext4 defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/faa6fb15-30f8-41f3-be06-314a34d8f020 /boot ext4 defaults 0 1
/swap.img	none	swap	sw	0	0
#VAGRANT-BEGIN
# The contents below are automatically generated by Vagrant. Do not modify.
vagrant /vagrant vboxsf uid=1000,gid=1000,_netdev 0 0
#VAGRANT-END
UUID="73ac9434-dc26-45ee-9ff7-5ea1ffe7ef48" /var ext4 defaults 0 0
UUID="d7fd4f87-be46-4059-a98b-60c1dd9057e1" /home ext4 defaults 0 0
```

## 6. Работа со снапшотами
```
root@ubuntu-vm:~# ls /home
file1   file12  file15  file18  file20  file5  file8       vagrant
file10  file13  file16  file19  file3   file6  file9
file11  file14  file17  file2   file4   file7  lost+found
root@ubuntu-vm:~# lsblk
NAME                         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                            8:0    0   64G  0 disk
├─sda1                         8:1    0    1M  0 part
├─sda2                         8:2    0    2G  0 part /boot
└─sda3                         8:3    0   62G  0 part
  ├─ubuntu--vg-ubuntu--lv    252:1    0    8G  0 lvm  /
  ├─ubuntu--vg-lv_home-real  252:2    0    2G  0 lvm
  │ ├─ubuntu--vg-lv_home     252:3    0    2G  0 lvm  /home
  │ └─ubuntu--vg-home_snap   252:5    0    2G  0 lvm
  └─ubuntu--vg-home_snap-cow 252:4    0  100M  0 lvm
    └─ubuntu--vg-home_snap   252:5    0    2G  0 lvm
sdb                            8:16   0   10G  0 disk
└─vg_root-lv_root            252:0    0   10G  0 lvm
sdc                            8:32   0   10G  0 disk
├─vg_var-lv_var_rmeta_0      252:6    0    4M  0 lvm
│ └─vg_var-lv_var            252:10   0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_0     252:7    0  952M  0 lvm
  └─vg_var-lv_var            252:10   0  952M  0 lvm  /var
sdd                            8:48   0   10G  0 disk
├─vg_var-lv_var_rmeta_1      252:8    0    4M  0 lvm
│ └─vg_var-lv_var            252:10   0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_1     252:9    0  952M  0 lvm
  └─vg_var-lv_var            252:10   0  952M  0 lvm  /var
sde                            8:64   0   10G  0 disk
root@ubuntu-vm:~# rm -f /home/file{11..20}
root@ubuntu-vm:~# ls /home
file1   file2  file4  file6  file8  lost+found
file10  file3  file5  file7  file9  vagrant
root@ubuntu-vm:~# umount /home
root@ubuntu-vm:~# lvconvert --merge /dev/ubuntu-vg/home_snap
  Merging of volume ubuntu-vg/home_snap started.
  ubuntu-vg/lv_home: Merged: 100.00%
root@ubuntu-vm:~# mount /dev/ubuntu-vg/lv_home /home
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@ubuntu-vm:~# ls /home
file1   file12  file15  file18  file20  file5  file8       vagrant
file10  file13  file16  file19  file3   file6  file9
file11  file14  file17  file2   file4   file7  lost+found
```

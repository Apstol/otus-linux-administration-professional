## Занятие 2 - Работа с mdadm

## Отчет по командам для починки RAID

```
root@ubuntu-vm:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid10 sdc[4] sde[3] sdd[2] sdb[0]
      2093056 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>
root@ubuntu-vm:~# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Thu Oct  8 04:50:49 2026
        Raid Level : raid10
        Array Size : 2093056 (2044.00 MiB 2143.29 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Thu Oct  8 05:00:56 2026
             State : clean
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : ubuntu-vm:127  (local to host ubuntu-vm)
              UUID : 5154ffc4:f6e29a85:ea2ab2b2:6699d64d
            Events : 39

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       4       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
root@ubuntu-vm:~# mdadm /dev/md127 --fail /dev/sdc
mdadm: set /dev/sdc faulty in /dev/md127
root@ubuntu-vm:~# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Thu Oct  8 04:50:49 2026
        Raid Level : raid10
        Array Size : 2093056 (2044.00 MiB 2143.29 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Thu Oct  8 05:01:30 2026
             State : clean, degraded
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 1
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : ubuntu-vm:127  (local to host ubuntu-vm)
              UUID : 5154ffc4:f6e29a85:ea2ab2b2:6699d64d
            Events : 41

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       -       0        0        1      removed
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde

       4       8       32        -      faulty   /dev/sdc
root@ubuntu-vm:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid10 sdc[4](F) sde[3] sdd[2] sdb[0]
      2093056 blocks super 1.2 512K chunks 2 near-copies [4/3] [U_UU]

unused devices: <none>
root@ubuntu-vm:~# mdadm /dev/md127 --remove /dev/sdc
mdadm: hot removed /dev/sdc from /dev/md127
root@ubuntu-vm:~# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Thu Oct  8 04:50:49 2026
        Raid Level : raid10
        Array Size : 2093056 (2044.00 MiB 2143.29 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 4
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Thu Oct  8 05:02:03 2026
             State : clean, degraded
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : ubuntu-vm:127  (local to host ubuntu-vm)
              UUID : 5154ffc4:f6e29a85:ea2ab2b2:6699d64d
            Events : 42

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       -       0        0        1      removed
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
root@ubuntu-vm:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid10 sde[3] sdd[2] sdb[0]
      2093056 blocks super 1.2 512K chunks 2 near-copies [4/3] [U_UU]

unused devices: <none>
root@ubuntu-vm:~# mdadm /dev/md127 --add /dev/sdc
mdadm: added /dev/sdc
root@ubuntu-vm:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid10 sdc[4] sde[3] sdd[2] sdb[0]
      2093056 blocks super 1.2 512K chunks 2 near-copies [4/3] [U_UU]
      [========>............]  recovery = 41.0% (430080/1046528) finish=0.0min speed=215040K/sec

unused devices: <none>
root@ubuntu-vm:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
md127 : active raid10 sdc[4] sde[3] sdd[2] sdb[0]
      2093056 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>
root@ubuntu-vm:~# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Thu Oct  8 04:50:49 2026
        Raid Level : raid10
        Array Size : 2093056 (2044.00 MiB 2143.29 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Thu Oct  8 05:02:37 2026
             State : clean
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : ubuntu-vm:127  (local to host ubuntu-vm)
              UUID : 5154ffc4:f6e29a85:ea2ab2b2:6699d64d
            Events : 61

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       4       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
```

## Отчет по созданию разделов
```
root@ubuntu-vm:~# parted -s /dev/md127 mklabel gpt
root@ubuntu-vm:~# parted /dev/md127 mkpart primary ext4 0% 20%
Information: You may need to update /etc/fstab.

root@ubuntu-vm:~# parted /dev/md127 mkpart primary ext4 20% 40%
Information: You may need to update /etc/fstab.

root@ubuntu-vm:~# parted /dev/md127 mkpart primary ext4 40% 60%
Information: You may need to update /etc/fstab.

root@ubuntu-vm:~# parted /dev/md127 mkpart primary ext4 60% 80%
Information: You may need to update /etc/fstab.

root@ubuntu-vm:~# parted /dev/md127 mkpart primary ext4 80% 100%
Information: You may need to update /etc/fstab.

root@ubuntu-vm:~# for i in $(seq 1 5); do mkfs.ext4 /dev/md127p$i; done
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 104448 4k blocks and 104448 inodes
Filesystem UUID: efb6c5f9-c6f4-43e8-a29f-2b48f702d00b
Superblock backups stored on blocks:
	32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 104704 4k blocks and 104704 inodes
Filesystem UUID: 39cef22d-7489-4f13-8ac1-3bd0d97e34d6
Superblock backups stored on blocks:
	32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 104448 4k blocks and 104448 inodes
Filesystem UUID: f564644c-8875-4b1e-be42-0bc43666e7d6
Superblock backups stored on blocks:
	32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 104704 4k blocks and 104704 inodes
Filesystem UUID: 198f159b-d2ec-4c32-a4f8-62e0ce1e7159
Superblock backups stored on blocks:
	32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 104448 4k blocks and 104448 inodes
Filesystem UUID: 55dea5f2-9230-4290-b43a-cc96063067c3
Superblock backups stored on blocks:
	32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

root@ubuntu-vm:~# mkdir -p /raid/part{1,2,3,4,5}
root@ubuntu-vm:~# for i in $(seq 1 5); do mount /dev/md127p$i /raid/part$i; done
root@ubuntu-vm:~# ls -l /raid/part3
total 16
drwx------ 2 root root 16384 Oct  8 06:24 lost+found
root@ubuntu-vm:~# cp -r /var/log/* /raid/part3
root@ubuntu-vm:~# ls -l /raid/part3
total 6848
-rw-r--r-- 1 root root   26794 Oct  8 06:25 alternatives.log
-rw-r----- 1 root root       0 Oct  8 06:25 apport.log
-rw-r----- 1 root root     336 Oct  8 06:25 apport.log.1
drwxr-xr-x 2 root root    4096 Oct  8 06:25 apt
-rw-r----- 1 root root  118528 Oct  8 06:25 auth.log
-rw-r--r-- 1 root root   61229 Oct  8 06:25 bootstrap.log
-rw-r----- 1 root root    2688 Oct  8 06:25 btmp
-rw-r----- 1 root root   72689 Oct  8 06:25 cloud-init.log
-rw-r----- 1 root root    4362 Oct  8 06:25 cloud-init-output.log
drwxr-xr-x 2 root root    4096 Oct  8 06:25 dist-upgrade
-rw-r----- 1 root root   56670 Oct  8 06:25 dmesg
-rw-r----- 1 root root   56410 Oct  8 06:25 dmesg.0
-rw-r----- 1 root root   16930 Oct  8 06:25 dmesg.1.gz
-rw-r----- 1 root root   16539 Oct  8 06:25 dmesg.2.gz
-rw-r----- 1 root root   16492 Oct  8 06:25 dmesg.3.gz
-rw-r----- 1 root root   16344 Oct  8 06:25 dmesg.4.gz
-rw-r--r-- 1 root root  714425 Oct  8 06:25 dpkg.log
-rw-r--r-- 1 root root       0 Oct  8 06:25 faillog
drwxr-x--- 4 root root    4096 Oct  8 06:25 installer
drwxr-xr-x 3 root root    4096 Oct  8 06:25 journal
-rw-r----- 1 root root 1934817 Oct  8 06:25 kern.log
drwxr-xr-x 2 root root    4096 Oct  8 06:25 landscape
-rw-r--r-- 1 root root  292292 Oct  8 06:25 lastlog
drwx------ 2 root root   16384 Oct  8 06:24 lost+found
drwx------ 2 root root    4096 Oct  8 06:25 private
lrwxrwxrwx 1 root root      39 Oct  8 06:25 README -> ../../usr/share/doc/systemd/README.logs
-rw-r----- 1 root root 3711086 Oct  8 06:25 syslog
drwxr-xr-x 2 root root    4096 Oct  8 06:25 sysstat
-rw-r--r-- 1 root root       0 Oct  8 06:25 ubuntu-advantage-apt-hook.log
drwxr-x--- 2 root root    4096 Oct  8 06:25 unattended-upgrades
-rw------- 1 root root    2310 Oct  8 06:25 vboxadd-install.log
-rw-r--r-- 1 root root    1322 Oct  8 06:25 vboxadd-setup.log
-rw-r--r-- 1 root root    1322 Oct  8 06:25 vboxadd-setup.log.1
-rw-r--r-- 1 root root    1322 Oct  8 06:25 vboxadd-setup.log.2
-rw-r--r-- 1 root root    1322 Oct  8 06:25 vboxadd-setup.log.3
-rw-r--r-- 1 root root    1322 Oct  8 06:25 vboxadd-setup.log.4
-rw-r--r-- 1 root root   68352 Oct  8 06:25 wtmp
root@ubuntu-vm:~# lsblk -f
NAME                      FSTYPE            FSVER            LABEL           UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1
├─sda2                    ext4              1.0                              d19b8ec3-246d-4ab6-936e-ede8dcdfba18      1.6G    11% /boot
└─sda3                    LVM2_member       LVM2 001                         cNs39O-nXZ3-umht-oYNj-tiDt-nxW1-tqW3bH
  └─ubuntu--vg-ubuntu--lv ext4              1.0                              8be09990-fa8b-4145-9746-3793d0905b5c      4.8G    52% /
sdb                       linux_raid_member 1.2              ubuntu-vm:127   54d100b6-f02f-bac4-479d-a52ad3a02b54
└─md127
  ├─md127p1               ext4              1.0                              efb6c5f9-c6f4-43e8-a29f-2b48f702d00b    337.3M     0% /raid/part1
  ├─md127p2               ext4              1.0                              39cef22d-7489-4f13-8ac1-3bd0d97e34d6    338.1M     0% /raid/part2
  ├─md127p3               ext4              1.0                              f564644c-8875-4b1e-be42-0bc43666e7d6         0    94% /raid/part3
  ├─md127p4               ext4              1.0                              198f159b-d2ec-4c32-a4f8-62e0ce1e7159    338.1M     0% /raid/part4
  └─md127p5               ext4              1.0                              55dea5f2-9230-4290-b43a-cc96063067c3    337.3M     0% /raid/part5
sdc                       linux_raid_member 1.2              ubuntu-vm:127   54d100b6-f02f-bac4-479d-a52ad3a02b54
└─md127
  ├─md127p1               ext4              1.0                              efb6c5f9-c6f4-43e8-a29f-2b48f702d00b    337.3M     0% /raid/part1
  ├─md127p2               ext4              1.0                              39cef22d-7489-4f13-8ac1-3bd0d97e34d6    338.1M     0% /raid/part2
  ├─md127p3               ext4              1.0                              f564644c-8875-4b1e-be42-0bc43666e7d6         0    94% /raid/part3
  ├─md127p4               ext4              1.0                              198f159b-d2ec-4c32-a4f8-62e0ce1e7159    338.1M     0% /raid/part4
  └─md127p5               ext4              1.0                              55dea5f2-9230-4290-b43a-cc96063067c3    337.3M     0% /raid/part5
sdd                       linux_raid_member 1.2              ubuntu-vm:127   54d100b6-f02f-bac4-479d-a52ad3a02b54
└─md127
  ├─md127p1               ext4              1.0                              efb6c5f9-c6f4-43e8-a29f-2b48f702d00b    337.3M     0% /raid/part1
  ├─md127p2               ext4              1.0                              39cef22d-7489-4f13-8ac1-3bd0d97e34d6    338.1M     0% /raid/part2
  ├─md127p3               ext4              1.0                              f564644c-8875-4b1e-be42-0bc43666e7d6         0    94% /raid/part3
  ├─md127p4               ext4              1.0                              198f159b-d2ec-4c32-a4f8-62e0ce1e7159    338.1M     0% /raid/part4
  └─md127p5               ext4              1.0                              55dea5f2-9230-4290-b43a-cc96063067c3    337.3M     0% /raid/part5
sde                       linux_raid_member 1.2              ubuntu-vm:127   54d100b6-f02f-bac4-479d-a52ad3a02b54
└─md127
  ├─md127p1               ext4              1.0                              efb6c5f9-c6f4-43e8-a29f-2b48f702d00b    337.3M     0% /raid/part1
  ├─md127p2               ext4              1.0                              39cef22d-7489-4f13-8ac1-3bd0d97e34d6    338.1M     0% /raid/part2
  ├─md127p3               ext4              1.0                              f564644c-8875-4b1e-be42-0bc43666e7d6         0    94% /raid/part3
  ├─md127p4               ext4              1.0                              198f159b-d2ec-4c32-a4f8-62e0ce1e7159    338.1M     0% /raid/part4
  └─md127p5               ext4              1.0                              55dea5f2-9230-4290-b43a-cc96063067c3    337.3M     0% /raid/part5
sdf
sr0                       iso9660           Joliet Extension VBox_GAs_7.2.20 2026-09-22-08-49-47-42
```

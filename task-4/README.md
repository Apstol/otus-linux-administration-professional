# Занятие 5. Практические навыки работы с ZFS

## 1. Определить алгоритм с наилучшим сжатием.
```
root@ubuntu-vm:~# zpool create otus1 mirror /dev/sdb /dev/sdc
root@ubuntu-vm:~# lsblk -f
NAME                      FSTYPE      FSVER    LABEL UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1
├─sda2                    ext4        1.0            faa6fb15-30f8-41f3-be06-314a34d8f020      1.7G     5% /boot
└─sda3                    LVM2_member LVM2 001       85zsUx-fNCJ-GLnq-MgRe-PINQ-d3NB-b1QMdf
  └─ubuntu--vg-ubuntu--lv ext4        1.0            f7c9605e-e389-4b7a-ac33-681c3d6cca46     24.3G    15% /
sdb
├─sdb1                    zfs_member  5000     otus1 9170820415545693210
└─sdb9
sdc
├─sdc1                    zfs_member  5000     otus1 9170820415545693210
└─sdc9
sdd
sde
sdf
sdg
sdh
sdi
root@ubuntu-vm:~# zpool create otus2 mirror /dev/sdd /dev/sde
root@ubuntu-vm:~# zpool create otus3 mirror /dev/sdf /dev/sdg
root@ubuntu-vm:~# zpool create otus4 mirror /dev/sdh /dev/sdi
root@ubuntu-vm:~# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus1   480M   116K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus2   480M   122K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus3   480M   114K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus4   480M   180K   480M        -         -     0%     0%  1.00x    ONLINE  -
root@ubuntu-vm:~# zpool status
  pool: otus1
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0

errors: No known data errors

  pool: otus2
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus2       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	    sde     ONLINE       0     0     0

errors: No known data errors

  pool: otus3
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus3       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	    sdg     ONLINE       0     0     0

errors: No known data errors

  pool: otus4
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus4       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdh     ONLINE       0     0     0
	    sdi     ONLINE       0     0     0

errors: No known data errors
root@ubuntu-vm:~# zfs set compression=lzjb otus1
root@ubuntu-vm:~# zfs set compression=lz4 otus2
root@ubuntu-vm:~# zfs set compression=gzip-9 otus3
root@ubuntu-vm:~# zfs set compression=zle otus4
root@ubuntu-vm:~# zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local
root@ubuntu-vm:~# for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
--2026-10-17 04:38:03--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log [following]
--2026-10-17 04:38:04--  https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving www.gutenberg.org (www.gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to www.gutenberg.org (www.gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41273476 (39M) [text/plain]
Saving to: ‘/otus1/pg2600.converter.log’

pg2600.converter.log                                                100%[=================================================================================================================================================================>]  39.36M  3.51MB/s    in 21s

2026-10-17 04:38:25 (1.88 MB/s) - ‘/otus1/pg2600.converter.log’ saved [41273476/41273476]

--2026-10-17 04:38:25--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log [following]
--2026-10-17 04:38:26--  https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving www.gutenberg.org (www.gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to www.gutenberg.org (www.gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41273476 (39M) [text/plain]
Saving to: ‘/otus2/pg2600.converter.log’

pg2600.converter.log                                                100%[=================================================================================================================================================================>]  39.36M  2.73MB/s    in 12s

2026-10-17 04:38:39 (3.15 MB/s) - ‘/otus2/pg2600.converter.log’ saved [41273476/41273476]

--2026-10-17 04:38:39--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log [following]
--2026-10-17 04:38:39--  https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving www.gutenberg.org (www.gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to www.gutenberg.org (www.gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41273476 (39M) [text/plain]
Saving to: ‘/otus3/pg2600.converter.log’

pg2600.converter.log                                                100%[=================================================================================================================================================================>]  39.36M  3.13MB/s    in 10s

2026-10-17 04:38:50 (3.81 MB/s) - ‘/otus3/pg2600.converter.log’ saved [41273476/41273476]

--2026-10-17 04:38:50--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log [following]
--2026-10-17 04:38:51--  https://www.gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving www.gutenberg.org (www.gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to www.gutenberg.org (www.gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41273476 (39M) [text/plain]
Saving to: ‘/otus4/pg2600.converter.log’

pg2600.converter.log                                                100%[=================================================================================================================================================================>]  39.36M  6.39MB/s    in 7.3s

2026-10-17 04:38:58 (5.40 MB/s) - ‘/otus4/pg2600.converter.log’ saved [41273476/41273476]

root@ubuntu-vm:~# df -hT
Filesystem                        Type    Size  Used Avail Use% Mounted on
tmpfs                             tmpfs   197M  1.1M  196M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv ext4     31G  4.5G   25G  16% /
tmpfs                             tmpfs   984M     0  984M   0% /dev/shm
tmpfs                             tmpfs   5.0M     0  5.0M   0% /run/lock
/dev/sda2                         ext4    2.0G  103M  1.7G   6% /boot
vagrant                           vboxsf  690G  589G  102G  86% /vagrant
tmpfs                             tmpfs   197M   16K  197M   1% /run/user/0
otus1                             zfs     352M   22M  331M   7% /otus1
otus2                             zfs     352M   18M  335M   6% /otus2
otus3                             zfs     352M   11M  342M   4% /otus3
otus4                             zfs     352M   40M  313M  12% /otus4
root@ubuntu-vm:~# ls -l /otus*
/otus1:
total 22133
-rw-r--r-- 1 root root 41273476 Oct  2 07:31 pg2600.converter.log

/otus2:
total 18024
-rw-r--r-- 1 root root 41273476 Oct  2 07:31 pg2600.converter.log

/otus3:
total 10974
-rw-r--r-- 1 root root 41273476 Oct  2 07:31 pg2600.converter.log

/otus4:
total 40347
-rw-r--r-- 1 root root 41273476 Oct  2 07:31 pg2600.converter.log
root@ubuntu-vm:~# ls -lh /otus*
/otus1:
total 22M
-rw-r--r-- 1 root root 40M Oct  2 07:31 pg2600.converter.log

/otus2:
total 18M
-rw-r--r-- 1 root root 40M Oct  2 07:31 pg2600.converter.log

/otus3:
total 11M
-rw-r--r-- 1 root root 40M Oct  2 07:31 pg2600.converter.log

/otus4:
total 40M
-rw-r--r-- 1 root root 40M Oct  2 07:31 pg2600.converter.log
root@ubuntu-vm:~# zfs list
NAME    USED  AVAIL  REFER  MOUNTPOINT
otus1  21.8M   330M  21.6M  /otus1
otus2  17.8M   334M  17.6M  /otus2
otus3  10.9M   341M  10.7M  /otus3
otus4  39.6M   312M  39.4M  /otus4
root@ubuntu-vm:~# zfs get all | grep compressratio
otus1  compressratio         1.82x                  -
otus1  refcompressratio      1.82x                  -
otus2  compressratio         2.23x                  -
otus2  refcompressratio      2.23x                  -
otus3  compressratio         3.66x                  -
otus3  refcompressratio      3.67x                  -
otus4  compressratio         1.00x                  -
otus4  refcompressratio      1.00x                  -
```

## 2. Определить настройки пула.

```
root@ubuntu-vm:~# wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
--2026-10-17 04:43:50--  https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download
Resolving drive.usercontent.google.com (drive.usercontent.google.com)... 142.251.39.129, 2a00:1450:400e:809::2001
Connecting to drive.usercontent.google.com (drive.usercontent.google.com)|142.251.39.129|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7275140 (6.9M) [application/octet-stream]
Saving to: ‘archive.tar.gz’

archive.tar.gz                                                      100%[=================================================================================================================================================================>]   6.94M  8.78MB/s    in 0.8s

2026-10-17 04:43:56 (8.78 MB/s) - ‘archive.tar.gz’ saved [7275140/7275140]

root@ubuntu-vm:~# ls
archive.tar.gz
root@ubuntu-vm:~# tar -xzf archive.tar.gz
root@ubuntu-vm:~# ls
archive.tar.gz  zpoolexport
root@ubuntu-vm:~# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
status: Some supported features are not enabled on the pool.
	(Note that they may be intentionally disabled if the
	'compatibility' property is set.)
 action: The pool can be imported using its name or numeric identifier, though
	some features will not be available without an explicit 'zpool upgrade'.
 config:

	otus                         ONLINE
	  mirror-0                   ONLINE
	    /root/zpoolexport/filea  ONLINE
	    /root/zpoolexport/fileb  ONLINE
root@ubuntu-vm:~# zpool import -d zpoolexport/ otus
root@ubuntu-vm:~# zpool status
  pool: otus
 state: ONLINE
status: Some supported and requested features are not enabled on the pool.
	The pool can still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
	the pool may no longer be accessible by software that does not support
	the features. See zpool-features(7) for details.
config:

	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors

  pool: otus1
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0

errors: No known data errors

  pool: otus2
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus2       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	    sde     ONLINE       0     0     0

errors: No known data errors

  pool: otus3
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus3       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	    sdg     ONLINE       0     0     0

errors: No known data errors

  pool: otus4
 state: ONLINE
config:

	NAME        STATE     READ WRITE CKSUM
	otus4       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdh     ONLINE       0     0     0
	    sdi     ONLINE       0     0     0

errors: No known data errors
root@ubuntu-vm:~# lsblk -f
NAME                      FSTYPE      FSVER    LABEL UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1
├─sda2                    ext4        1.0            faa6fb15-30f8-41f3-be06-314a34d8f020      1.7G     5% /boot
└─sda3                    LVM2_member LVM2 001       85zsUx-fNCJ-GLnq-MgRe-PINQ-d3NB-b1QMdf
  └─ubuntu--vg-ubuntu--lv ext4        1.0            f7c9605e-e389-4b7a-ac33-681c3d6cca46     23.3G    18% /
sdb
├─sdb1                    zfs_member  5000     otus1 9170820415545693210
└─sdb9
sdc
├─sdc1                    zfs_member  5000     otus1 9170820415545693210
└─sdc9
sdd
├─sdd1                    zfs_member  5000     otus2 17529438405113563751
└─sdd9
sde
├─sde1                    zfs_member  5000     otus2 17529438405113563751
└─sde9
sdf
├─sdf1                    zfs_member  5000     otus3 5817280658391825020
└─sdf9
sdg
├─sdg1                    zfs_member  5000     otus3 5817280658391825020
└─sdg9
sdh
├─sdh1                    zfs_member  5000     otus4 4633477755817197522
└─sdh9
sdi
├─sdi1                    zfs_member  5000     otus4 4633477755817197522
└─sdi9
root@ubuntu-vm:~# df -hT
Filesystem                        Type    Size  Used Avail Use% Mounted on
tmpfs                             tmpfs   197M  1.1M  196M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv ext4     31G  5.5G   24G  20% /
tmpfs                             tmpfs   984M     0  984M   0% /dev/shm
tmpfs                             tmpfs   5.0M     0  5.0M   0% /run/lock
/dev/sda2                         ext4    2.0G  103M  1.7G   6% /boot
vagrant                           vboxsf  690G  589G  102G  86% /vagrant
tmpfs                             tmpfs   197M   16K  197M   1% /run/user/0
otus1                             zfs     352M   22M  331M   7% /otus1
otus2                             zfs     352M   18M  335M   6% /otus2
otus3                             zfs     352M   11M  342M   4% /otus3
otus4                             zfs     352M   40M  313M  12% /otus4
otus                              zfs     350M  128K  350M   1% /otus
otus/hometask2                    zfs     352M  2.0M  350M   1% /otus/hometask2
root@ubuntu-vm:~# zpool get all otus
NAME  PROPERTY                       VALUE                          SOURCE
otus  size                           480M                           -
otus  capacity                       0%                             -
otus  altroot                        -                              default
otus  health                         ONLINE                         -
otus  guid                           6554193320433390805            -
otus  version                        -                              default
otus  bootfs                         -                              default
otus  delegation                     on                             default
otus  autoreplace                    off                            default
otus  cachefile                      -                              default
otus  failmode                       wait                           default
otus  listsnapshots                  off                            default
otus  autoexpand                     off                            default
otus  dedupratio                     1.00x                          -
otus  free                           478M                           -
otus  allocated                      2.09M                          -
otus  readonly                       off                            -
otus  ashift                         0                              default
otus  comment                        -                              default
otus  expandsize                     -                              -
otus  freeing                        0                              -
otus  fragmentation                  0%                             -
otus  leaked                         0                              -
otus  multihost                      off                            default
otus  checkpoint                     -                              -
otus  load_guid                      1097054438351254924            -
otus  autotrim                       off                            default
otus  compatibility                  off                            default
otus  bcloneused                     0                              -
otus  bclonesaved                    0                              -
otus  bcloneratio                    1.00x                          -
otus  feature@async_destroy          enabled                        local
otus  feature@empty_bpobj            active                         local
otus  feature@lz4_compress           active                         local
otus  feature@multi_vdev_crash_dump  enabled                        local
otus  feature@spacemap_histogram     active                         local
otus  feature@enabled_txg            active                         local
otus  feature@hole_birth             active                         local
otus  feature@extensible_dataset     active                         local
otus  feature@embedded_data          active                         local
otus  feature@bookmarks              enabled                        local
otus  feature@filesystem_limits      enabled                        local
otus  feature@large_blocks           enabled                        local
otus  feature@large_dnode            enabled                        local
otus  feature@sha512                 enabled                        local
otus  feature@skein                  enabled                        local
otus  feature@edonr                  enabled                        local
otus  feature@userobj_accounting     active                         local
otus  feature@encryption             enabled                        local
otus  feature@project_quota          active                         local
otus  feature@device_removal         enabled                        local
otus  feature@obsolete_counts        enabled                        local
otus  feature@zpool_checkpoint       enabled                        local
otus  feature@spacemap_v2            active                         local
otus  feature@allocation_classes     enabled                        local
otus  feature@resilver_defer         enabled                        local
otus  feature@bookmark_v2            enabled                        local
otus  feature@redaction_bookmarks    disabled                       local
otus  feature@redacted_datasets      disabled                       local
otus  feature@bookmark_written       disabled                       local
otus  feature@log_spacemap           disabled                       local
otus  feature@livelist               disabled                       local
otus  feature@device_rebuild         disabled                       local
otus  feature@zstd_compress          disabled                       local
otus  feature@draid                  disabled                       local
otus  feature@zilsaxattr             disabled                       local
otus  feature@head_errlog            disabled                       local
otus  feature@blake3                 disabled                       local
otus  feature@block_cloning          disabled                       local
otus  feature@vdev_zaps_v2           disabled                       local
root@ubuntu-vm:~# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  2.04M                  -
otus  available             350M                   -
otus  referenced            24K                    -
otus  compressratio         1.00x                  -
otus  mounted               yes                    -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclmode               discard                default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        2.01M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           1020K                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              on                     default
otus  redundant_metadata    all                    default
otus  overlay               on                     default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0                      default
root@ubuntu-vm:~# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -
root@ubuntu-vm:~# zfs get readonly otus
NAME  PROPERTY  VALUE   SOURCE
otus  readonly  off     default
root@ubuntu-vm:~# zfs get recordsize otus
NAME  PROPERTY    VALUE    SOURCE
otus  recordsize  128K     local
root@ubuntu-vm:~# zfs get compression otus
NAME  PROPERTY     VALUE           SOURCE
otus  compression  zle             local
root@ubuntu-vm:~# zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local
```

## 3. Работа со снапшотами.
```
root@ubuntu-vm:~# wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
[1] 3595
root@ubuntu-vm:~#
Redirecting output to ‘wget-log’.
root@ubuntu-vm:~# ls
archive.tar.gz  otus_task2.file  wget-log  zpoolexport
[1]+  Done                    wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI
root@ubuntu-vm:~# zfs receive otus/test@today < otus_task2.file
root@ubuntu-vm:~# ls /otus
hometask2  test
root@ubuntu-vm:~# find /otus/test/ -name "secret_message"
/otus/test/task1/file_mess/secret_message
root@ubuntu-vm:~# cat /otus/test/task1/file_mess/secret_message
https://otus.ru/lessons/linux-hl/
```

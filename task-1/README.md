## Занятие 1. Обновление ядра системы

## Текст задания
- Запустите ВМ c Ubuntu.
- Обновите ядро ОС на новейшую стабильную версию из mainline-репозитория.
- Оформите отчет в README-файле в GitHub-репозитории.

## Основные команды
```
~ > VBoxManage startvm "Ubuntu Server 24.04.5" --type headless
Waiting for VM "Ubuntu Server 24.04.5" to power on...
VM "Ubuntu Server 24.04.5" has been successfully started.

~ > ssh apstol@192.168.0.100
The authenticity of host '192.168.0.100 (192.168.0.100)' can't be established.
ED25519 key fingerprint is: SHA256:U73yreWI/UOo8c1kUIZPrBXoPpyUU7hnmai+EwROb8o
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.0.100' (ED25519) to the list of known hosts.
apstol@192.168.0.100's password:
Welcome to Ubuntu 24.04.5 LTS (GNU/Linux 6.8.0-146-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Oct  1 06:24:28 AM UTC 2026

  System load:  0.68               Processes:               115
  Usage of /:   41.6% of 11.21GB   Users logged in:         0
  Memory usage: 10%                IPv4 address for enp0s3: 192.168.0.100
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

New release '26.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


apstol@ubuntu-vm:~$ uname -r
6.8.0-146-generic
apstol@ubuntu-vm:~$ mkdir kernel
apstol@ubuntu-vm:~$ cd kernel
apstol@ubuntu-vm:~/kernel$ ls
apstol@ubuntu-vm:~/kernel$ wget https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-headers-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb
--2026-10-01 06:24:59--  https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-headers-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.74, 185.125.189.76, 185.125.189.75
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.74|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4095082 (3.9M) [application/vnd.debian.binary-package]
Saving to: ‘linux-headers-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb’

linux-headers-7.1.3-070103-generi 100%[===========================================================>]   3.91M  1.83MB/s    in 2.1s

2026-10-01 06:25:01 (1.83 MB/s) - ‘linux-headers-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb’ saved [4095082/4095082]

apstol@ubuntu-vm:~/kernel$ wget https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-headers-7.1.3-070103_7.1.3-070103.202607041245_all.deb
--2026-10-01 06:25:07--  https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-headers-7.1.3-070103_7.1.3-070103.202607041245_all.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.76, 185.125.189.75, 185.125.189.74
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.76|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 14860428 (14M) [application/vnd.debian.binary-package]
Saving to: ‘linux-headers-7.1.3-070103_7.1.3-070103.202607041245_all.deb’

linux-headers-7.1.3-070103_7.1.3- 100%[===========================================================>]  14.17M  9.32MB/s    in 1.5s

2026-10-01 06:25:09 (9.32 MB/s) - ‘linux-headers-7.1.3-070103_7.1.3-070103.202607041245_all.deb’ saved [14860428/14860428]

apstol@ubuntu-vm:~/kernel$ wget https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-image-unsigned-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb
--2026-10-01 06:25:14--  https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-image-unsigned-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.76, 185.125.189.75, 185.125.189.74
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.76|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 17490112 (17M) [application/vnd.debian.binary-package]
Saving to: ‘linux-image-unsigned-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb’

linux-image-unsigned-7.1.3-070103 100%[===========================================================>]  16.68M  8.97MB/s    in 1.9s

2026-10-01 06:25:17 (8.97 MB/s) - ‘linux-image-unsigned-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb’ saved [17490112/17490112]

apstol@ubuntu-vm:~/kernel$ wget https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-modules-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb
--2026-10-01 06:25:22--  https://kernel.ubuntu.com/mainline/v7.1.3/amd64/linux-modules-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.74, 185.125.189.76, 185.125.189.75
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.74|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 170158272 (162M) [application/vnd.debian.binary-package]
Saving to: ‘linux-modules-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb’

linux-modules-7.1.3-070103-generi 100%[===========================================================>] 162.28M  11.1MB/s    in 25s

2026-10-01 06:25:49 (6.52 MB/s) - ‘linux-modules-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb’ saved [170158272/170158272]

apstol@ubuntu-vm:~/kernel$ sudo dpkg -i *.deb
[sudo] password for apstol:
Selecting previously unselected package linux-headers-7.1.3-070103.
(Reading database ... 88431 files and directories currently installed.)
Preparing to unpack linux-headers-7.1.3-070103_7.1.3-070103.202607041245_all.deb ...
Unpacking linux-headers-7.1.3-070103 (7.1.3-070103.202607041245) ...
Selecting previously unselected package linux-headers-7.1.3-070103-generic.
Preparing to unpack linux-headers-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb ...
Unpacking linux-headers-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
Selecting previously unselected package linux-image-unsigned-7.1.3-070103-generic.
Preparing to unpack linux-image-unsigned-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb ...
Unpacking linux-image-unsigned-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
Selecting previously unselected package linux-modules-7.1.3-070103-generic.
Preparing to unpack linux-modules-7.1.3-070103-generic_7.1.3-070103.202607041245_amd64.deb ...
Unpacking linux-modules-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
Setting up linux-headers-7.1.3-070103 (7.1.3-070103.202607041245) ...
Setting up linux-headers-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
Setting up linux-modules-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
Setting up linux-image-unsigned-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
I: /boot/vmlinuz is now a symlink to vmlinuz-7.1.3-070103-generic
I: /boot/initrd.img is now a symlink to initrd.img-7.1.3-070103-generic
Processing triggers for linux-image-unsigned-7.1.3-070103-generic (7.1.3-070103.202607041245) ...
/etc/kernel/postinst.d/initramfs-tools:
update-initramfs: Generating /boot/initrd.img-7.1.3-070103-generic
/etc/kernel/postinst.d/zz-update-grub:
Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-7.1.3-070103-generic
Found initrd image: /boot/initrd.img-7.1.3-070103-generic
Found linux image: /boot/vmlinuz-6.8.0-146-generic
Found initrd image: /boot/initrd.img-6.8.0-146-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
apstol@ubuntu-vm:~/kernel$ sudo poweroff

Broadcast message from root@ubuntu-vm on pts/1 (Thu 2026-10-01 06:26:47 UTC):

The system will power off now!

apstol@ubuntu-vm:~/kernel$ Connection to 192.168.0.100 closed by remote host.
Connection to 192.168.0.100 closed.

~ > VBoxManage startvm "Ubuntu Server 24.04.5" --type headless
Waiting for VM "Ubuntu Server 24.04.5" to power on...
VM "Ubuntu Server 24.04.5" has been successfully started.

~ > ssh apstol@192.168.0.100
apstol@192.168.0.100's password:
Welcome to Ubuntu 24.04.5 LTS (GNU/Linux 7.1.3-070103-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Oct  1 06:27:14 AM UTC 2026

  System load:  0.07               Processes:               120
  Usage of /:   46.4% of 11.21GB   Users logged in:         0
  Memory usage: 12%                IPv4 address for enp0s3: 192.168.0.100
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

New release '26.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Thu Oct  1 06:24:28 2026 from 192.168.0.104
apstol@ubuntu-vm:~$ uname -r
7.1.3-070103-generic
```

## Заметки
Использовалась версия ядра 7.1.3. Более новая 7.2.6 содержит баг, из-за которого ломается установка. Подробнее: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2148348#1

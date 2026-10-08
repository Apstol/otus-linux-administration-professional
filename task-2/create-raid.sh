#!/bin/bash

mdadm --zero-superblock /dev/sd{b,c,d,e}
mdadm --create --verbose /dev/md127 -l 10 -n 4 /dev/sd{b,c,d,e}

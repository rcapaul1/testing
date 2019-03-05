#!/bin/bash

yum install mailx hdparm -y
mkdir /mnt/ext4_journal && mkdir /mnt/ext4_no_journal && mkdir /mnt/xfs
mount /dev/sdb1 /mnt/ext4_journal && mount /dev/sdb2 /mnt/ext4_no_journal && mount /dev/sdb3 /mnt/xfs


hdparm -tT /dev/sdb1
hdparm -tT --direct /dev/sdb1
hdparm -tT /dev/sdb2
hdparm -tT --direct /dev/sdb2
hdparm -tT /dev/sdb3
hdparm -tT --direct /dev/sdb3

dd if=/dev/zero of=/mnt/ext4_journal/testfile bs=1G count=2 status=progress
dd if=/dev/zero of=/mnt/ext4_no_journal/testfile bs=1G count=2 status=progress
dd if=/dev/zero of=/mnt/xfs/testfile bs=1G count=2 status=progress

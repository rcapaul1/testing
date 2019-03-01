#!/bin/bash

mkdir /mnt/ext4_journal && mkdir /mnt/ext4_no_journal && mkdir /mnt/xfs
mount /dev/sdb1 /mnt/ext4_journal && mount /dev/sdb2 /mnt/ext4_no_journal && mount /dev/sdb3 /mnt/xfs


hdparm -tT /dev/sdb1 >/root/speedtest_read.txt && echo "ext4 mit Journal mit Cache" >>/root/speedtest_read.txt
hdparm -tT --direct /dev/sdb1 >>/root/speedtest_read.txt && echo "ext4 mit Journal ohne Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb2 >>/root/speedtest_read.txt && echo "ext4 ohne Journal mit Cache" >>/root/speedtest_read.txt
hdparm -tT --direct /dev/sdb2 >>/root/speedtest_read.txt && echo "ext4 ohne Journal ohne Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb3 >>/root/speedtest_read.txt && echo "xfs mit Cache" >>/root/speedtest_read.txt
hdparm -tT --direct /dev/sdb3 >>/root/speedtest_read.txt && echo "xfs ohne Cache" >>/root/speedtest_read.txt

echo "Speedtest Lesen der Partitionen" | mailx -a /root/speedtest_read.txt -s "Speedtest Read" rcapaul@hosttech.ch

dd if=/dev/zero of=/mnt/ext4_journal/testfile bs=1G count=2 status=progress
dd if=/dev/zero of=/mnt/ext4_no_journal/testfile bs=1G count=2 status=progress
dd if=/dev/zero of=/mnt/xfs/testfile bs=1G count=2 status=progress

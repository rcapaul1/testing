#!/bin/bash

hdparm -tT /dev/sdb1 >/root/speedtest_read.txt && echo "ext4 mit Journal mit Cache" >>/root/speedtest_read.txt
hdparm -tT --direct /dev/sdb1 >>/root/speedtest_read.txt && echo "ext4 mit Journal ohne Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb2 >>/root/speedtest_read.txt && echo "ext4 ohne Journal mit Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb2 --direct >>/root/speedtest_read.txt && echo "ext4 ohne Journal ohne Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb3 >>/root/speedtest_read.txt && echo "xfs mit Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb3 --direct >>/root/speedtest_read.txt && echo "xfs ohne Cache" >>/root/speedtest_read.txt

echo "Speedtest Lesen der Partitionen" | mailx -a /root/speedtest_read.txt -s "Speedtest Read" rcapaul@hosttech.ch

dd if=/dev/zero of=/dev/sdb1 bs=1M count=2048 conv=fdatasync,notrunc >/root/speedtest_write.txt && echo "ext4 mit Journal" >>/root/speedtest_write.txt
dd if=/dev/zero of=/dev/sdb2 bs=1M count=2048 conv=fdatasync,notrunc >>/root/speedtest_write.txt && echo "ext4 ohne Journal" >> /root/speedtest_write.txt
dd if=/dev/zero of=/dev/sdb3 bs=1M count=2048 conv=fdatasync,notrunc >>/root/speedtest_write.txt && echo "xfs" >> /root/speedtest_write.txt

echo "Speedtest Schreiben der Partitionen" | mailx -a /root/speedtest_write.txt -s "Speedtest Write" rcapaul@hosttech.ch

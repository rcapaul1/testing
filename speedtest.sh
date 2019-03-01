#!/bin/bash

hdparm -tT /dev/sdb1 >/root/speedtest_read.txt && echo "ext4 mit Journal mit Cache" >>/root/speedtest_read.txt
hdparm -tT --direct /dev/sdb1 >>/root/speedtest_read.txt && echo "ext4 mit Journal ohne Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb2 >>/root/speedtest_read.txt && echo "ext4 ohne Journal mit Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb2 --direct >>/root/speedtest_read.txt && echo "ext4 ohne Journal ohne Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb3 >>/root/speedtest_read.txt && echo "xfs mit Cache" >>/root/speedtest_read.txt
hdparm -tT /dev/sdb3 --direct >>/root/speedtest_read.txt && echo "xfs ohne Cache" >>/root/speedtest_read.txt

echo "Speedtest der Partitionen" | mailx -a /root/speedtest_read.txt -s "Speedtest" rcapaul@hosttech.ch
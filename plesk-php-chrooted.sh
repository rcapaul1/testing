#!/bin/bash

/root/update_chroot.sh --add /opt/plesk/php/7.0/bin/php ; /root/update_chroot.sh --add /opt/plesk/php/7.1/bin/php ; /root/update_chroot.sh --add /opt/plesk/php/7.2/bin/php ; /root/update_chroot.sh --add /opt/plesk/php/7.3/bin/php

mkdir /var/www/vhosts/chroot/usr/share ; cp -a /usr/share/zoneinfo /var/www/vhosts/chroot/usr/share/zoneinfo

for i in /opt/plesk/php/7.0/lib64/php/modules/*.so; do ./update_chroot.sh --add $i; done
for i in /opt/plesk/php/7.1/lib64/php/modules/*.so; do ./update_chroot.sh --add $i; done
for i in /opt/plesk/php/7.2/lib64/php/modules/*.so; do ./update_chroot.sh --add $i; done
for i in /opt/plesk/php/7.3/lib64/php/modules/*.so; do ./update_chroot.sh --add $i; done

cp -a /opt/plesk/php/7.0/etc /var/www/vhosts/chroot/opt/plesk/php/7.0/
cp -a /opt/plesk/php/7.1/etc /var/www/vhosts/chroot/opt/plesk/php/7.1/
cp -a /opt/plesk/php/7.2/etc /var/www/vhosts/chroot/opt/plesk/php/7.2/
cp -a /opt/plesk/php/7.3/etc /var/www/vhosts/chroot/opt/plesk/php/7.3/

sed -i.bkp 's/;date.timezone =/date.timezone = Europe\/Zurich/' /var/www/vhosts/chroot/opt/plesk/php/7.0/etc/php.ini
sed -i.bkp 's/;date.timezone =/date.timezone = Europe\/Zurich/' /var/www/vhosts/chroot/opt/plesk/php/7.1/etc/php.ini
sed -i.bkp 's/;date.timezone =/date.timezone = Europe\/Zurich/' /var/www/vhosts/chroot/opt/plesk/php/7.2/etc/php.ini
sed -i.bkp 's/;date.timezone =/date.timezone = Europe\/Zurich/' /var/www/vhosts/chroot/opt/plesk/php/7.3/etc/php.ini

/root/update_chroot.sh --apply all

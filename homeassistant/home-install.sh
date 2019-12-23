#!/bin/bash

git clone https://github.com/rcapaul1/debian10.git

bash testing/apt-run.sh
bash debian10/docker-install

apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat

systemctl disable ModemManager

curl -sL "https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh" | bash -s

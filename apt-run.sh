#!/bin/bash
cp /root/testing/.bashrc /root/.bashrc && cp /root/testing/.vimrc /root/.vimrc ; source /root/.bashrc ; source /root/.vimrc
apt update && apt upgrade -y && apt install git wget pandoc calc net-tools software-properties-common aptitude dirmngr whois dnsutils vim iperf3 nodejs npm -y && apt autoremove -y

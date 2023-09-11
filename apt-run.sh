#!/bin/bash
cp /root/testing/.bashrc /root/.bashrc && cp /root/testing/.vimrc /root/.vimrc ; source /root/.bashrc ; source /root/.vimrc
apt update && apt upgrade -y && apt install git wget net-tools software-properties-common aptitude dirmngr vim iperf3 -y && aptitude update && aptitude safe-upgrade -y && apt autoremove -y

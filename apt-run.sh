#!/bin/bash
cp /root/testing/.bashrc .bashrc && cp /root/testing/.vimrc .vimrc && source /root/.bashrc && source /root/.vimrc
apt update && apt upgrade -y && apt install git wget net-tools software-properties-common aptitude dirmngr vim -y && aptitude update && aptitude safe-upgrade -y

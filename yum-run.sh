#!/bin/bash
cp /root/testing/.bashrc .bashrc && cp /root/testing/.vimrc .vimrc && source /root/.bashrc && source /root/.vimrc
yum install epel-release git wget net-tools yum-utils vim -y && yum update -y && yum remove firewalld -y && yum groupinstall "Development Tools" -y

#!/bin/bash
source /root/.bashrc ; source /root/.vimrc
yum install epel-release git wget calc bind-utils whois iperf3 nodejs npm net-tools yum-utils vim -y && yum update -y && yum remove firewalld -y && yum groupinstall "Development Tools" -y

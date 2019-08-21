#!/bin/bash
yum install epel-release git wget net-tools yum-utils vim -y && yum update -y && yum remove firewalld -y && yum groupinstall "Development Tools" -y

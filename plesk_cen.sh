#!/bin/bash

cd /root/testing && git pull && cd && git clone https://github.com/rcapaul1/plesk.git && bash testing/yum-run.sh && bash plesk/oneclick.sh && plesk installer && plesk login

#!/bin/bash
cp testing/.bashrc .bashrc && cp testing/.vimrc .vimrc ; source .bashrc ; source .vimrc
apt update && apt upgrade -y && apt install git wget pandoc calc net-tools software-properties-common aptitude dirmngr whois dnsutils vim iperf3 nodejs npm -y && apt autoremove -y

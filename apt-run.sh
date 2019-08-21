#!/bin/bash
apt update && apt upgrade -y && apt install git wget net-tools software-properties-common aptitude vim -y && aptitude update && aptitude safe-upgrade -y

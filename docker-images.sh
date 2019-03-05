#!/bin/bash

docker pull plesk/plesk:17.8 && docker pull plesk/plesk:17.5 && docker pull debian:jessie && docker pull debian:stretch && docker pull centos && docker pull ubuntu:18.10 && docker pull ubuntu:18.04 && docker pull ubuntu:16.04 && docker pull mysql:5.6 && docker pull mysql:5.5 && docker pull mysql:5.7 && docker pull mariadb:10 && docker pull mariadb:10.1 && docker pull mariadb:10.2 && docker images

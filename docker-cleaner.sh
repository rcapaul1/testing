#!/bin/bash
docker rm -f $(docker ps -a -q) ; docker volume prune -f ; docker rmi -f $(docker images)

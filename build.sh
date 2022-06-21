#!/bin/sh

docker build -t jupyterlab-with-spark .
docker-compose up -d
#docker rmi $(docker images -f dangling=true)
docker ps -a | grep jupyterlab-with-spark

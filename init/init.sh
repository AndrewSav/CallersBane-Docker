#!/bin/sh

MYSQL_ROOT_PASSWORD=changeme;export MYSQL_ROOT_PASSWORD
IP_ADDRESS=127.0.0.1;export IP_ADDRESS
SERVER_NAME="Docker Server";export SERVER_NAME
SERVER_ID=docker-server;export SERVER_ID
MYSQL_SERVER=mysql;export MYSQL_SERVER

if [ "$MYSQL_ROOT_PASSWORD" = "changeme" ]
then
    echo "Please edit this file to specify MYSQL_ROOT_PASSWORD"
    exit
fi

if [ "$IP_ADDRESS" = "127.0.0.1" ]
then
    echo "Please specify non-local ip address Callers Baner server will be available on"
    exit
fi

if [ -d /c/mnt/docker/callersbane ]; then
    echo "It appears that callersbane directories are already set up. Please remove /c/mnt/docker/callersbane if you want to delete all data, then re-run this script"
    exit
fi

docker-compose up --build
docker-compose down

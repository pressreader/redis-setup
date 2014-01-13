#!/bin/bash

REDIS_VER=2.8.3
UPDATE_LINUX_PACKAGES=false #true|false
REDIS_INSTANCE_NAME=redis-server
REDIS_INSTANCE_PORT=6379

if [ ! -f redis-node-setup.sh ]
then
	wget https://github.com/eugene-kartsev/redis-setup/blob/master/redis-node-setup.sh
fi

sudo sh redis-node-setup.sh master $REDIS_VER $UPDATE_LINUX_PACKAGES $REDIS_INSTANCE_NAME $REDIS_INSTANCE_PORT

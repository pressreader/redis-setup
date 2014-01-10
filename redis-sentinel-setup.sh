#!/bin/bash

echo "THIS IS WORK IN PROGRESS SCRIPT. DO NOT USE IT."

exit 0

echo "*******************************************"
echo " 1. Update and install build packages"
echo "*******************************************"

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential

exit 0

echo "*******************************************"
echo " 2. Download, Unzip, Make Redis version: '$1'"
echo "*******************************************"

REDIS_VER=$1
#wget http://download.redis.io/releases/redis-$REDIS_VER.tar.gz
#tar xzf redis-$REDIS_VER.tar.gz
#rm redis-$REDIS_VER.tar.gz -f
cd redis-$REDIS_VER
make
sudo make install


echo "*******************************************"
echo " 3. Create 'redis' user, create folders, copy redis files "
echo "*******************************************"

sudo useradd redis

sudo mkdir /etc/redis /etc/redis-sentinel
sudo mkdir /var/lib/redis /var/lib/redis-sentinel
sudo mkdir /var/log/redis /var/log/redis-sentinel

sudo chown redis.redis /var/lib/redis
sudo chown redis.redis /var/log/redis
sudo chown redis.redis /var/lib/redis-sentinel
sudo chown redis.redis /var/log/redis-sentinel

sudo cp src/redis-server src/redis-cli src/redis-sentinel /usr/local/bin
sudo cp redis.conf /etc/redis/redis.conf
sudo cp sentinel.conf /etc/redis-sentinel/sentinel.conf

echo "*******************************************"
echo " 4. Configure /etc/redis/redis.conf "
echo "*******************************************"
echo " Edit redis.conf as follows:"
echo " 1: ... daemonize yes"
echo " 2: ... dir /var/lib/redis"
echo " 3: ... loglevel notice"
echo " 4: ... logfile /var/log/redis/redis.log"
echo " 5: ... #save 900 1"
echo " 5: ... #save 300 10"
echo " 5: ... #save 60 10000"


sudo sed -e "s/^daemonize no$/daemonize yes/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis\/redis.log/" -e "s/^save 900 1$/#save 900 1/" -e "s/^save 300 10$/#save 300 10/" -e "s/^save 60 10000$/#save 60 10000/" redis.conf > redis_tmp.conf

sudo cp redis_tmp.conf /etc/redis/redis.conf
sudo rm redis_tmp.conf -f

echo "*******************************************"
echo " 5. Configure /etc/redis-sentinel/sentinel.conf "
echo "*******************************************"
echo " Edit sentinel.conf as follows:"
echo " 1: ... daemonize yes"
echo " 2: ... dir /var/lib/redis-sentinel"
echo " 3: ... loglevel notice"
echo " 4: ... logfile /var/log/redis-sentinel/redis-sentinel.log"

sudo cp sentinel.conf sentinel_tmp.conf

sudo echo "daemonize yes" >> sentinel_tmp.conf
sudo echo "dir /var/lib/redis-sentinel" >> sentinel_tmp.conf
sudo echo "loglevel notice" >> sentinel_tmp.conf
sudo echo "logfile /var/log/redis-sentinel/redis-sentinel.log" >> sentinel_tmp.conf

sudo cp sentinel_tmp.conf /etc/redis-sentinel/sentinel.conf
sudo rm sentinel_tmp.conf -f


echo "*****************************************"
echo " 6. Move and Configure redis-server and redis-sentinel as daemons"
echo "*****************************************"

sudo cp redis-server /etc/init.d/redis-server
sudo cp redis-sentinel /etc/init.d/redis-sentinel

sudo chmod +x /etc/init.d/redis-server
sudo chmod +x /etc/init.d/redis-sentinel

echo "*****************************************"
echo " 7. Auto-Enable redis-server and redis-sentinel"
echo "*****************************************"

sudo update-rc.d redis-server defaults
sudo update-rc.d redis-sentinel defaults

echo "*****************************************"
echo " Installation Complete!"
echo ""
echo " Configure redis-server in /etc/redis/redis.conf"
echo " Configure redis-sentinel in /etc/redis-sentinel/sentinel.conf"
echo ""
echo " To start redis-server execute /etc/init.d/redis-server start"
echo " To start redis-sentinel execute /etc/init.d/redis-sentinel start"
echo ""
read -p "Press [Enter] to continue..."

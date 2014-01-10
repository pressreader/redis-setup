#!/bin/bash

REDIS_VER=2.8.3
UPDATE_PACKAGES=false #true|false
REDIS_INSTANCE_NAME= #use this property in case if
                     #several nodes are placed on the same host
                     #default value is 'redis-server'
REDIS_PORT=6379

if [ -z $REDIS_VER ]
then
	echo "ERROR: Redis version was not specified"
	exit 0
fi

if [ -z $REDIS_PORT ]
then
	echo "ERROR: Redis port was not specified"
	exit 0
fi


echo "*******************************************"
echo " 1. Update and install build packages: $UPDATE_PACKAGES"
echo "*******************************************"

if [ "$UPDATE_PACKAGES" = "true" ]
then
	echo $UPDATE_PACKAGES
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install build-essential
fi

echo "*******************************************"
echo " 2. Download, Unzip, Make Redis version: 'redis-$REDIS_VER"
echo "*******************************************"

wget http://download.redis.io/releases/redis-$REDIS_VER.tar.gz
tar xzf redis-$REDIS_VER.tar.gz
rm redis-$REDIS_VER.tar.gz -f
cd redis-$REDIS_VER
make
sudo make install
cd ..

echo "*******************************************"
echo " 3. Create 'redis' user, create folders, copy redis files "
echo "*******************************************"

if [ -z $REDIS_INSTANCE_NAME ]
then
	REDIS_INSTANCE_NAME=redis-server
fi

if [ -z $(cat /etc/passwd | grep redis) ]
then
	sudo useradd redis
fi

sudo mkdir /etc/$REDIS_INSTANCE_NAME
sudo mkdir /var/lib/$REDIS_INSTANCE_NAME
sudo mkdir /var/log/$REDIS_INSTANCE_NAME

sudo chown redis.redis /var/lib/$REDIS_INSTANCE_NAME
sudo chown redis.redis /var/log/$REDIS_INSTANCE_NAME

sudo cp redis-$REDIS_VER/src/redis-server /usr/local/bin/$REDIS_INSTANCE_NAME
sudo cp redis-$REDIS_VER/src/redis-cli /usr/local/bin/redis-cli
sudo cp redis-$REDIS_VER/redis.conf /etc/$REDIS_INSTANCE_NAME/redis.conf

echo "*******************************************"
echo " 4. Configure /etc/$REDIS_INSTANCE_NAME/redis.conf "
echo "*******************************************"
echo " Edit redis.conf as follows:"
echo " 1: ... daemonize yes"
echo " 2: ... pidfile /var/run/$REDIS_INSTANCE_NAME.pid"
echo " 3: ... port $REDIS_PORT"
echo " 4: ... dir /var/lib/$REDIS_INSTANCE_NAME"
echo " 5: ... loglevel notice"
echo " 6: ... logfile /var/log/$REDIS_INSTANCE_NAME/redis.log"
echo " 7: ... #save 900 1"
echo " 8: ... #save 300 10"
echo " 9: ... #save 60 10000"

sudo sed -e "s/^daemonize no$/daemonize yes/" -e "s/^pidfile \/var\/run\/redis\.pid$/pidfile \/var\/run\/$REDIS_INSTANCE_NAME\.pid/" -e "s/^port 6379$/port $REDIS_PORT/" -e "s/^dir \.\//dir \/var\/lib\/$REDIS_INSTANCE_NAME\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile \"\"$/logfile \/var\/log\/$REDIS_INSTANCE_NAME\/redis.log/" -e "s/^save 900 1$/#save 900 1/" -e "s/^save 300 10$/#save 300 10/" -e "s/^save 60 10000$/#save 60 10000/" redis-$REDIS_VER/redis.conf > redis_tmp.conf

sudo cp redis_tmp.conf /etc/$REDIS_INSTANCE_NAME/redis.conf
sudo rm redis_tmp.conf -f

echo "*****************************************"
echo " 5. Move and Configure redis-server daemon"
echo "*****************************************"
echo " Edit redis.conf as follows:"
echo " 1: ... DAEMON_ARGS=/etc/$REDIS_INSTANCE_NAME/redis.conf"
echo " 2: ... DAEMON=/usr/local/bin/$REDIS_INSTANCE_NAME"

sudo sed -e "s/^DAEMON_ARGS=\/etc\/redis\/redis\.conf$/DAEMON_ARGS=\/etc\/$REDIS_INSTANCE_NAME\/redis\.conf/" -e "s/^DAEMON=\/usr\/local\/bin\/redis-server$/DAEMON=\/usr\/local\/bin\/$REDIS_INSTANCE_NAME/" init_d_redis-server > redis-server_tmp

sudo cp redis-server_tmp /etc/init.d/$REDIS_INSTANCE_NAME
rm redis-server_tmp -f

sudo chmod +x /etc/init.d/$REDIS_INSTANCE_NAME

echo "*****************************************"
echo " 7. Auto-Enable redis-server and redis-sentinel"
echo "*****************************************"

sudo update-rc.d $REDIS_INSTANCE_NAME defaults

rm redis-$REDIS_VER -r

echo "*****************************************"
echo " Installation Complete!"
echo ""
echo " Configure $REDIS_INSTANCE_NAME in /etc/$REDIS_INSTANCE_NAME/redis.conf"
echo ""
echo " WARNING: Service isn't started by default. "
echo " Use the following command to manipulate [$REDIS_INSTANCE_NAME] Redis service:"
echo " sudo /etc/init.d/$REDIS_INSTANCE_NAME [start|stop|restart]"
echo ""

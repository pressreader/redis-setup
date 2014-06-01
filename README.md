## How to setup Redis MASTER instance (Ubuntu)

	mkdir redis-setup
	cd redis-setup
	wget https://raw2.github.com/PressReader/redis-setup/master/redis-master-setup.sh
	
Edit 'redis-master-setup.sh' file, change the following properties (if you need to):

	REDIS_VER=2.8.3
	UPDATE_LINUX_PACKAGES=false
	REDIS_INSTANCE_NAME=redis-server
	REDIS_INSTANCE_PORT=6379	

Run script:

	sudo sh redis-master-setup.sh

After the execution you'll se something like:

	*****************************************
	 Installation Complete!
	
	 Configure redis-server in /etc/redis-server/redis.conf
	
	 WARNING: Service isn't started by default.
	 Use the following command to manipulate [redis-server] Redis service:
	 sudo /etc/init.d/redis-server [start|stop|restart]

Run the following command to start Redis service:

	sudo /etc/init.d/redis-server start

Check that the service has been started:

	redis-cli -p 6379 info replication

The output should look similar to:

	# Replication
	role:master
	connected_slaves:0
	master_repl_offset:0
	repl_backlog_active:0
	repl_backlog_size:1048576
	repl_backlog_first_byte_offset:0
	repl_backlog_histlen:0


## How to setup Redis SLAVE instance (Ubuntu)

	mkdir redis-setup
	cd redis-setup
	wget https://raw2.github.com/PressReader/redis-setup/master/redis-slave-setup.sh

Edit 'redis-slave-setup.sh' file:

	REDIS_VER=2.8.3
	UPDATE_LINUX_PACKAGES=false
	REDIS_INSTANCE_NAME=redis-server-slave6380
	REDIS_INSTANCE_PORT=6380
	REDIS_MASTER_IP=127.0.0.1
	REDIS_MASTER_PORT=6379

Run script:

	sudo sh redis-slave-setup.sh

Output:

	*****************************************
	 Installation Complete!
	
	 Configure redis-server in /etc/redis-server-slave6380/redis.conf
	
	 WARNING: Service isn't started by default.
	 Use the following command to manipulate [redis-server] service:
	 sudo /etc/init.d/redis-server-slave6380 [start|stop|restart]

Run command:

	sudo /etc/init.d/redis-server-slave6380 start

Check that the server has been started:

	redis-cli -p 6380 info replication

Output:

	# Replication
	role:slave
	master_host:127.0.0.1
	master_port:6379
	master_link_status:down
	master_last_io_seconds_ago:-1
	master_sync_in_progress:0
	slave_repl_offset:1
	master_link_down_since_seconds:1389693215
	slave_priority:100
	slave_read_only:1
	connected_slaves:0
	master_repl_offset:0
	repl_backlog_active:0
	repl_backlog_size:1048576
	repl_backlog_first_byte_offset:0
	repl_backlog_histlen:0


## How to setup Redis Sentinel (Ubuntu)

	mkdir redis-sentinel
	cd redis-sentinel
	wget https://raw2.github.com/PressReader/redis-setup/master/redis-sentinel-setup.sh

Edit 'redis-sentinel-setup.sh' file:

	REDIS_VER=2.8.3
	SENTINEL_PORT=26379 #default port: 26379
	REDIS_MASTER_IP=127.0.0.1	
	REDIS_MASTER_PORT=6379
	SENTINEL_QUORUM=1
	UPDATE_LINUX_PACKAGES=false #true|false

Run script:

	sudo sh redis-sentinel-setup.sh

Output:

	*****************************************
 	Installation Complete!
	
	Configure redis-sentinel in /etc/redis-sentinel/sentinel.conf

	WARNING: Service isn't started by default.
	User the following command to manipulate redis-sentinel instance.
	sudo /etc/init.d/redis-sentinel [start|stop|restart]

Start sentinel service:

	sudo /etc/init.d/redis-sentinel start

Check Sentinel instance:

	redis-cli -p 26379 info sentinel

Output:

	# Sentinel
	sentinel_masters:1
	sentinel_tilt:0
	sentinel_running_scripts:0
	sentinel_scripts_queue_length:0
	master0:name=mymaster,status=ok,address=127.0.0.1:6379,slaves=3,sentinels=1

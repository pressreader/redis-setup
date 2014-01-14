## How to setup Redis master instance (Ubuntu)

	mkdir redis-setup
	cd redis-setup
	wget https://raw2.github.com/eugene-kartsev/redis-setup/master/redis-master-setup.sh
	
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

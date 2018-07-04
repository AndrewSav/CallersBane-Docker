# Sample install on stand-alone Docker server with a fresh mysql container

There is a `docker-compose.yml` in the [example folder](../example) which brings up a Caller's Bane container along with mysql container. This setup require those two containers to be connected to volumes with existing data. This folder scripts help creating these initial data for both Caller's Bane and mysql.

- init.sh - this is the script to run on Linux that you run to create the data. **Edit it before running!**
- init.ps1 - same as above but for Windows
- Dockerfile - a temporary container to perform data initialization
- entry.sh - the shell script that runs in the temporary container and initializes the data
- docker-compose.yml - descrives the temporary container and mysql container composition required for data intialization

Feel free to edit any and all of these files. They assume that your data will be located in `c:\mnt\docker\callersbane` on windows or in `/c/mnt/docker/callersbane` on Linux. Before you start please modify `init.sh` or `init.ps1` depending on where you are running it on, Window or Linux.

- MYSQL_ROOT_PASSWORD - generate a strong mysql password and specify it here. The mysql data will be initialized with this password and the same password will be written into `hibernate.cfg.xml` for use by Caller's Bane container. Note, that you might want to refrain from using special characters in the password, as they could interfer with serach and replace script. Characters like `/\"'&*` are especially problematic, do not use these.
- IP_ADDRESS - for some reason related to docker in some configuration 127.0.0.1 does not work. Change it to the actual IP address, even if you are running locally. This value goes to the `server` table in mysql, and this is the address the Caller's Bane client used to connect to the server after initial connection to the lobby. This assumes single server setup where both lobby and the server roles are fulfilled by the same Caller's Bane server instance.
- SERVER_NAME - this is in-game server name such as "My kewl server". It goes to the server table in mysql
- SERVER_ID - this is server id that corresponds to the name above, e.g. "kewl-server". Goes to the same mysql table.
- MYSQL_SERVER - do not change this one, unless you know why you want it, this goes to the `hibernate.cfg.xml` so that the Caller's Bane server can find mysql server. The port is 3306. If the Caller's Bane server and the mysql server are on the same network, as per the docker-compose file in the `example` folder, then this is the name of mysql server that the docker-compose file specifies.

Once you edited either `init.sh` or `init.ps1` make sure that `/c/mnt/docker/callersbane` folder as described above does not exist. If it exists it means that you already have Caller's Bane server data and you need to be very sure you want to delete them because once you do - you lost them. One way or another make sure that the folder does not exist before running the init.

I tested this both on Linux and Windows, but on Windows I had to do some work-around for [quirks introduced in the latest version](https://github.com/docker/for-win/issues/1829). I tested with version `18.03.1-ce-win65 (17513)` so your milage may vary. Linux is usually much more predictable in that regard.

This is what the script does:

- Creates and mounts the two data folder required by the example setup: one for mysql and one for caller's bane containers
- Runs mysql to initialize database with the provided password
- Put's the connection data specified to `hibernate.cfg.xml` which is copied to the caller's bane folder
- Updates the sql script for database initialization provided by <https://callersbane.com/> with server name, id and ip specified
- Executes script on the mysql database

When the script is finished, temporary containers are removed and the data now is left behind in respective folder. You can run the example now.

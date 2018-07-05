# Troubleshooting Caller's Bane server setup

This lists some problems I came across while trying to get the Caller's Bane server up and running. It is not limited to docker related issues. The reader is encouraged to read `installation_instructions.txt` from the installation archive first as familiarity  with this document is assumed. I used mysql 5.7 for all my testing.

## Caller's Bane Server gives a connection exception

Sometimes an exception is thrown similar to this one:

```text
Exception in thread "main" java.lang.ExceptionInInitializerError
        at platform.model.entity.vars.Vars.test(Vars.java:237)
        at platform.Server.main(Server.java:26)
Caused by: javax.persistence.PersistenceException: org.hibernate.exception.GenericJDBCException: Could not open connection
        at org.hibernate.ejb.AbstractEntityManagerImpl.convert(AbstractEntityManagerImpl.java:1387)
        at org.hibernate.ejb.AbstractEntityManagerImpl.convert(AbstractEntityManagerImpl.java:1310)
        at org.hibernate.ejb.AbstractEntityManagerImpl.throwPersistenceException(AbstractEntityManagerImpl.java:1397)
        at org.hibernate.ejb.TransactionImpl.begin(TransactionImpl.java:62)
        at platform.model.entity.Dao.entityManager(Dao.java:68)
        at platform.model.entity.Dao.getEntityManager(Dao.java:142)
        at platform.model.entity.Dao.findById(Dao.java:173)
        at platform.model.entity.Server.findByConfigId(Server.java:66)
        at platform.util.LogUtil.<clinit>(LogUtil.java:24)
        ... 2 more
```

This usually indicates that Caller's Bane server cannot connect to mysql server instance. I've seen this error both in case of wrong credentials and when the server/port are not accessible.

## Caller's Bane Server gives ExceptionInInitializerError soon after starting

You might observe an exception like this:

```text
Exception in thread "main" java.lang.ExceptionInInitializerError
        at platform.model.entity.vars.Vars.test(Vars.java:231)
        at platform.Server.main(Server.java:26)
Caused by: java.lang.NullPointerException
        at platform.util.LogUtil.<clinit>(LogUtil.java:24)
        ... 2 more
```
This error might indicate that the server name you passed on the command line when starting Caller's Bane server (`-Dscrolls.node.id=test-server`) does not exist int the `servers` table on your mysql server. This is usually resolved  by changing either the command line or data in the `servers` table to match.

## Caller's Bane Client connects but then immediately disconnects

This usually indicates that the server ip address in the `servers` table on mysql is not reachable by the client, or it does not have Caller's Bane server running.

It appears that the Server was written with a potential to set up several  servers in a cluster performing  different roles: GAME, LOBBY, RESOURCE, LOOKUP, JOBS. So the client first connect to the server, and then the server fetches the IP address for the LOBBY from mysql. It comes from the `servers` table. If this IP address is not reachable or does not host the Caller's Bane server, the client disconnects. The most common reason if the IP in the table left as it's default value of `127.0.0.1` and the server is hosted on a different machine. Another reason is when it is on the same machine, but running in a docker containers. This configuration sometimes require specifying an actual IP address and not 127.0.0.1, this is because the meaning of 127.0.0.1 is different inside and outside of a container.

If you host your server in the internet, specify the ip address in the `servers` table. If you host it in docker, specify the ip address of the host machine (it can be local network ip, if you are only ever connect to it from the local network).

## When going to Black market tab in the client the client crashes

Some Black Market sql statements seem to assume that [sql mode](https://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_sql-mode) does not include ONLY_FULL_GROUP_BY option. This option be default is off for some minor versions of mysql 5.7 but not for the others. The three ways of changing this option are:

- At runtime run `SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));` - this does not survive reboot
- Edit my.cnf. The file name [differs for different OS flavours](https://stackoverflow.com/a/37248560/284111)
- Specify it on command line when starting mysqld (E.g. `--sql-mode=NO_ENGINE_SUBSTITUTION`)

Additional references: [1](http://johnemb.blogspot.com/2014/09/adding-or-removing-individual-sql-modes.html), [2](https://stackoverflow.com/q/23921117/284111), [3](http://mysqlserverteam.com/mysql-5-7-only_full_group_by-improved-recognizing-functional-dependencies-enabled-by-default/), [4](https://github.com/WakingStones/CallersBane-Issues/issues/3)

As the last link above suggests, Black Market prices may be problematic with this fix.

## Other issues

There is a bug tracker [here](https://github.com/WakingStones/CallersBane-Issues/issues). User aronnie on [discord](https://discord.gg/QKGmvZh) mentioned on 5th of July 201 that he is part of the former dev team for Scrolls, and that all these issue on this bug tracker are going to be addressed in a few weeks time.

## Additional troubleshooting

Apparently, Caller's bane server uses [logback](https://logback.qos.ch/manual/configuration.html) for its logging needs. If we copy sample configuration file from the page linked above and paste it to [logback-test.xml](logback-test.xml) located in the cfg subfolder of the Caller's Bane server folder along with `hibernate.cfg.xml`, Caller's Bane server starts producing much verbose log on the console, which can help further troubleshooting.

## Quick way to stand up local mysql server docker container for testing with local Caller's Bane server.

If you are on Windows, make sure you are in `cmd.exe` not in `powershell` and pre-create the data directory for mysql data volume. If you are reusing an existing directory from a previous attempt (windows or linux), be mindful, that the root password will be the one that you specified last time around, not the one that you will pass to docker container now.

```cmd
mkdir "C:/mnt/docker/callersbane/mysql"
```

Now create mysql docket container:

```bash
docker run --name mysql-callersbane -v /c/mnt/docker/callersbane/mysql:/var/lib/mysql -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=changeme mysql:5.7.22
```

Wait for it to come up it can take some (short) time. You can monitor progress with:

```bash
docker logs -f mysql-callersbane
```
Once up, run callerbane setup script:

```bash
docker exec -i mysql-callersbane mysql -h 127.0.0.1 -u root -p"changeme" < callersbane_database.sql 
```
That's it. Delete the container as usual, when you are done:
                                                            
```bash
docker rm -f mysql-callersbane
```

Note, that this won't delete the data, so next time you create the mysql container with the same command line, the data will still be there. 

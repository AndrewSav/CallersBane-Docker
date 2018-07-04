#!/bin/sh

echo "Writing hibernate.cfg.xml..."
cp init/hibernate.cfg.xml data/hibernate.cfg.xml  
sed -i "s&<property name=\"hibernate.connection.password\"></property>&<property name=\"hibernate.connection.password\">$MYSQL_ROOT_PASSWORD</property>&g" data/hibernate.cfg.xml 
sed -i "s&127\.0\.0\.1&$MYSQL_SERVER&g" data/hibernate.cfg.xml

echo "Writing callersbane_database.sql..."
cp init/callersbane_database.sql init/init.sql
sed -i "s/127\.0\.0\.1/$IP_ADDRESS/g" init/init.sql
sed -i "s/test-server/$SERVER_ID/g" init/init.sql
sed -i "s/Test Server Name/$SERVER_NAME/g" init/init.sql

echo "Waiting for mysql..."
until mysqladmin ping -h"$MYSQL_SERVER" -P"3306" --silent
do
  echo "Mysql is not ready. Waiting 5 seconds..."
  sleep 5
done

echo -e "Mysql is ready"

echo "Executing callersbane_database.sql..."
mysql -h"mysql" -u root -p"$MYSQL_ROOT_PASSWORD" < init/init.sql

echo "Stopping mysql..."
docker stop init_mysql

echo "Done!"

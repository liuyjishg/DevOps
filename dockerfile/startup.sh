#!/bin/bash

#chmod -R mysql:mysql /var/lib/mysql

#mysql_install_db --user=mysql
#sleep 2
#mysql_safe --user=mysql &
#sleep 5
#mysql < /opt/full.sql
#sleep 5
#ps -ef |grep mysql|grep -v grep |awk '{print $2}' |xargs kill -9
#sleep 5
mysql_safe --user=mysql --datadir=/var/lib/mysql >> /var/log/mariadb/mariadb.log
sleep 3
tail -f /var/log/mariadb/mariadb.log


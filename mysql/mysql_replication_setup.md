# mysql replication setup

## Add the following to the config on the primary server
```
nano /etc/mysql/percona-server.conf.d/mysqld.cnf
bind-address = 0.0.0.0
server-id                       = 1
log-bin                         = /var/lib/mysql/mysql-bin
expire-logs-days                = 2
max-binlog-size                 = 1000M
binlog-format                   = ROW
```

## Restart mysql service
```
systemctl restart mysql
```

## Create backup on primary
```
xtrabackup --backup --user=<placeholder> --password=<placeholder> --target-dir=/path/to/backupdir
```

## Once that is done, prepare the backup
```
xtrabackup --user=<placeholder> --password=<placeholder> --prepare --target-dir=/path/to/backupdir
```

## Copy backup to replica
```
rsync -a --progress /path/to/backupdir <placeholderUser>@<placeholderReplicaAddress>:/path/to/temporaryLocation
```
## Stop MySQL service on secondary
```
systemctl stop mysql
```

## Backup existing MySQL data (optional)
```
mv /var/lib/mysql /path/to/mysql/datadir_backup
```

## Move backup from primary to the MySQL data directory
```
xtrabackup --move-back --target-dir=/path/to/backupdir
```

## Modify permissions
```
chown -R mysql:mysql /var/lib/mysql
```

## Create replication user on primary (within MySQL instance)
```
GRANT REPLICATION SLAVE ON *.* TO '<replicationUser>'@'%' IDENTIFIED BY '<placeholderPassword>';
```

## Test by going onto the replica server and trying to connect to the primary
```
mysql --host=<placeholderPrimaryAddress> --user=repl --password=<placeholderPassword>
```

## Verify privileges
```
SHOW GRANTS FOR <replicationUser>;
```

## Add the following to the config on the replica server
```
nano /etc/mysql/percona-server.conf.d/mysqld.cnf
bind-address = 0.0.0.0
server-id                       = 2
read-only                       = 1
```

## Restart the MySQL service on the replica server
```
systemctl restart mysql
```

## Check contents of the xtrabackup_binlog_info_innodb file
```
cat /var/lib/mysql/xtrabackup_binlog_pos_innodb
```

### The log file name and position number shown are to be input with the CHANGE MASTER command below

## Within the MySQL instance on the replica, execute the CHANGE MASTER command
```
CHANGE MASTER TO
MASTER_HOST='<placeholderPrimaryAddress>',
MASTER_USER='<replicationUser>',
MASTER_PASSWORD='<placeholderPassword>',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=<placeholderNumber>;
```

## Run the START SLAVE command (within MySQL instance)
```
START SLAVE;
```

## Check replication status (within MySQL instance)
```
SHOW SLAVE STATUS \G
```
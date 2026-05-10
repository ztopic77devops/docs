## List users
```
select * from mysql.user;
```

## List all users and rights
```
select * from information_schema.user_privileges;
```

## Create user
```
CREATE USER '<placeholderUsername>'@'%' IDENTIFIED BY '<placeholderPassword>';
```

## Delete user
```
DROP USER 'username'.'*';
```

## Show grants for specific user
```
show grants for <username>;
```

## Grant all privileges on all databases for user
```
GRANT ALL PRIVILEGES ON *.* TO '<placeholderUsername>'@'%';

Command grants all privileges on all databases and any tables within those databases. In case you want to grant privileges to a all tables in specific database use “<databaseName>.*” instead of “*.*”. If you want to grant privileges on one specific table then use “<databaseName>.<>” instead of “*.*”.
```

## Grant all privileges to single database for user
```
grant all privileges on <databaseName>.* to <username>;
```

## Grant read only on single database
```
grant select on <databaseName>.* to username;
```

## Rights meaning
```
ALL PRIVILEGES - this would allow a MySQL user all access to a designated database (or if no database is selected, across the system)
CREATE - allows them to create new tables or databases
DROP - allows them to them to delete tables or databases
DELETE - allows them to delete rows from tables
INSERT - allows them to insert rows into tables
SELECT - allows them to use the Select command to read through databases
UPDATE - allow them to update table rows
GRANT OPTION - allows them to grant or remove other users' privileges
```

## Show table sizes sorted from largest to smallest
```
SELECT 
     table_schema as `Database`, 
     table_name AS `Table`, 
     round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` 
FROM information_schema.TABLES 
ORDER BY (data_length + index_length) DESC;
```

## Change password
```
ALTER USER '<username>'@'*' IDENTIFIED BY '<password>';

# or

update user set authentication_string=PASSWORD("<password>") where User='<username>';
```

## Create database
```
CREATE DATABASE IF NOT EXISTS `ime_baze` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
```

## Delete all from mysql
```
systemctl stop mysql
cd /var/lib/mysql
rm -R *
```

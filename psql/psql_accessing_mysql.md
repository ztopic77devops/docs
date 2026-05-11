# Mysql Server Side

## create mysql user
```
create user '<username>' identified by '<password>';
```

## grant rights
```
grant select on dev_flex_config.* to <username>;
```

# Postgres Server Side

## install mysql_fdw
```
apt install postgresql-10-mysql-fdw
```

## enter postgres
```
su postgres
psql
```

## enter database
```
\c <database_name>
```

## create extension
```
create extension mysql_fdw;
```

## create server
```
CREATE SERVER mysql_svr FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host '<mysql_server_hostname>',port '3306');
```

## create user
```
CREATE ROLE <username> WITH SUPERUSER LOGIN ENCRYPTED PASSWORD '<password>';
```

## map user (mysql user credential)
```
CREATE USER MAPPING FOR <username> SERVER mysql_svr OPTIONS (username '<username>',password '<password>');
```

## mapirati postgres usera zbog importa
```
CREATE USER MAPPING FOR postgres SERVER mysql_svr OPTIONS (username '<username>',password '<password>');
```

## convert enum as a tekst
```
CREATE TYPE rating_t AS enum('G','PG','PG-13','R','NC-17');
```

## import schema
```
IMPORT FOREIGN SCHEMA <database_name> FROM SERVER mysql_svr INTO public;
```
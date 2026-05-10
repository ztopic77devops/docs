# MYSQL dump

## single database
```
/usr/bin/mysqldump --single-transaction=true <database_name> | bzip2 -c > /<path-to-dir>/$(date +%Y-%m-%d-%H.%M.%S)_<database_name>.sql.bz2
```

## import
```
mysql -u root -p <database_name> < db_name.sql

### or compressed

bunzip2 < db_name.sql.bz2 | mysql -u root target_db_name
```

## dump all
```
mysqldump -u root --single-transaction=true --all-databases > alldb.sql
```

## import all
```
mysql -u root < alldb.sql
```
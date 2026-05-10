# MySQL data migration

## dump all
```
HOSTvar=$(hostname -f); DATEvar=$(date +%Y-%m-%d_%H-%M-%S); mysqldump -u root --single-transaction=true --all-databases > /<path-to-dir>/mysqldump_${HOSTvar}_${DATEvar}.sql

# or compressed

HOSTvar=$(hostname -f); DATEvar=$(date +%Y-%m-%d_%H-%M-%S); mysqldump -u root --single-transaction=true --all-databases | bzip2 -c > /<path-to-dir>/mysqldump_${HOSTvar}_${DATEvar}.sql.bz2

# or simple

/usr/bin/mysqldump -u root --single-transaction=true --all-databases > alldb.sql
```

## import all
```
mysql -u root < <fileName>.sql

# or compressed

bunzip2 < <fileName>.sql.bz2 | mysql -u root

```

## dump single database
```
HOSTvar=$(hostname -f); DATEvar=$(date +%Y-%m-%d_%H-%M-%S); mysqldump --single-transaction=true <dbName> > /<path-to-dir>_${HOSTvar}_${DATEvar}.sql

# or compressed

HOSTvar=$(hostname -f); DATEvar=$(date +%Y-%m-%d_%H-%M-%S); mysqldump --single-transaction=true <dbName> | bzip2 -c > /<path-to-dir>_${HOSTvar}_${DATEvar}.sql.bz2

# or simple

/usr/bin/mysqldump --single-transaction=true <database_name> | bzip2 -c > /<path-to-dir>/$(date +%Y-%m-%d-%H.%M.%S)_<database_name>.sql.bz2
```

## import single database
```
mysql -u root -p <targetDbName> < <fileName>.sql

or compressed

bunzip2 < <fileName>.sql.bz2 | mysql -u root -p <targetDbName>
```










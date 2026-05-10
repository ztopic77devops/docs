# Mongodump
```
mongodump \
  --username=root \
  --password="<password>" \
  --authenticationDatabase=admin \
  --gzip \
  --out=/home/<user>/<newDir>/<dumpName>
```

# Example with automatic hostname + timestamp
```
HOSTvar=$(hostname -f)
DATEvar=$(date +%Y-%m-%d_%H-%M-%S)

mongodump \
  --username=root \
  --password="<password>" \
  --authenticationDatabase=admin \
  --gzip \
  --out=/home/<user>/dump_${HOSTvar}_${DATEvar}
```

# With oplog (recommended for replica sets)
```
mongodump \
  --oplog \
  --username=root \
  --password="<password>" \
  --authenticationDatabase=admin \
  --gzip \
  --out=/home/<user>/<newDir>/<dumpName>
```

# Transfer the mongodump
```
rsync -a --progress \
  /home/<user>/<newDir>/<dumpName> \
  <user>@<hostname-or-ip>:/home/<user>/
```

# Restore the mongodump on the new host
```
mongorestore \
  --username=root \
  --password="<password>" \
  --authenticationDatabase=admin \
  --gzip \
  /home/<user>/<dumpName>
```
# Restore with oplog replay
```
mongorestore \
  --oplogReplay \
  --username=root \
  --password="<password>" \
  --authenticationDatabase=admin \
  --gzip \
  /home/<user>/<dumpName>
```

# Restore only a single database from a full dump
```
mongorestore \
  --username=root \
  --password="<password>" \
  --authenticationDatabase=admin \
  --gzip \
  --nsInclude="<database_name>.*" \
  /home/<user>/<dumpName>
```

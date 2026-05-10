# MongoDB

## install
```
# install

apt update

apt-get install -y gnupg2 wget curl

wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
# PAY ATTENTION TO THE MONGODB VERSION NUMBER
# (.../server-6.0.asc)

echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/6.0 main" \
| sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
# PAY ATTENTION TO:
# - Debian version (buster, bullseye, bookworm)
# - MongoDB version (6.0)

apt-get update

apt-get install -y \
  mongodb-org \
  mongodb-org-database \
  mongodb-org-server \
  mongodb-org-shell \
  mongodb-org-mongos \
  mongodb-org-tools

systemctl start mongod
systemctl enable mongod
```

# Single instance setup
## Enter mongo and create a root user
```
mongosh

use admin
db.createUser({ user: 'root', pwd: passwordPrompt(), roles: [{ role: "root", db: "admin" }]})
```

## Edit /etc/mongod.conf to enable security and other required setup options as per example
```
# mongod.conf
# for documentation of all options, see:
# http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb

  journal:
    enabled: true

  # wiredTiger:
  #   engineConfig:
  #     cacheSizeGB: 3

  oplogMinRetentionHours: 48

  # engine:
  #   mmapv1:

  # wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0

# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo

security:
  authorization: enabled
  keyFile: /var/lib/mongodb/keyfile

# operationProfiling:

replication:
  replSetName: <replicaSetName> # CHANGE THIS

# sharding:

## Enterprise-Only Options:

# auditLog:

# snmp:

cloud:
  monitoring:
    free:
      state: on
```

## Restart the mongod instance, then log in with the root username and the associated password
```
systemctl restart mongod
mongo admin -u root -p '<password>'
```

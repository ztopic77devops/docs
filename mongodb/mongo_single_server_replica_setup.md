# Single server replica set setup

## Enter mongo and create a root user
```
mongosh admin -u root -p '<password>'

use admin
db.createUser({ user: 'root', pwd: passwordPrompt(), roles: [{ role: "root", db: "admin" }]})
```

## Edit mongod.conf, mongod2.conf and mongod3.conf as per example to enable security and other required setup options
```
# mongod.conf

storage:
  dbPath: /var/lib/mongodb # add number if single server replica set (mongodb2, mongodb3)

  journal:
    enabled: true

  wiredTiger:
    engineConfig:
      cacheSizeGB: 1

  oplogMinRetentionHours: 48

systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log # add number if single server replica set (mongod2.log, mongod3.log)

net:
  port: 27017 # increase if single server replica set (second instance: 27018, third: 27019)
  bindIp: 0.0.0.0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

# replication:
#   replSetName: rs0 # replica set name CHANGE THIS

security:
  authorization: enabled

  # keyFile: /var/lib/mongodb/keyfile
  # add number if single server replica set
  # (.../mongodb2/..., .../mongodb3/...)

cloud:
  monitoring:
    free:
      state: on
```

## Restart mongod
```
systemctl restart mongod
```

## Copy /etc/mongod.conf into mongod2.conf and mongod3.conf
```
cp /etc/mongod.conf /etc/mongod2.conf; cp /etc/mongod.conf /etc/mongod3.conf
```

## Navigate to /lib/systemd/system
```
cd /lib/systemd/system/
```

## Copy mongod.service into mongod2.service and mongod3.service
```
cp mongod.service mongod2.service; cp mongod.service mongod3.service
```

## Edit mongod2.service and mongod3.service
```
[Unit]
Description=MongoDB Database Server
Documentation=https://docs.mongodb.org/manual
After=network-online.target
Wants=network-online.target

[Service]
User=mongodb
Group=mongodb
EnvironmentFile=-/etc/default/mongod
# add number if single server replica set (/etc/mongod2.conf, /etc/mongod3.conf)
ExecStart=/usr/bin/mongod --config /etc/mongod.conf
# add number if single server replica set (.../mongod2.pid, .../mongod3.pid)
PIDFile=/var/run/mongodb/mongod.pid
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false

# Recommended limits for mongod as specified in
# https://docs.mongodb.com/manual/reference/ulimit/#recommended-ulimit-settings

[Install]
WantedBy=multi-user.target
```

## Create directories and permissions
```
mkdir -p /var/lib/mongodb2
mkdir -p /var/lib/mongodb3

chown -R mongodb:mongodb /var/lib/mongodb2
chown -R mongodb:mongodb /var/lib/mongodb3
```

## Generate a random base64 string into a keyfile file, then copy into other mongodb instances lib directories
```
openssl rand -base64 756 > /var/lib/mongodb/keyfile
cp /var/lib/mongodb/keyfile /var/lib/mongodb2/keyfile; cp /var/lib/mongodb/keyfile /var/lib/mongodb3/keyfile
```

## Assing owner and permissions for the new keyfiles
```
chown mongodb:mongodb /var/lib/mongodb/keyfile; chmod 400 /var/lib/mongodb/keyfile
chown mongodb:mongodb /var/lib/mongodb2/keyfile; chmod 400 /var/lib/mongodb2/keyfile
chown mongodb:mongodb /var/lib/mongodb3/keyfile; chmod 400 /var/lib/mongodb3/keyfile
```

## Start and enable all mongod services
```
systemctl restart mongod
systemctl restart mongod2
systemctl restart mongod3
systemctl enable mongod
systemctl enable mongod2
systemctl enable mongod3
```

## Enter a mongo instance, navigate to the admin database and execute the rs.initiate() command
```
mongosh admin -u root -p '<password>' --port 27017

use admin

rs.initiate({
  _id: "<replica_set_name>",
  members: [
    { _id: 0, host: "<hostname>:27017" },
    { _id: 1, host: "<hostname>:27018" },
    { _id: 2, host: "<hostname>:27019" }
  ]
})
```

## Check status of the replica set
```
mongosh admin -u root -p '<password>'

rs.status()
```

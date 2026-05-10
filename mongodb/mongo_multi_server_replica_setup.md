# Single server replica set setup

## Enter mongo and create a root user
```
mongosh

use admin
db.createUser({ user: 'root', pwd: passwordPrompt(), roles: [{ role: "root", db: "admin" }]})
```
## Edit /etc/mongod.conf to enable security and other required setup options as per example on all mongo replica set
```
# mongod.conf

storage:
  dbPath: /var/lib/mongodb

  journal:
    enabled: true

  # wiredTiger:
  #   engineConfig:
  #     cacheSizeGB: 3

  oplogMinRetentionHours: 48

systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

net:
  port: 27017
  bindIp: 0.0.0.0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

replication:
  replSetName: <replicaSetName> # CHANGE THIS

security:
  authorization: enabled
  keyFile: /var/lib/mongodb/keyfile

cloud:
  monitoring:
    free:
      state: on
```

## Generate a random base64 string into a keyfile file then copy it onto other mongo members
```
openssl rand -base64 756 > /var/lib/mongodb/keyfile
cat /var/lib/mongodb/keyfile
#copy and paste onto the other mongo members
```

## Assign the mongodb user as owner of the keyfiles and add assing new permissions to the keyfiles on each mongo replica set member
```
chown mongodb:mongodb /var/lib/mongodb/keyfile; chmod 400 /var/lib/mongodb/keyfile
```

## Restart mongod on all mongo replica set members
```
systemctl restart mongod
```

## Enter mongosh and navigate to the admin database, then execute the replica set initiation command on the first replica set member
```
# mongo, if version 4
# mongosh, if version 6

mongosh admin -u root -p '<password>'

use admin

rs.initiate({
  _id: "<replica_set_name>",
  members: [
    { _id: 0, host: "<hostname>:27017" },
    { _id: 1, host: "<hostname>:27017" },
    { _id: 2, host: "<hostname>:27017" }
  ]
})
```

## Check replica set status
```
mongosh

rs.status()
```

# MySQL installation

## Download packet
```
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
```

## If lsb_release returns “command not found”, then:
```
apt-get update && apt-get install -y lsb-release && apt-get clean all
```

## Setup release repo for the version you want (in this case it is 5.7)
```
percona-release setup ps57
```

## Apt update and install
```
sudo apt-get update
sudo apt-get install percona-server-server-5.7
apt install percona-xtrabackup-24
```

## Root pass stored in /root/.my.cnf in the following format
```
[client]
user=root
password=<password>
```

## Change the /etc/mysql/percona-server.conf.d/mysqld.cnf file (add max_connections = 4000)
```
Add LimitNOFILE=65535 into /etc/systemd/system/multi-user.target.wants/mysql.service
```
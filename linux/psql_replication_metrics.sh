#!/bin/bash
USER="postgres"
TIMELAG="$(echo 'SELECT CASE WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0 ELSE EXTRACT (EPOCH FROM now() - pg_last_xact_replay_timestamp()) END AS log_delay;' | su - $USER -c "psql -X -d postgres -A -F';'")"
echo $TIMELAG|cut -d " " -f2
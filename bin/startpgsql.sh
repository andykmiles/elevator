#!/bin/bash

sudo su postgres -c "cp conf/pgsql/postgresql.conf /etc/postgresql/11/main/postgresql.conf"
sudo su postgres -c "/usr/lib/postgresql/11/bin/pg_ctl -D /etc/postgresql/11/main -l /var/lib/postgresql/11/main/pg.log start"
sudo su postgres psql -f conf/pgsql/pguserdb.sql

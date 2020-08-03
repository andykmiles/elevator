#!/bin/bash
sudo cp conf/pgsql/postgresql.conf /etc/postgresql/11/main/postgresql.conf
/usr/lib/postgresql/11/bin/pg_ctl start

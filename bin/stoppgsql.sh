#!/bin/bash
sudo su postgres -c "/usr/lib/postgresql/11/bin/pg_ctl -D /etc/postgresql/11/main -l /var/lib/postgresql/11/main/pg.log start"

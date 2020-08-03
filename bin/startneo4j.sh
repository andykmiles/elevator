#!/bin/bash
sudo cp conf/neo4j/neo4j.conf /opt/neo4j-community-4.1.1/conf/neo4j.conf
sudo /opt/neo4j-community-4.1.1/bin/neo4j start
sudo /opt/neo4j-community-4.1.1/bin/neo4j-admin set-initial-password andy

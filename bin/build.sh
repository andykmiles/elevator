#!/bin/bash
docker build . -t deploy/test -f deploy.Dockerfile
echo $BINTRAY_PW | docker login --username andykmiles --password-stdin
docker tag deploy/test:latest andykmiles-docker-elevator.bintray.io/elevator_app:latest
docker push andykmiles-docker-elevator.bintray.io/elevator_app:latest

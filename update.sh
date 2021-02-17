#!/bin/sh

docker-compose pull
docker-compose stop
docker-compose up -d --remove-orphans
docker image prune -f
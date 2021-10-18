#!/bin/bash

path=$1

# Change volume type
sed "s,type: volume,type: bind,g" conf/docker-compose.yml > docker-compose.yml

# Change source
sed -i "s,source: tanatlocData,source: "${path}",g" docker-compose.yml

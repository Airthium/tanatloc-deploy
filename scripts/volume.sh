#!/bin/bash

type=$1
source=$2
target=$3

# Check if "volumes:" is already defined
if ! grep "    volumes:" docker-compose.volumes.yml
then
    echo "    volumes:" >> docker-compose.volumes.yml
fi

# Add volume
{
    echo "      - type: $type"
    echo "        source: $source"
    echo "        target: $target"
} >> docker-compose.volumes.yml

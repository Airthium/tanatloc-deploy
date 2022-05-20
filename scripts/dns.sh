#!/bin/bash

dns=$1

# Check if "dns:" is already defined
if ! grep "    dns:" docker-compose.volumes.yml
then
    echo "    dns:" >> docker-compose.volumes.yml
fi

# Add dns
echo "      - $dns" >> docker-compose.volumes.yml

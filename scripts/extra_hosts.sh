#!/bin/bash

extra_host=$1

# Check if "extra_hosts:" is already defined
if ! grep "    extra_hosts:" docker-compose.volumes.yml
then
    echo "    extra_hosts:" >> docker-compose.volumes.yml
fi

# Add extra host
echo "      - $extra_host" >> docker-compose.volumes.yml

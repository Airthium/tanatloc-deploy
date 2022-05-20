#!/bin/bash

extra_host=$1

# Check if "extra_hosts:" is already defined
if ! grep -q "    extra_hosts:" docker-compose.extra_hosts.yml
then
    echo "    extra_hosts:" >> docker-compose.extra_hosts.yml
fi

# Add extra host
echo "      - $extra_host" >> docker-compose.extra_hosts.yml

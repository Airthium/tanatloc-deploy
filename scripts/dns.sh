#!/bin/bash

dns=$1

# Check if "dns:" is already defined
if ! grep -q "    dns:" docker-compose.dns.yml
then
    echo "    dns:" >> docker-compose.dns.yml
fi

# Add dns
echo "      - $dns" >> docker-compose.dns.yml

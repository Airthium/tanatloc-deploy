#!/bin/bash

key=$1
value=$2


## Check .env file
if [ ! -f .env ]
then
    cp ./conf/default.conf ./.env
fi

## Modify key/value
sed -i "/^${key} /s|= .*$|= ${value}|" .env

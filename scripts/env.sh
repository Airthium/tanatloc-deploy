#!/bin/bash

key=$1
value=$2

## Check .env file
if [ ! -f .env ]
then
    cp ./conf/default.conf ./.env
fi

## Check if key exists
if grep -q "$key" .env
then
    ## Modify key/value
    sed -i "/^${key} /s|= .*$|= ${value}|" .env
else
    ## Add key/value
    echo "$key = $value" >> .env
fi


#!/bin/bash

status=$1

if [ "$status" = "OFF" ]
then
    # Comment ipv6 lines
    if [ -f docker/run.nginx.conf ]
    then
        sed -i "s/ listen \[::\]:/ #listen \[::\]:/" docker/run.nginx.conf
    else
        sed "s/ listen \[::\]:/ #listen \[::\]:/" docker/nginx.conf > docker/run.nginx.conf
    fi
else
    # Uncomment ipv6 lines
    if [ -f docker/run.nginx.conf ]
    then
        sed -i "s/#listen \[::\]:/listen \[::\]:/" docker/run.nginx.conf
    else
        sed "s/#listen \[::\]:/listen \[::\]:/" docker/nginx.conf > docker/run.nginx.conf
    fi
fi

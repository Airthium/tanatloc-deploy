#!/bin/sh

## Tanatloc

action=$1
option=$2
value=$3

if [ $# -eq 0 ]
then
    echo "Usage: tanatloc.sh action [option] [value]"
    echo "Try tanatloc.sh help"
else

    if [ "$action" = "set" ]
    then
        if [ "$option" = "domain" ]
        then
            sh scripts/domain.sh $value
        fi
    elif [ "$action" = "start" ]
    then
        if [ ! -f docker/run.nginx.conf ]
        then
            cp docker/nginx.conf docker/run.nginx.conf
        fi
        docker-compose start
    elif [ "$action" = "stop" ]
    then
        docker-compose stop
    elif [ "$action" = "update" ]
    then
        docker-compose pull
        docker-compose stop
        docker-compose up -d --remove-orphans
    elif [ "$action" = "clean" ]
    then
        docker image prune -f
    elif [ "$action" = "help" ]
    then
        echo "tanatloc.sh action [option] [value]"

        echo "List of actions:"
        echo " - set (need option and value)"
        echo " - start. Start the Tanatloc server"
        echo " - stop. Stop the Tanatloc server"
        echo " - update. Update the Tanatloc server"
        echo " - clean. Clean old docker images"

        echo "List of options:"
        echo ' - domain, need value. Set a custom domain. The value must start with http:// or https://.'
    else
        echo "Unknown action ${action}"
    fi

fi
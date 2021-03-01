#!/bin/sh

# Backup location
dbBackup=/media/backup/db
dataBackup=/media/backup/data

# Arguments
action=$1
option=$2
value=$3

## Tanatloc

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
        else
            echo "Unknown value ${value}. Please see tanaloc.sh --help."
        fi
    elif [ "$action" = "db" ]
    then
        if [ "$option" = "backup" ]
        then
            docker-compose run -e PGPASSWORD="password" database pg_dump -h database -U postgres tanatloc2 > ${dbBackup}/dump-$(date +%Y-%m-%d).sql
        else
            echo "Unknown value ${value}. Please see tanaloc.sh --help."
        fi
    elif [ "$action" = "data" ]
    then
        if [ "$option" = "backup" ]
        then
            docker run -it -v tanatloc-ssr_tanatlocData:/data -v $dataBackup/backup_$(date +%Y-%m-%d):/backup ubuntu tar cvfP /backup/backup.tar /data
        else
            echo "Unknown value ${value}. Please see tanaloc.sh --help."
        fi
    elif [ "$action" = "start" ]
    then
        if [ ! -f docker/run.nginx.conf ]
        then
            cp docker/nginx.conf docker/run.nginx.conf
        fi
        docker-compose start
    elif [ "$action" = "restart" ]
    then
        docker-compose restart
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
        echo " - db (need option)"
        echo " - start. Start the Tanatloc server"
        echo " - stop. Stop the Tanatloc server"
        echo " - update. Update the Tanatloc server"
        echo " - clean. Clean old docker images"

        echo "List of options:"
        echo ' - domain, need value. Set a custom domain. The value must start with http:// or https://.'
        echo ' - backup. Backup data or database'
    else
        echo "Unknown action ${action}. Please see tanaloc.sh --help."
    fi

fi
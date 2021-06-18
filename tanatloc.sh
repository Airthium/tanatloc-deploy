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
        elif [ "$option" = "run" ]
            docker run -it -v tanatloc-ssr-deploy_tanatlocData:/data ubuntu /bin/bash
        else
            echo "Unknown value ${value}. Please see tanaloc.sh --help."
        fi
    elif [ "$action" = "data" ]
    then
        if [ "$option" = "backup" ]
        then
            docker run -v tanatloc-ssr-deploy_tanatlocData:/data -v $dataBackup:/backup ubuntu tar cvfP /backup/backup-$(date +%Y-%m-%d).tar /data
        elif [ "$option" = "run" ]
            docker-compose run database psql -U postgres -h database
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
        echo " - set (need option and value);"
        echo " - db (need option);"
        echo " - data (need option);"
        echo " - start. Start the Tanatloc server;"
        echo " - stop. Stop the Tanatloc server;"
        echo " - update. Update the Tanatloc server;"
        echo " - clean. Clean old docker images;"
        echo " - run (need option)."

        echo "List of options:"
        echo ' - [set] domain, need value. Set a custom domain. The value must start with http:// or https://;'
        echo ' - [db, data] backup. Backup database or data;'
        echo ' - [db, data] run. Run database or data docker.'
    else
        echo "Unknown action ${action}. Please see tanaloc.sh --help."
    fi

fi
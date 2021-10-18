#!/bin/bash

# Backup location
dbBackup=/media/backup/db
dataBackup=/media/backup/data

# Arguments
action=$1
option=$2
value=$3

# Help
Red='\033[0;31m'
Off='\033[0m'
function help {
    Green='\033[0;32m'
    Yellow='\033[0;33m'
    Blue='\033[0;34m'
    Purple='\033[0;35m'
    Cyan='\033[0;36m'

    echo -e ""
    echo -e "Usage: tanatloc.sh ${Cyan}action ${Purple}[option] [value]${Off}"
    echo -e ""
    echo -e "List of ${Cyan}actions${Off}:"
    echo -e " - ${Cyan}set${Off}"
    echo -e "   need option and value"
    echo -e " - ${Cyan}db${Off}"
    echo -e "   need option"
    echo -e " - ${Cyan}data${Off}"
    echo -e "   need option"
    echo -e " - ${Cyan}start${Off}"
    echo -e "   Start the Tanatloc server"
    echo -e " - ${Cyan}stop${Off}"
    echo -e "   Stop the Tanatloc server"
    echo -e " - ${Cyan}update${Off}"
    echo -e "   Update the Tanatloc server"
    echo -e " - ${Cyan}clean${Off}"
    echo -e "   Clean old docker images"
    echo -e " - ${Cyan}run${Off}"
    echo -e "   need option"
    echo -e ""
    echo -e "List of ${Purple}options${Off}:"
    echo -e " - [${Cyan}set${Off}] ${Purple}domain${Off}"
    echo -e "   need a value"
    echo -e "   Set a custom domain. The value must start with http:// or https://:"
    echo -e " - [${Cyan}set${Off}] ${Purple}storage${Off}"
    echo -e "   need a value"
    echo -e "   Set a custom storage. The path must be absolute"
    echo -e " - [${Cyan}db${Off}, ${Cyan}data${Off}] ${Purple}backup${Off}"
    echo -e "   Backup database or data"
    echo -e " - [${Cyan}db${Off}, ${Cyan}data${Off}] ${Purple}run${Off}"
    echo -e "   Run database or data docker"
    echo -e ""
}

# Error
function error {
    echo -e "${Red}$1${Off}"
    help
    exit -1
}

## Tanatloc
if [ $# -eq 0 ]
then
    help
else
    ### Set
    if [ "$action" = "set" ]
    then
        if [ ! -n "$option" ]
        then
            error "Undefined or empty option"
        elif [ "$option" = "domain" ]
        then
            if [ -n "$value" ]
            then
                sh scripts/domain.sh $value
                echo "DOMAIN=\"$value\"" >> .env
            else
                error "Undefined or empty value"
            fi
        elif [ "$option" = "storage" ]
        then
            if [ -n "$value" ]
            then
                sh scripts/storage.sh $value
            else
                error "Undefined or empty value"
            fi
        else
            error "Unknown option ${option}"
        fi
    ### dB
    elif [ "$action" = "db" ]
    then
        if [ ! -n "$option" ]
        then
            error "Undefined or empty option"
        elif [ "$option" = "backup" ]
        then
            docker-compose run -e PGPASSWORD="password" database pg_dump -h database -U postgres tanatloc2 > ${dbBackup}/dump-$(date +%Y-%m-%d).sql
        elif [ "$option" = "run" ]
        then
            docker-compose run database psql -U postgres -h database
        else
            error "Unknown option ${option}"
        fi
    ### Data
    elif [ "$action" = "data" ]
    then
        if [ ! -n "$option" ]
        then
            error "Undefined or empty option"
        elif [ "$option" = "backup" ]
        then
            docker run -v tanatloc-ssr-deploy_tanatlocData:/data -v $dataBackup:/backup ubuntu tar cvfP /backup/backup-$(date +%Y-%m-%d).tar /data
        elif [ "$option" = "run" ]
        then
            docker run -it -v tanatloc-ssr-deploy_tanatlocData:/data ubuntu /bin/bash
        else
            error "Unknown option ${option}"
        fi
    ### Start
    elif [ "$action" = "start" ]
    then
        if [ ! -f docker-compose.yml ]
        then
            cp conf/docker-compose.yml docker-compose.yml
        fi
        if [ ! -f docker/run.nginx.conf ]
        then
            cp docker/nginx.conf docker/run.nginx.conf
        fi
        docker-compose up -d --remove-orphans
    ### Restart
    elif [ "$action" = "restart" ]
    then
        docker-compose restart
    ### Stop
    elif [ "$action" = "stop" ]
    then
        docker-compose stop
    ### Update
    elif [ "$action" = "update" ]
    then
        docker-compose pull
        docker-compose stop
        docker-compose up -d --remove-orphans
    ### Clean
    elif [ "$action" = "clean" ]
    then
        docker rmi $(docker image ls --filter reference="tanatloc/tanatloc" --quiet | tail -n +2)
        docker rmi $(docker image ls --filter reference="postgres" --quiet | tail -n +2)
        docker rmi $(docker image ls --filter reference="nginx" --quiet | tail -n +2)
    ### Help
    elif [ "$action" = "help" ]
    then
        help
    ### Error
    else
        error "Unknown action ${action}"
    fi
fi
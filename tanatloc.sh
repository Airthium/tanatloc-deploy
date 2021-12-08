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
    echo -e " - ${Cyan}log${Off}"
    echo -e "   display log"
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
    echo -e " - ${Cyan}renew${Off}"
    echo -e " - need option"
    echo -e ""
    echo -e "List of ${Purple}options${Off}:"
    echo -e " - [${Cyan}set${Off}] ${Purple}tanatloc_tag${Off}"
    echo -e "   need a value"
    echo -e "   Ask for available values"
    echo -e " - [${Cyan}set${Off}] ${Purple}database_password${Off}"
    echo -e "   need a value"
    echo -e "   Database password"
    echo -e " - [${Cyan}set${Off}] ${Purple}database_port${Off}"
    echo -e "   need a value"
    echo -e "   Database port. It must be a valid port number"
    echo -e " - [${Cyan}set${Off}] ${Purple}domain${Off}"
    echo -e "   need a value"
    echo -e "   Set a custom domain. The value must start with http:// or https://:"
    echo -e " - [${Cyan}set${Off}] ${Purple}http_port${Off}"
    echo -e "   need a value"
    echo -e "   HTTP port. It must be a valid port number"
    echo -e " - [${Cyan}set${Off}] ${Purple}https_port${Off}"
    echo -e "   need a value"
    echo -e "   HTTPS port. It must be a valid port number"
    echo -e " - [${Cyan}set${Off}] ${Purple}storage${Off}"
    echo -e "   need a value"
    echo -e "   Set a custom storage using a path. The path must be absolute"
    echo -e " - [${Cyan}db${Off}, ${Cyan}data${Off}] ${Purple}backup${Off}"
    echo -e "   Backup database or data"
    echo -e " - [${Cyan}db${Off}, ${Cyan}data${Off}] ${Purple}run${Off}"
    echo -e "   Run database or data docker"
    echo -e " - [${Cyan}renew${Off}] ${Purple}certificate${Off}"
    echo -e "   Renew the SSL certificate"
    echo -e ""
}

# Check env
function checkEnv {
    if [ ! -f .env ]
    then
        error ".env file not found, Please start Tanatloc first"
    fi
}

# Check option
function checkOption {
    if [ ! -n "$1" ]
    then
        error "Undefined or empty option"
    fi
}

# Check value
function checkValue {
    if [ ! -n "$1" ]
    then
        error "Undefined or empty value"
    fi
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

    ### Log
    if [ "$action" = "log" ]
    then
        checkEnv
        
        docker-compose logs

    ### Set
    elif [ "$action" = "set" ]
    then
        checkOption $option

        #### Tanatloc tag
        if [ "$option" = "tanatloc_tag" ]
        then
            checkValue $value

            sh scripts/env.sh TANATLOC_TAG $value
        
        #### Database password
        elif [ "$option" = "database_password" ]
        then
            checkValue $value

            sh scripts/env.sh POSTGRES_PASSWORD $value

        #### Database port
        elif [ "$option" = "database_port" ]
        then
            checkValue $value

            sh scripts/env.sh POSTGRES_DB_PORT $value

        #### Domain
        elif [ "$option" = "domain" ]
        then
            checkValue $value
            
            sh scripts/domain.sh $value
            sh scripts/env.sh DOMAIN $value

        #### HTTP port
        elif [ "$option" = "http_port" ]
        then
            checkValue $value

            sh scripts/env.sh NGINX_HTTP $value

        #### HTTPS port
        elif [ "$option" = "https_port" ]
        then
            checkValue $value

            sh scripts/env.sh NGINX_HTTPS $value

        #### Storage
        elif [ "$option" = "storage" ]
        then
            checkValue $value
            
            sh scripts/env.sh STORAGE_TYPE bind
            sh scripts/env.sh STORAGE_PATH $value

        #### Unknown
        else
            error "Unknown option ${option}"
        fi

    ### Database
    elif [ "$action" = "db" ]
    then
        checkEnv
        checkOption $option

        #### Backup
        if [ "$option" = "backup" ]
        then
            docker-compose run -e PGPASSWORD="password" database pg_dump -h database -U postgres tanatloc2 > ${dbBackup}/dump-$(date +%Y-%m-%d).sql

        #### Run
        elif [ "$option" = "run" ]
        then
            docker-compose run database psql -U postgres -h database
        

        #### Unknown
        else
            error "Unknown option ${option}"
        fi

    ### Data
    elif [ "$action" = "data" ]
    then
        checkEnv
        checkOption $option
        
        #### Backup
        if [ "$option" = "backup" ]
        then
            docker run -v tanatloc-ssr-deploy_tanatlocData:/data -v $dataBackup:/backup ubuntu tar cvfP /backup/backup-$(date +%Y-%m-%d).tar /data
        
        #### Run
        elif [ "$option" = "run" ]
        then
            docker run -it -v tanatloc-ssr-deploy_tanatlocData:/data ubuntu /bin/bash
        
        #### Unknown
        else
            error "Unknown option ${option}"
        fi

    ### Start
    elif [ "$action" = "start" ]
    then
        #### Check env
        if [ ! -f .env ]
        then
            cp conf/default.conf .env
        fi

        #### Check nginx
        if [ ! -f docker/run.nginx.conf ]
        then
            cp docker/nginx.conf docker/run.nginx.conf
        fi

        #### Start
        docker-compose up -d --remove-orphans

    ### Restart
    elif [ "$action" = "restart" ]
    then
        checkEnv

        docker-compose restart

    ### Stop
    elif [ "$action" = "stop" ]
    then
        checkEnv

        docker-compose stop

    ### Update
    elif [ "$action" = "update" ]
    then
        checkEnv

        docker-compose pull
        docker-compose stop
        docker-compose up -d --remove-orphans

    ### Clean
    elif [ "$action" = "clean" ]
    then
        docker rmi $(docker image ls --filter reference="tanatloc/tanatloc" --quiet | tail -n +2)
        docker rmi $(docker image ls --filter reference="postgres" --quiet | tail -n +2)
        docker rmi $(docker image ls --filter reference="nginx" --quiet | tail -n +2)

    ### Renew
    elif [ "$action" = "renew" ]
    then
        sh scripts/cert-renew.sh
        
    ### Help
    elif [ "$action" = "help" ]
    then
        help
        
    ### Error
    else
        error "Unknown action ${action}"
    fi
fi
#!/bin/bash

# Arguments
action=$1
option=$2
value=$3

arg1=$3
arg2=$4
arg3=$5

# Version
echo -e "Tanatloc deployment script - v1.0"

# User and group id
sh scripts/env.sh UID "$(id -u)"
sh scripts/env.sh GID "$(id -g)"

# Help
Red='\033[0;31m'
Off='\033[0m'
help() {
    # Green='\033[0;32m'
    # Yellow='\033[0;33m'
    # Blue='\033[0;34m'
    Purple='\033[0;35m'
    Cyan='\033[0;36m'

    echo -e "Usage: tanatloc.sh ${Cyan}action ${Purple}[option] [value]${Off}"
    echo -e "Usage: tanatloc.sh ${Cyan}action ${Purple}[option] [arg1] [arg2] [arg3]${Off}"
    echo -e ""

    echo -e "List of ${Cyan}actions${Off}:"
    echo -e " - ${Cyan}start${Off}"
    echo -e "   Start the Tanatloc server"
    echo -e " - ${Cyan}stop${Off}"
    echo -e "   Stop the Tanatloc server"
    echo -e " - ${Cyan}update-self${Off}"
    echo -e "   Update the Tanatloc deployment script"
    echo -e " - ${Cyan}update${Off}"
    echo -e "   Update the Tanatloc server"
    echo -e " - ${Cyan}clean${Off}"
    echo -e "   Clean old docker images"
    echo -e " - ${Cyan}renew${Off}"
    echo -e " - need option"
    echo -e " - ${Cyan}log${Off}"
    echo -e "   display log"
    echo -e " - ${Cyan}set${Off}"
    echo -e "   need option and value"
    echo -e " - ${Cyan}add${Off}"
    echo -e "   need option and value"
    echo -e " - ${Cyan}database${Off}"
    echo -e "   need option"
    echo -e " - ${Cyan}data${Off}"
    echo -e "   need option"
    echo -e ""

    echo -e "List of ${Purple}options${Off}:"
    echo -e " - [${Cyan}set${Off}] ${Purple}tanatloc_tag${Off}"
    echo -e "   need a value"
    echo -e "   Ask for available values"
    echo -e " - [${Cyan}set${Off}] ${Purple}database_password${Off}"
    echo -e "   need a value"
    echo -e "   Database password"
    echo -e " - [${Cyan}set${Off}] ${Purple}database_backup${Off}"
    echo -e "   need a value"
    echo -e "   Database backup path. This path must be absolute"
    echo -e " - [${Cyan}set${Off}] ${Purple}domain${Off}"
    echo -e "   need a value"
    echo -e "   Set a custom domain. The value must start with http:// or https://:"
    echo -e " - [${Cyan}set${Off}] ${Purple}ipv6${Off}"
    echo -e "   need a value"
    echo -e "   IPv6 status. ON or OFF"
    echo -e " - [${Cyan}set${Off}] ${Purple}http_port${Off}"
    echo -e "   need a value"
    echo -e "   HTTP port. It must be a valid port number"
    echo -e " - [${Cyan}set${Off}] ${Purple}https_port${Off}"
    echo -e "   need a value"
    echo -e "   HTTPS port. It must be a valid port number"
    echo -e " - [${Cyan}set${Off}] ${Purple}http_proxy${Off}"
    echo -e "   need a value"
    echo -e "   HTTP proxy. It must be a valid URL"
    echo -e " - [${Cyan}set${Off}] ${Purple}https_proxy${Off}"
    echo -e "   need a value"
    echo -e "   HTTPS proxy. It must be a valid URL"
    echo -e " - [${Cyan}set${Off}] ${Purple}storage${Off}"
    echo -e "   need a value"
    echo -e "   Set a custom storage using a path. The path must be absolute"
    echo -e " - [${Cyan}set${Off}] ${Purple}storage_backup${Off}"
    echo -e "   need a value"
    echo -e "   Storage backup path. This path must be absolute"
    echo -e " - [${Cyan}set${Off}] ${Purple}additional_path${Off}"
    echo -e "   need a value"
    echo -e "   Additional path."
    echo -e " - [${Cyan}set${Off}] ${Purple}sharetask_jvm${Off}"
    echo -e "   need a value"
    echo -e "   Set the SHARETASK_JVM environment variable."
    echo -e " - [${Cyan}add${Off}] ${Purple}volume${Off}"
    echo -e "   need type, source, target"
    echo -e "   Add a volume in tanatloc service."
    echo -e " - [${Cyan}add${Off}] ${Purple}dns${Off}"
    echo -e "   need dns"
    echo -e "   Add a dns in tanatloc service."
    echo -e " - [${Cyan}add${Off}] ${Purple}extra_host${Off}"
    echo -e "   need extra_host"
    echo -e "   Add an extra host in tanatloc service."
    echo -e " - [${Cyan}database${Off}, ${Cyan}data${Off}] ${Purple}backup${Off}"
    echo -e "   Backup database or data"
    echo -e " - [${Cyan}database${Off}, ${Cyan}data${Off}] ${Purple}run${Off}"
    echo -e "   Run database or data docker"
    echo -e " - [${Cyan}renew${Off}] ${Purple}certificate${Off}"
    echo -e "   Renew the SSL certificate"
    echo -e ""
}

# Check env
checkEnv() {
    if [ ! -f .env ]
    then
        error ".env file not found, Please start Tanatloc first"
    fi
}

# Check option
checkOption() {
    if [ -z "$1" ]
    then
        error "Undefined or empty option"
    fi
}

# Check value
checkValue() {
    if [ -z "$1" ]
    then
        error "Undefined or empty value"
    fi
}

# Error
error() {
    echo -e "${Red}$1${Off}"
    help
    exit 1
}

## env file
if [ -f .env ]
then
    while read -r line
    do
        # Empty line
        if [ -z "$line" ]
        then
            continue
        fi

        # Line with at least a #
        if [ -z "${line###*}" ]
        then
            continue
        fi

        # Remove spaces
        line=$(echo "$line" | sed -e "s/ //g")

        # Skip UID
        if [ -z "${line##*UID=*}" ]
        then
            continue
        fi

        export "${line?}"

    done < ".env"
fi

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
        checkOption "$option"

        #### Tanatloc tag
        if [ "$option" = "tanatloc_tag" ]
        then
            checkValue "$value"

            sh scripts/env.sh TANATLOC_TAG "$value"
        
        #### Database password
        elif [ "$option" = "database_password" ]
        then
            checkValue "$value"

            sh scripts/env.sh DATABASE_PASSWORD "$value"
        
        #### Database backup
        elif [ "$option" = "database_backup" ]
        then
            checkValue "$value"

            sh scripts/env.sh DATABASE_BACKUP_PATH "$value"

        #### Domain
        elif [ "$option" = "domain" ]
        then
            checkValue "$value"
            
            sh scripts/domain.sh "$value"
            sh scripts/env.sh DOMAIN "$value"

        #### IPv6
        elif [ "$option" = "ipv6" ]
        then
            checkValue "$value"

            sh scripts/ipv6.sh "$value"
            sh scripts/env.sh IPV6 "$value"

        #### HTTP port
        elif [ "$option" = "http_port" ]
        then
            checkValue "$value"

            sh scripts/env.sh NGINX_HTTP "$value"

        #### HTTPS port
        elif [ "$option" = "https_port" ]
        then
            checkValue "$value"

            sh scripts/env.sh NGINX_HTTPS "$value"

        #### HTTP proxy
        elif [ "$option" = "http_proxy" ]
        then
            checkValue "$value"

            sh scripts/env.sh HTTP_PROXY "$value"

        #### HTTPS proxy
        elif [ "$option" = "https_proxy" ]
        then
            checkValue "$value"

            sh scripts/env.sh HTTPS_PROXY "$value"

        #### Storage
        elif [ "$option" = "storage" ]
        then
            checkValue "$value"
            
            sh scripts/env.sh STORAGE_TYPE "bind"
            sh scripts/env.sh STORAGE_PATH "$value"
        
        #### Storage backup
        elif [ "$option" = "storage_backup" ]
        then
            checkValue "$value"

            sh scripts/env.sh STORAGE_BACKUP_PATH "$value"

        #### Additional path
        elif [ "$option" = "additional_path" ]
        then
            checkValue "$value"

            sh scripts/env.sh ADDITIONAL_PATH "$value"

        #### Sharetask jvm
        elif [ "$option" = "sharetask_jvm" ]
        then
            checkValue "$value"

            sh scripts/env.sh SHARETASK_JVM "$value"

        #### Unknown
        else
            error "Unknown option ${option}"
        fi

    ### Add
    elif [ "$action" = "add" ]
    then
        checkEnv
        checkOption "$option"

        #### Volume
        if [ "$option" = "volume" ]
        then
            checkValue "$arg1"
            checkValue "$arg2"
            checkValue "$arg3"

            sh scripts/volume.sh "$arg1" "$arg2" "$arg3"
        
        ### DNS
        elif [ "$option" = "dns" ]
        then
            checkValue "$arg1"

            sh scripts/dns.sh "$arg1"

        ### Extra host
        elif [ "$option" = "extra_host" ]
        then
            checkValue "$arg1"

            sh scripts/extra_hosts.sh "$arg1"

        #### Unknown
        else
            error "Unknown option ${option}"
        fi

    ### Database
    elif [ "$action" = "database" ]
    then
        checkEnv
        checkOption "$option"

        #### Backup
        if [ "$option" = "backup" ]
        then
            docker-compose run -e PGPASSWORD="password" database pg_dump -h database -U postgres tanatloc2 > "$DATABASE_BACKUP_PATH/dump-$(date +%Y-%m-%d).sql"

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
        checkOption "$option"
        
        #### Backup
        if [ "$option" = "backup" ]
        then
            docker run -v tanatloc-deploy_tanatlocData:/data -v "$STORAGE_BACKUP_PATH:/backup" ubuntu tar cvfP "/backup/backup-$(date +%Y-%m-%d).tar" /data
        
        #### Run
        elif [ "$option" = "run" ]
        then
            docker run -it -v tanatloc-deploy_tanatlocData:/data ubuntu /bin/bash
        
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
        docker-compose -f docker-compose.yml -f docker-compose.volumes.yml -f docker-compose.dns.yml -f docker-compose.extra_hosts.yml up -d --remove-orphans

    ### Restart
    elif [ "$action" = "restart" ]
    then
        checkEnv

        docker-compose restart

    ### Stop
    elif [ "$action" = "stop" ]
    then
        checkEnv

        docker-compose down

    ### Update self
    elif [ "$action" = "update-self" ]
    then
        git pull

    ### Update
    elif [ "$action" = "update" ]
    then
        checkEnv

        docker-compose pull
        docker-compose down
        docker-compose -f docker-compose.yml -f docker-compose.volumes.yml -f docker-compose.dns.yml -f docker-compose.extra_hosts.yml up -d --remove-orphans

    ### Clean
    elif [ "$action" = "clean" ]
    then
        docker rmi "$(docker image ls --filter reference="tanatloc/tanatloc" --quiet | tail -n +2)"
        docker rmi "$(docker image ls --filter reference="postgres" --quiet | tail -n +2)"
        docker rmi "$(docker image ls --filter reference="nginx" --quiet | tail -n +2)"

    ### Renew
    elif [ "$action" = "renew" ]
    then
        checkOption "$option"

        if [ "$option" = "certificate" ]
        then
            sh scripts/cert-renew.sh
        fi
        
    ### Help
    elif [ "$action" = "help" ]
    then
        help
        
    ### Error
    else
        error "Unknown action ${action}"
    fi
fi
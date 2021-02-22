#!/bin/bash

domain=$1
cleanDomain=$(echo $domain | cut -d "/" -f 3)

# Set domain name
sed "s/tanatloc.com/${cleanDomain}/" docker/nginx.conf > docker/run.nginx.conf

# Check SSL
if [ $(echo "$domain" | cut -d ":" -f 1) = "https" ]
then
    sed -i "s/listen/# listen/" docker/run.nginx.conf
    sed -i "s/# # listen/listen/" docker/run.nginx.conf
    sed -i "s/# ssl_certificate/ssl_certificate/" docker/run.nginx.conf

    sed -i "s/# server {/server {/" docker/run.nginx.conf
    sed -i "s/#     # listen/    listen/" docker/run.nginx.conf
    sed -i "s/#     server_name/    server_name/" docker/run.nginx.conf
    sed -i "s/#     return/    return/" docker/run.nginx.conf
    sed -i "s/# }/}/" docker/run.nginx.conf

    echo "SSL enabled"

    certbot=`certbot --version`
    if [ -n "$certbot" ]
    then
        echo "Build certificates"
        sudo certbot certonly --standalone --non-interactive --agree-tos -m admin@$cleanDomain -d $cleanDomain
    else
        echo "certbot missing"
        echo "Please build the following certificates:"
        echo " - /etc/letsencrypt/live/${cleanDomain}/fullchain.pem"
        echo " - /etc/letsencrypt/live/${cleanDomain}/privkey.pem"
    fi
fi

#!/bin/bash

domain=`grep -oP "server_name\s+\K\w+" docker/run.nginx.conf | head -1`
echo "Renew certificate for $domain"

certbot=`certbot --version`
if [ -n "$certbot" ]
then
    echo "Stop Tanatloc"
    bash tanatloc.sh stop

    echo "Build certificates"
    sudo certbot renew --cert-name $domain

    echo "Restart Tanatloc"
    bash tanatloc.sh start
else
    echo "certbot missing"
    echo "Please renew the following certificates:"
    echo " - /etc/letsencrypt/live/${cleanDomain}/fullchain.pem"
    echo " - /etc/letsencrypt/live/${cleanDomain}/privkey.pem"
fi
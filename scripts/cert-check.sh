#!/bin/bash

domain=`grep -oP "server_name\s+\K\w+" docker/run.nginx.conf | head -1`
cert_date=`openssl x509 -dates -noout -in /etc/letsencrypt/live/${domain}/fullchain.pem | grep -oP "notAfter=\s+\K\w+"`

date=`date +%s -d "${cert_date}"`

today=`date +%s`

diff=$(( ($date - $today)/86400 ))

# If 14 days remaining
if [ $diff -le 14 ]
then
    sh scripts/cert-renew.sh
else
    echo "Not renew needed"
fi

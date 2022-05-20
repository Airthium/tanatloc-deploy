#!/bin/bash

echo " - Modify postgres version (old kernel)"
sed -i 's/postgres:14/postgres:13-buster/g' ./docker-compose.yml

echo " - Clean volumes"
echo "services:" > ./docker-compose.volumes.yml
echo "  tanatloc:" >> ./docker-compose.volumes.yml

echo " - Clean dns"
echo "services:" > ./docker-compose.dns.yml
echo "  tanatloc:" >> ./docker-compose.dns.yml

echo " - Clean extra_hosts"
echo "services:" > ./docker-compose.extra_hosts.yml
echo "  tanatloc:" >> ./docker-compose.extra_hosts.yml

echo " - Set denso tag"
bash tanatloc.sh set tanatloc_tag denso

echo " - Set additional path"
bash tanatloc.sh set additional_path /usr/local/sharetask/bin

echo " - Set HTTP_PROXY"
bash tanatloc.sh set http_proxy http://in-proxy-o.denso.co.jp:8080

echo " - Set HTTPS_PROXY"
bash tanatloc.sh set https_proxy http://in-proxy-o.denso.co.jp:8080

echo " - Set HTTP port"
bash tanatloc.sh set http_port 6543

echo " - Disable IPv6"
bash tanatloc.sh set ipv6 OFF

echo " - Set SHARETASK_JVM"
bash tanatloc.sh set sharetask_jvm /usr/local/sharetask/java/amazon-corretto-8.322.06.2-linux-x64/bin/java

echo " - Set storage"
bash tanatloc.sh set storage /appli/TANATLOC/tanatloc1/work/storage

echo " - Set backup"
bash tanatloc.sh set database_backup /appli/TANATLOC/tanatloc1/work/db_backup
bash tanatloc.sh set storage_backup /appli/TANATLOC/tanatloc1/work/storage_backup

echo " - Add ShareTask volume"
bash tanatloc.sh add volume bind /usr/local/sharetask /usr/local/sharetask

echo " - Add dns"
bash tanatloc.sh add dns 133.192.207.232
bash tanatloc.sh add dns 133.192.207.231
bash tanatloc.sh add dns 133.192.42.231
bash tanatloc.sh add dns 10.6.14.1
bash tanatloc.sh add dns 10.6.14.2
bash tanatloc.sh add dns 10.6.14.3
bash tanatloc.sh add dns 10.6.14.4
bash tanatloc.sh add dns 133.192.43.115
bash tanatloc.sh add dns 133.192.43.116
bash tanatloc.sh add dns 133.192.43.117

echo " - Add extra hosts"
bash tanatloc.sh add extra_host iris-share:10.2.9.240
bash tanatloc.sh add extra_host iris-login:10.2.9.241

echo ' == SECURITY STOP == '
bash tanatloc.sh stop

echo ' == First start == '
bash tanatloc.sh start

echo ' == Update == '
bash tanatloc.sh update
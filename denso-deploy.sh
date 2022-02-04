#/bin/bash

echo " - Modify postgres version (old kernel)"
sed -i 's/postgres:14/postgres:13-buster/g' ./docker-compose.yml

echo " - Set denso tag"
bash tanatloc.sh set tanatloc_tag denso

echo " - Set additional path"
bash tanatloc.sh set additional_path /usr/local/sharetask/bin

echo " - Set HTTP_PROXY"
bash tanatloc.sh set http_proxy http://in-proxy-o.denso.co.jp:8080

echo " - Set HTTPS_PROXY"
bash tanatloc.sh set https_proxy http://in-proxy-o.denso.co.jp:8080

echo "- Set HTTP port"
bash tanatloc.sh set http_port 6543

echo " - Disable IPv6"
bash tanatloc.sh set ipv6 OFF

echo " - Set SHARETASK_JVM"
bash tanatloc.sh set sharetask_jvm /usr/local/sharetask/java/amazon-corretto-8.322.06.2-linux-x64/bin/java

echo " - Set storage"
bash tanatloc.sh set storage /appli/TANATLOC/tanatloc1/work/storage

echo " - Add ShareTask volume"
bash tanatloc.sh add volume bind /usr/local/sharetask /usr/local/sharetask

echo ' == SECURITY STOP == '
bash tanatloc.sh stop

echo ' == First start == '
bash tanatloc.sh start

echo ' == Update == '
bash tanatloc.sh update
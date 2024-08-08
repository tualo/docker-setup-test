#!/bin/sh

service mariadb start
mysql -e "drop database if exists db";
mysql -e "drop database if exists sessions";

mysql -e "create user if not exists 'systemuser'@'%' identified by ''";
mysql -e "grant all on *.* to 'systemuser'@'%' with grant option";

echo "[client]" > ~/.my.cnf 
echo "host=127.0.0.1" >> ~/.my.cnf 
echo "port=3306" >> ~/.my.cnf 
echo "user=systemuser" >> ~/.my.cnf 
echo "password=" >> ~/.my.cnf 

# cp -r /var/www/html/server_setup/* /var/www/html/server


if [ -f "/var/www/html/server/composer.json" ]; then
    echo "links exists"
else 
    #ln -s /var/www/html/server_setup/cache /var/www/html/server/cache
    #ln -s /var/www/html/server_setup/temp /var/www/html/server/temp
    #ln -s /var/www/html/server_setup/index.php /var/www/html/server/index.php
    ln -s /var/www/html/server_setup/composer.json /var/www/html/server/composer.json
    #ln -s /var/www/html/server_setup/configuration /var/www/html/server/configuration
    #ln -s /var/www/html/server_setup/tm /var/www/html/server/tm
    #ln -s /var/www/html/server_setup/vendor /var/www/html/server/vendor
fi


# export _JAVA_OPTIONS="-Xms2048m -Xmx8192m -XX:-UseG1GC"
# export _JAVA_OPTIONS="-XX:+AlwaysPreTouch -XX:+TieredCompilation -XX:NewRatio=1 -XX:+UseConcMarkSweepGC -XX:MaxMetaspaceSize=1024m -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:MaxTenuringThreshold=15"

composer require --dev tualo/onlinevote
composer update

./tm configuration --section ext-compiler --key sencha_compiler_command --value /var/sencha/Sencha/Cmd/7.8.0.59/sencha
./tm configuration --section ext-compiler --key sencha_compiler_sdk --value /var/sencha/ext-7.8.0


./tm configuration --key __SESSION_DSN__ --value sessions
./tm configuration --key __SESSION_USER__ --value systemuser

./tm createsystem --silent --db db --session sessions
echo "./tm install-sessionsql-bsc-main --client db ======================="

# ./tm install-sql-bsc-main --client db
./tm install-sessionsql-bsc-main --client db
./tm install-sql-sessionviews --client db
./tm install-sql-bsc-main-ds --client db
./tm install-sql-bsc-menu --client db

./tm install-sql-ds-main --client db

echo "./tm install-sql-ds --client db ======================="
./tm install-sql-ds --client db

echo "./tm install-sql-ds-dsx --client db ======================="
./tm install-sql-ds-dsx --client db


echo "./tm install-sql-ds-privacy --client db ======================="
./tm install-sql-ds-privacy --client db


echo "./tm install-sql-ds-docsystem --client db ======================="
./tm install-sql-ds-docsystem --client db


echo "./tm install-sql-tualojs --client db ======================="
./tm install-sql-tualojs --client db

echo "./tm install-sql-monaco --client db ======================="
./tm install-sql-monaco --client db


echo "./tm install-sql-dashboard --client db ======================="
./tm install-sql-dashboard --client db

echo "./tm install-sql-bootstrap --client db ======================="
./tm install-sql-bootstrap --client db
./tm configuration --section scss --key cmd --value $(which sass)
./tm import-bootstrap-scss --client db

echo "./tm install-sql-bootstrap-menu --client db ======================="
./tm install-sql-bootstrap-menu --client db

echo "./tm install-sql-cms --client db ======================="
./tm install-sql-cms --client db

echo "./tm install-sql-cms-menu --client db ======================="
./tm install-sql-cms-menu --client db



echo "./tm import-onlinevote --client db ======================="
./tm install-sql-onlinevote --client db


echo "./tm import-onlinevote-page --client db ======================="
./tm import-onlinevote-page --client db

# ./tm configuration --section ext-compiler --key sencha_compiler_command --value $(which sencha)


apache2ctl -D FOREGROUND

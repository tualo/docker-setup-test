#!/bin/sh

if [ -z "$databasename" ]
then
    databasename="db"
    echo "SETTING DATABASE: $databasename"
else 
    echo "USING DATABASE: $databasename"
fi


if [ -z "$package" ]
then
    package="onlinevote"
    echo "SETTING PACKAGE: $package"
else 
    echo "USING PACKAGE: $package"
fi

cd /home/webuser/www/html/server

echo "[client]" > ~/.my.cnf 
echo "host=127.0.0.1" >> ~/.my.cnf 
echo "port=3306" >> ~/.my.cnf 
echo "user=systemuser" >> ~/.my.cnf 
echo "password=" >> ~/.my.cnf


echo "=========================================================="

echo "composer require --no-interaction tualo/$package"
composer require --no-interaction tualo/$package
composer update

mkdir -p /home/webuser/www/html/server
chmod 777 /home/webuser/www/html/server

mkdir -p ./temp
chmod 777 ./temp

./tm configuration --section ext-compiler --key sencha_compiler_command --value /var/sencha/Sencha/Cmd/7.8.0.59/sencha
./tm configuration --section ext-compiler --key sencha_compiler_sdk --value /var/sencha/ext-7.8.0


./tm configuration --key __SESSION_DSN__ --value sessions
./tm configuration --key __SESSION_USER__ --value systemuser

./tm install-htaccess

./tm createsystem --silent --db $databasename --session sessions

echo "./tm install-sessionsql-bsc-main --client $databasename ======================="

# ./tm install-sql-bsc-main --client $databasename
./tm install-sessionsql-bsc-main --client $databasename
./tm install-sql-sessionviews --client $databasename
./tm install-sql-bsc-main-ds --client $databasename
./tm install-sql-bsc-menu --client $databasename

./tm install-sql-ds-main --client $databasename

echo "./tm install-sql-ds --client $databasename ======================="
./tm install-sql-ds --client $databasename

echo "./tm install-sql-ds-dsx --client $databasename ======================="
./tm install-sql-ds-dsx --client $databasename


echo "./tm install-sql-ds-privacy --client $databasename ======================="
./tm install-sql-ds-privacy --client $databasename


echo "./tm install-sql-ds-docsystem --client $databasename ======================="
./tm install-sql-ds-docsystem --client $databasename


echo "./tm install-sql-tualojs --client $databasename ======================="
./tm install-sql-tualojs --client $databasename

echo "./tm install-sql-monaco --client $databasename ======================="
./tm install-sql-monaco --client $databasename


echo "./tm install-sql-dashboard --client $databasename ======================="
./tm install-sql-dashboard --client $databasename

echo "./tm install-sql-bootstrap --client $databasename ======================="
./tm install-sql-bootstrap --client $databasename
./tm configuration --section scss --key cmd --value $(which sass)
./tm import-bootstrap-scss --client $databasename

echo "./tm install-sql-bootstrap-menu --client $databasename ======================="
./tm install-sql-bootstrap-menu --client $databasename

echo "./tm install-sql-cms --client $databasename ======================="
./tm install-sql-cms --client $databasename

echo "./tm install-sql-cms-menu --client $databasename ======================="
./tm install-sql-cms-menu --client $databasename





echo "./tm import-onlinevote --client $databasename ======================="
./tm install-sql-onlinevote --client $databasename
./tm import-onlinevote-page --client $databasename

echo "./tm import-onlinevote-page --client $databasename ======================="
./tm import-onlinevote-page --client $databasename



./tm configuration --section ext-compiler --key java_options --value "-Xms4096m -Xmx8192m -XX:+AlwaysPreTouch -XX:+TieredCompilation -XX:NewRatio=1 -XX:+UseConcMarkSweepGC -XX:MaxMetaspaceSize=1024m -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:MaxTenuringThreshold=15"
export _JAVA_OPTIONS="-Xms4096m -Xmx8192m -XX:+AlwaysPreTouch -XX:+TieredCompilation -XX:NewRatio=1 -XX:+UseConcMarkSweepGC -XX:MaxMetaspaceSize=1024m -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:MaxTenuringThreshold=15"
echo "USING _JAVA_OPTIONS: $_JAVA_OPTIONS"

echo "START DEFAULT COMPILER"
./tm compile

echo "START *$databasename* COMPILER"
./tm compile --client $databasename

./tm createuser --username admin --password admin --client $databasename --master --groups administration

echo "DONE"

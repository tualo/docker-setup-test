#!/bin/sh

service mariadb start
service apache2 start

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


mysql -e "drop database if exists $databasename";
mysql -e "drop database if exists sessions";

mysql -e "create user if not exists 'systemuser'@'%' identified by ''";
mysql -e "grant all on *.* to 'systemuser'@'%' with grant option";

 
runuser -l webuser -c "sh /home/webuser/scripts/user_run.sh"




runuser -l webuser chmod -R 777 .
runuser -l webuser chmod -R 777 /var/sencha/Sencha/Cmd/repo

# ./tm configuration --section ext-compiler --key sencha_compiler_command --value $(which sencha)


# apache2ctl -D FOREGROUND
tail -f /var/log/apache2/error.log
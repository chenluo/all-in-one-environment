#!/bin/bash

cd $APP_DIR

MYSQL_BINARY_PACKAGE=mysql-8.0.31-linux-glibc2.12-x86_64
if [ -f ${MYSQL_BINARY_PACKAGE}.tar.xz ]; then
    echo 'mysql downloaded'
    if [ -d $MYSQL_BINARY_PACKAGE ]; then
        echo 'mysql extracted'
    else
        tar xvf $MYSQL_BINARY_PACKAGE.tar.xz
    fi
else
    curl -O https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-8.0.31-linux-glibc2.12-x86_64.tar.xz && tar xvf mysql-8.0.31-linux-glibc2.12-x86_64.tar.xz
fi
rm $WORKSPACE/mysql
ln -s $WORKSPACE/apps/$MYSQL_BINARY_PACKAGE $WORKSPACE/mysql

MYSQL_DIR=$WORKSPACE/mysql
mkdir $MYSQL_DIR/data $MYSQL_DIR/tmp $MYSQL_DIR/log
# cp $CONFIG_DIR/my.cnf $MYSQL_DIR/my.cnf
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql
$MYSQL_DIR/bin/mysqld --initialize-insecure --user=mysql --basedir=$MYSQL_DIR
$MYSQL_DIR/bin/mysql_ssl_rsa_setup --datadir=$MYSQL_DIR/data
$MYSQL_DIR/bin/mysqld_safe --user=mysql --basedir=$MYSQL_DIR --datadir=$MYSQL_DIR/data \
    --log-error --log-bin --socket=$MYSQL_DIR/mysql.sock --default-storage-engine=InnoDB \
    --general-log=1 --general-log-file --slow-query-log=1 --long_query-time=1\
    --slow-query-log-file &

sleep 3

# add user
export MYSQL_USER_NAME=chen
export MYSQL_PASSWORD="$(openssl rand -base64 12)"
echo "random password: $MYSQL_PASSWORD"
MYSQL_LOGIN_PARAM="-uroot --skip-password -S ${MYSQL_DIR}/mysql.sock"
# localhost access
$MYSQL_DIR/bin/mysql $MYSQL_LOGIN_PARAM -e "CREATE USER ${MYSQL_USER_NAME}@localhost IDENTIFIED BY '${MYSQL_PASSWORD}';" &&  echo "random password: $MYSQL_PASSWORD" > $MYSQL_DIR/mysql.password
$MYSQL_DIR/bin/mysql $MYSQL_LOGIN_PARAM -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER_NAME}'@'localhost';"
# remote access
$MYSQL_DIR/bin/mysql $MYSQL_LOGIN_PARAM -e "CREATE USER ${MYSQL_USER_NAME}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
$MYSQL_DIR/bin/mysql $MYSQL_LOGIN_PARAM -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER_NAME}'@'%';"

$MYSQL_DIR/bin/mysql $MYSQL_LOGIN_PARAM -e "FLUSH PRIVILEGES;"

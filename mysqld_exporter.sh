#!/bin/bash

cd $APP_DIR
MYSQLD_EXPORTER_PACKAGE=mysqld_exporter-0.14.0.linux-amd64
if [ -d $MYSQLD_EXPORTER_PACKAGE ]; then
    echo 'exporter extracted'
else
    if [ -f ${MYSQLD_EXPORTER_PACKAGE}.tar.gz ]; then
        echo 'exporter downloaded'
        tar zxvf ${MYSQLD_EXPORTER_PACKAGE}.tar.gz
    else
        echo 'download and extracting'
        curl -o ${MYSQLD_EXPORTER_PACKAGE}.tar.gz 'https://objects.githubusercontent.com/github-production-release-asset-2e65be/32075541/32c409af-b7bf-4f96-a811-72cf640f4ee4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20221023%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221023T153522Z&X-Amz-Expires=300&X-Amz-Signature=f45b209c2c2f75686f65c5189190ea516db0262975e02bf3c30ed7307b381c09&X-Amz-SignedHeaders=host&actor_id=1914023&key_id=0&repo_id=32075541&response-content-disposition=attachment%3B%20filename%3Dmysqld_exporter-0.14.0.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream' && tar zxvf ${MYSQLD_EXPORTER_PACKAGE}.tar.gz
    fi
fi

ln -s $APP_DIR/$MYSQLD_EXPORTER_PACKAGE $WORKSPACE/mysqld_exporter

MYSQLD_EXPORTER_DIR=$WORKSPACE/mysqld_exporter
cp $CONFIG_DIR/mysqld_exporter.conf $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf -f
MYSQL_PASSWORD=`cat ${WORKSPACE}/mysql/mysql.password`

echo "sed -i s#password=changeit#password=$MYSQL_PASSWORD# $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf"
sed -i s#password=changeit#password=$MYSQL_PASSWORD# $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf

nohup $MYSQLD_EXPORTER_DIR/mysqld_exporter --config.my-cnf $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf --collect.auto_increment.columns --collect.binlog_size --collect.engine_innodb_status --collect.engine_tokudb_status --collect.global_status --web.listen-address=0.0.0.0:9104 2>&1 > $MYSQLD_EXPORTER_DIR/mysqld_exporter.log &

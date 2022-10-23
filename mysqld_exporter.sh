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
        curl -o ${MYSQLD_EXPORTER_PACKAGE}.tar.gz -L 'https://github.com/prometheus/mysqld_exporter/releases/download/v0.14.0/mysqld_exporter-0.14.0.linux-amd64.tar.gz' && tar zxvf ${MYSQLD_EXPORTER_PACKAGE}.tar.gz
    fi
fi

ln -s $APP_DIR/$MYSQLD_EXPORTER_PACKAGE $WORKSPACE/mysqld_exporter

MYSQLD_EXPORTER_DIR=$WORKSPACE/mysqld_exporter
cp $CONFIG_DIR/mysqld_exporter.conf $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf -f
MYSQL_PASSWORD=`cat ${WORKSPACE}/mysql/mysql.password`

echo "sed -i s#password=changeit#password=$MYSQL_PASSWORD# $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf"
sed -i s#password=changeit#password=$MYSQL_PASSWORD# $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf

nohup $MYSQLD_EXPORTER_DIR/mysqld_exporter --config.my-cnf $MYSQLD_EXPORTER_DIR/mysqld_exporter.conf --collect.auto_increment.columns --collect.binlog_size --collect.engine_innodb_status --collect.engine_tokudb_status --collect.global_status --web.listen-address=0.0.0.0:9104 2>&1 > $MYSQLD_EXPORTER_DIR/mysqld_exporter.log &

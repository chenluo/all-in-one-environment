#!/bin/bash


URL='https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz'

cd $APP_DIR
PROMETHEUS_PACKAGE=prometheus-2.39.1.linux-amd64
if [ -d $APP_DIR/$PROMETHEUS_PACKAGE ];then
    echo 'extracted'
else
    if [ -f $APP_DIR/${PROMETHEUS_PACKAGE}.tar.gz ];then
        echo 'downloaded'
        tar zxvf ${PROMETHEUS_PACKAGE}.tar.gz
    else
        echo 'download and extracting'
        curl -o $APP_DIR/${PROMETHEUS_PACKAGE}.tar.gz -L $URL && tar zxvf ${PROMETHEUS_PACKAGE}.tar.gz
    fi
fi
ln -s $APP_DIR/$PROMETHEUS_PACKAGE $WORKSPACE/prometheus

PROMETHEUS_DIR=$WORKSPACE/prometheus
cp $CONFIG_DIR/prometheus.yml $PROMETHEUS_DIR/prometheus.yml

nohup $PROMETHEUS_DIR/prometheus --config.file $PROMETHEUS_DIR/prometheus.yml 2>&1 > $PROMETHEUS_DIR/prometheus.log &

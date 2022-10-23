#!/bin/bash


URL='https://objects.githubusercontent.com/github-production-release-asset-2e65be/6838921/81e7d819-6f49-4463-8ae6-caab757e9ced?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20221023%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221023T161542Z&X-Amz-Expires=300&X-Amz-Signature=1e0b59caf95a5521f7cfb4faeb3e588cded0e00d70a2247d02d8b6c88e9c622b&X-Amz-SignedHeaders=host&actor_id=1914023&key_id=0&repo_id=6838921&response-content-disposition=attachment%3B%20filename%3Dprometheus-2.39.1.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream'

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
        curl -o $APP_DIR/${PROMETHEUS_PACKAGE}.tar.gz $URL && tar zxvf ${PROMETHEUS_PACKAGE}.tar.gz
    fi
fi
ln -s $APP_DIR/$PROMETHEUS_PACKAGE $WORKSPACE/prometheus

PROMETHEUS_DIR=$WORKSPACE/prometheus
cp $CONFIG_DIR/prometheus.yml $PROMETHEUS_DIR/prometheus.yml

nohup $PROMETHEUS_DIR/prometheus --config.file $PROMETHEUS_DIR/prometheus.yml 2>&1 > $PROMETHEUS_DIR/prometheus.log &

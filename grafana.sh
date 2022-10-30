#!/bin/bash

cd $APP_DIR
GRAFANA_DIR=$WORKSPACE/grafana
if [ $PRE = true ]; then
    URL='https://dl.grafana.com/oss/release/grafana-9.2.2.linux-amd64.tar.gz'

    GRAFANA_PACKAGE=grafana-9.2.2.linux-amd64
    if [ -d $APP_DIR/grafana-9.2.2 ];then
        echo 'extracted'
    else
        if [ -f $APP_DIR/${GRAFANA_PACKAGE}.tar.gz ];then
            echo 'downloaded'
            tar zxvf ${GRAFANA_PACKAGE}.tar.gz
        else
            echo 'download and extracting'
            curl -o $APP_DIR/${GRAFANA_PACKAGE}.tar.gz -L $URL && tar zxvf ${GRAFANA_PACKAGE}.tar.gz
        fi
    fi
    ln -s $APP_DIR/grafana-9.2.2 $WORKSPACE/grafana

    #cp $CONFIG_DIR/grafana.yml $GRAFANA_DIR/grafana.yml
fi

if [ $RUN = true ]; then
    cd $GRAFANA_DIR
    nohup ./bin/grafana-server start 2>&1 > $GRAFANA_DIR/grafana.log &
fi

#!/bin/bash

cd $APP_DIR
NODE_EXPORTER_DIR=$WORKSPACE/node_exporter
if [ $PRE = true ]; then
    URL='https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz'

    NODE_EXPORTER_PACKAGE=node_exporter-1.4.0.linux-amd64
    if [ -d $APP_DIR/$NODE_EXPORTER_PACKAGE ];then
        echo 'extracted'
    else
        if [ -f $APP_DIR/${NODE_EXPORTER_PACKAGE}.tar.gz ];then
            echo 'downloaded'
            tar zxvf ${NODE_EXPORTER_PACKAGE}.tar.gz
        else
            echo 'download and extracting'
            curl -o $APP_DIR/${NODE_EXPORTER_PACKAGE}.tar.gz -L $URL && tar zxvf ${NODE_EXPORTER_PACKAGE}.tar.gz
        fi
    fi
    ln -s $APP_DIR/$NODE_EXPORTER_PACKAGE $WORKSPACE/node_exporter

    #cp $CONFIG_DIR/grafana.yml $NODE_EXPORTER_DIR/grafana.yml
fi

if [ $RUN = true ]; then
    cd $NODE_EXPORTER_DIR
    nohup ./node_exporter 2>&1 > $NODE_EXPORTER_DIR/node_exporter.log &
fi

#!/bin/bash

cd $APP_DIR
ZOOKEEPER_DIR=$WORKSPACE/zookeeper
if [ $PRE = true ]; then
    URL='https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz'

    ZOOKEEPER_PACKAGE=apache-zookeeper-3.8.0-bin
    if [ -d $APP_DIR/$ZOOKEEPER_PACKAGE ];then
        echo 'extracted'
    else
        if [ -f $APP_DIR/${ZOOKEEPER_PACKAGE}.tar.gz ];then
            echo 'downloaded'
            tar zxvf ${ZOOKEEPER_PACKAGE}.tar.gz
        else
            echo 'download and extracting'
            curl -o $APP_DIR/${ZOOKEEPER_PACKAGE}.tar.gz -L $URL && tar zxvf ${ZOOKEEPER_PACKAGE}.tar.gz
        fi
    fi
    ln -s $APP_DIR/$ZOOKEEPER_PACKAGE $WORKSPACE/zookeeper

    cp $CONFIG_DIR/zoo.cfg $ZOOKEEPER_DIR/conf/zoo.cfg


fi

if [ $RUN = true ]; then
    cd $ZOOKEEPER_DIR
    #export JVMFLAGS=-javaagent:$WORKSPACE/jmx_exporter/jmx_prometheus_javaagent-0.17.2.jar=2901:$CONFIG_DIR/jmx_exporter_cfgs/zookeeper.yml

    nohup ./bin/zkServer.sh start 2>&1 > $ZOOKEEPER_DIR/zookeeper.log &
    #unset JVMFLAGS
fi

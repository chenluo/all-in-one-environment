#!/bin/bash

cd $APP_DIR
CASSANDRA_DIR=$WORKSPACE/cassandra
if [ $PRE = true ]; then
    URL='https://archive.apache.org/dist/cassandra/3.11.2/apache-cassandra-3.11.2-bin.tar.gz'

    CASSANDRA_PACKAGE=apache-cassandra-3.11.2
    if [ -d $APP_DIR/$CASSANDRA_PACKAGE ];then
        echo 'extracted'
    else
        if [ -f $APP_DIR/${CASSANDRA_PACKAGE}.tar.gz ];then
            echo 'downloaded'
            tar zxvf ${CASSANDRA_PACKAGE}.tar.gz
        else
            echo 'download and extracting'
            curl -o $APP_DIR/${CASSANDRA_PACKAGE}.tar.gz -L $URL && tar zxvf ${CASSANDRA_PACKAGE}.tar.gz
        fi
    fi
    ln -s $APP_DIR/$CASSANDRA_PACKAGE $WORKSPACE/cassandra

    # cp $CONFIG_DIR/zoo.cfg $CASSANDRA_DIR/conf/zoo.cfg
fi

if [ $RUN = true ]; then
    cd $CASSANDRA_DIR
    #export JVMFLAGS=-javaagent:$WORKSPACE/jmx_exporter/jmx_prometheus_javaagent-0.17.2.jar=2901:$CONFIG_DIR/jmx_exporter_cfgs/zookeeper.yml

    nohup ./bin/cassandra 2>&1 > $CASSANDRA_DIR/cassandra.log &
    #unset JVMFLAGS
fi

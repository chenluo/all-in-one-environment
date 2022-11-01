#!/bin/bash

cd $APP_DIR
JMX_EXPORTER_DIR=$WORKSPACE/node_exporter
if [ $PRE = true ]; then
    URL='https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.17.2/jmx_prometheus_javaagent-0.17.2.jar'

    JMX_EXPORTER_PACKAGE=jmx_prometheus_javaagent-0.17.2.jar
    if [ -d $APP_DIR/$JMX_EXPORTER_PACKAGE ];then
        echo 'downloaded'
    else
        echo 'download'
        curl -o $APP_DIR/${JMX_EXPORTER_PACKAGE} -L $URL
    fi
    mkdir $APP_DIR/jmx_exporter
    cp $APP_DIR/$JMX_EXPORTER_PACKAGE $APP_DIR/jmx_exporter
    ln -s $APP_DIR/jmx_exporter $WORKSPACE/jmx_exporter

fi

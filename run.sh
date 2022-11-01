#!/bin/bash

source ./config.sh

SKIP=true
export PRE=false
export RUN=false
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 0
fi

if [ ! -z "$1" ]; then
    if [ $1 = pre ]; then
        export PRE=true
        shift
    fi

    if [ $1 = run ]; then
        export RUN=true
        shift
    fi
fi

if [ ! -z $1 ]; then
    if [ $1 = pre ]; then
        export PRE=true
        shift
    fi

    if [ $1 = run ]; then
        export RUN=true
        shift
    fi
fi

if [ $PRE = true ]; then
    SKIP=false
fi

if [ $RUN = true ]; then
    SKIP=false
fi
echo PRE:$PRE
echo RUN:$RUN
echo SKIP:$SKIP

if [ $SKIP = false ]; then
    source $WORKSPACE/mysql.sh && source $WORKSPACE/mysqld_exporter.sh && source $WORKSPACE/prometheus.sh && source $WORKSPACE/grafana.sh && source $WORKSPACE/node_exporter.sh && source $WORKSPACE/zookeeper.sh
fi


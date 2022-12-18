#!/bin/bash

CUR="${BASH_SOURCE-$0}"
CUR="$(dirname "${CUR}")"
CUR_DIR="$(cd "${CUR}"; pwd)"
source $CUR_DIR/config.sh

SKIP=true
export PRE=false
export RUN=false
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 0
fi

if [ ! -z $1 ]; then
    if [ $1 = run ]; then
        export RUN=true
        shift
    fi
    if [ $1 = pre ]; then
        export PRE=true
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
    source $WORKSPACE/mysql.sh \
    && source $WORKSPACE/mysqld_exporter.sh
fi


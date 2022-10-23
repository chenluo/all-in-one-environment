#!/bin/bash

source ./config.sh

# for mysql
source $WORKSPACE/mysql.sh && source $WORKSPACE/mysqld_exporter.sh && source $WORKSPACE/prometheus.sh


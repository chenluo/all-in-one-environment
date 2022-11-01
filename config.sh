#!/bin/bash

CUR="${BASH_SOURCE-$0}"
CUR="$(dirname "${CUR}")"
CUR_DIR="$(cd "${CUR}"; pwd)"
export WORKSPACE=$CUR_DIR
export CONFIG_DIR=$WORKSPACE/config
export APP_DIR=$WORKSPACE/apps

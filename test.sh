download () {

    APP = $1 # zookeeper
    echo $APP
    URL = $2 # https://....
    echo $URL
    STRIP = $3 # 0, 1
    CONFIG_FILE = $4 # zoo.cfg
    CONFIG_FILE_TARGET_DIR = $5 # conf

    mkdir $APP_DIR/$APP
    mkdir $APP_DIR/$APP/$APP

    if [ -f $APP_DIR/$APP/$APP.tar.gz ];then
        echo "downloaded"
    else
        echo "downloading"
        curl -o $APP_DIR/$APP/$APP.tar.gz -L $URL
    fi

    if [ -d $APP_DIR/$APP/$APP ];then
        echo 'extracted'
    else
        echo 'extracting'
        tar zxvf ${PACKAGE}.tar.gz -C $APP_DIR/$APP/$APP --strip-components=$STRIP
    fi

    echo "linking"
    ln -s $APP_DIR/$APP/$APP $WORKSPACE/$APP

    if [ $CONFIG_FILE = "" ]; then
        echo "no cfg"
    else
        cp $CONFIG_DIR/$CONFIG_FILE $APP_DIR/$APP/$APP/$CONFIG_FILE_TARGET_DIR/
    fi
}
source config.sh
download zk 'https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz' 1 zoo.cfg conf

.ONESHELL: # in each target, it will use the same shell.

appTar = ${newAppTar}
appDir = ${newAppDir}
appUrl = ${newAppUrl}
OS = 
ARCH = 
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OS = LINUX
endif
ifeq ($(UNAME_S),Darwin)
	OS = OSX
endif
UNAME_P := $(shell uname -p)
ifeq ($(UNAME_P),x86_64)
	ARCH = AMD64
endif
ifneq ($(filter arm%,$(UNAME_P)),)
	ARCH = ARM
endif

appRoot = apps

# locate this Makefile
ifeq ($(filter /%, $(lastword $(MAKEFILE_LIST))),)
	makefile_path := $(CURDIR)/$(strip $(lastword $(MAKEFILE_LIST)))
else
	makefile_path := $(lastword $(MAKEFILE_LIST))
endif
topdir := $(strip $(patsubst %/, %, $(dir $(makefile_path))))

configure:
	mkdir apps

checkTar:
ifndef appTar
	@echo "appTar not defined"
	false
endif

checkDir:
ifndef appDir
	@echo "appDir not defined"
	false
endif

checkUrl:
ifndef appUrl
	@echo "appUrl not defined"
	false
endif

download: checkTar checkUrl
	cd ${topdir}/${appRoot}
ifeq (,$(wildcard ${appTar}))
	@echo "tar file not exists. Start downloading......"
	/usr/bin/curl -o ${appTar} -L "${appUrl}"
else
	ls ${appTar}
	@echo "downloaded"
endif

extract: checkDir checkTar
	cd ${topdir}/${appRoot}
ifeq (,$(wildcard ${appDir}))
	ls
	tar zxvf ${appTar}
endif

clean_single: checkDir checkTar
	cd ${topdir}/${appRoot}
	rm -rf ${appDir}
	rm ${appTar}

##
## basic settings
##
##

set_cassandra:
	@$(eval newAppTar = cassandra.tar.gz)
ifeq (LINUX,${OS})
	@$(eval newAppDir = apache-cassandra-3.11.2)
	@$(eval newAppUrl = https://archive.apache.org/dist/cassandra/3.11.2/apache-cassandra-3.11.2-bin.tar.gz)
else
	@$(eval newAppDir = apache-cassandra-4.0.7)
	@$(eval newAppUrl = https://dlcdn.apache.org/cassandra/4.0.7/apache-cassandra-4.0.7-bin.tar.gz)
endif

set_zk:
	@$(eval newAppTar = zk.tar.gz)
	@$(eval newAppDir = apache-zookeeper-3.8.0-bin)
	@$(eval newAppUrl = https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz)

set_kafka:
	@$(eval newAppTar = kafka_2.12-3.4.0.tgz)
	@$(eval newAppDir = kafka_2.12-3.4.0)
	@$(eval newAppUrl = https://downloads.apache.org/kafka/3.4.0/kafka_2.12-3.4.0.tgz)
	
set_jmx_exporter:
	@$(eval newAppTar = jmx_exporter.jar)
	@$(eval newAppDir = jmx_exporter)
	@$(eval newAppUrl = https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.17.2/jmx_prometheus_javaagent-0.17.2.jar)

set_node_exporter:
	@$(eval newAppTar = node_exporter.tar.gz)
ifeq (LINUX,${OS})
	@$(eval newAppDir = node_exporter-1.4.0.linux-amd64)
	@$(eval newAppUrl = https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz)
else
	@$(eval newAppDir = node_exporter-1.5.0.darwin-amd64)
	@$(eval newAppUrl = https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.darwin-amd64.tar.gz)
endif

set_mysqld_exporter:
	@$(eval newAppTar = mysqld_exporter.tar.gz)
ifeq (LINUX,${OS})
	@$(eval newAppDir = mysqld_exporter-0.15.0-rc.0.linux-amd64)
	@$(eval newAppUrl = https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.0-rc.0/mysqld_exporter-0.15.0-rc.0.linux-amd64.tar.gz)
else
	@$(eval newAppDir = mysqld_exporter-0.15.0-rc.0.darwin-amd64)
	@$(eval newAppUrl = https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.0-rc.0/mysqld_exporter-0.15.0-rc.0.darwin-amd64.tar.gz)
endif

set_grafana:
	@$(eval newAppTar = grafana.tar.gz)
ifeq (LINUX,${OS})
	@$(eval newAppDir = grafana-9.2.2)
	@$(eval newAppUrl = https://dl.grafana.com/oss/release/grafana-9.2.2.linux-amd64.tar.gz)
else
	@$(eval newAppDir = grafana-9.3.2)
	@$(eval newAppUrl = https://dl.grafana.com/enterprise/release/grafana-enterprise-9.3.2.darwin-amd64.tar.gz)
endif

set_prometheus:
	@$(eval newAppTar = prometheus.tar.gz)
ifeq (LINUX,${OS})
	@$(eval newAppDir = prometheus-2.39.1.linux-amd64)
	@$(eval newAppUrl = https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz)
else
	@$(eval newAppDir = prometheus-2.37.5.darwin-amd64)
	@$(eval newAppUrl = https://github.com/prometheus/prometheus/releases/download/v2.37.5/prometheus-2.37.5.darwin-amd64.tar.gz)
endif

set_redis_source:
	@$(eval newAppTar = redis-stable.tar.gz)
	@$(eval newAppDir = redis-stable)
	@$(eval newAppUrl = https://download.redis.io/redis-stable.tar.gz)

set_postgresql_source:
	@$(eval newAppTar = postgresql-14.7.tar.gz)
	@$(eval newAppDir = postgresql-14.7)
	@$(eval newAppUrl = https://ftp.postgresql.org/pub/source/v14.7/postgresql-14.7.tar.gz)

##
## kafka
##
download_kafka: set_kafka download
	@echo 'download kafka'

extract_kafka: set_kafka extract
	@echo 'extract kafka'

prepare_kafka: download_kafka extract_kafka
	@echo 'prepare kafka'

run_kafka: set_kafka
	cd ${topdir}/${appRoot}/${appDir}
	export JVM_OPTS=-javaagent:${topdir}/${appRoot}/jmx_exporter.jar=9400:${topdir}/config/jmx_exporter_cfgs/kafka_broker.yml
	./bin/kafka-server-start.sh -daemon config/server.properties

kill_kafka: set_kafka
	cd ${topdir}/${appRoot}/${appDir}
	./bin/kafka-server-stop.sh

clean_kafka: set_kafka clean_single

##
## cassandra
##
download_cassandra: set_cassandra download
	@echo 'download cassandra'

extract_cassandra: set_cassandra extract
	@echo 'extract cassandra'

prepare_cassandra: download_cassandra extract_cassandra
	@echo 'prepare cassandra'

run_cassandra: set_cassandra
	cd ${topdir}/${appRoot}/${appDir}
	export JVM_OPTS=-javaagent:${topdir}/${appRoot}/jmx_exporter.jar=9141:${topdir}/config/jmx_exporter_cfgs/cassandra.yml
	./bin/cassandra

kill_cassandra: is_running_cassandra
	kill `lsof -i:9042 -t`

is_running_cassandra:
	lsof -i:9042

clean_cassandra: set_cassandra clean_single

##
## ZooKeeper targets
##
##
download_zk: set_zk download
	@echo 'download zk'

extract_zk: set_zk extract
	@echo 'extract zk'

prepare_zk: download_zk extract_zk
	@echo 'prepare zk'
	ln -s ${topdir}/config/zoo.cfg ${topdir}/${appRoot}/${appDir}/conf/zoo.cfg

run_zk: set_zk
	cd ${topdir}/${appRoot}/${appDir}
	nohup ./bin/zkServer.sh start 2>&1 > ./zookeeper.log &

kill_zk: is_running_zk
	kill `lsof -i:2181 -t`

is_running_zk:
	lsof -i:2181

clean_zk: set_zk clean_single

##
## grafana targets
##
##
download_grafana: set_grafana download
	@echo 'download grafana'

extract_grafana: set_grafana extract
	@echo 'extract grafana'

prepare_grafana: download_grafana extract_grafana
	@echo 'prepare grafana'

run_grafana: set_grafana
	cd ${topdir}/${appRoot}/${appDir}  && nohup ./bin/grafana-server start 2>&1 > ./grafana.log &

kill_grafana: is_running_grafana
	kill `lsof -i:3000 -t`

is_running_grafana:
	lsof -i:3000

clean_grafana: set_grafana clean_single

##
## jmx exporter
## only download is enough
##
download_jmx_exporter: set_jmx_exporter download
	@echo 'download jmx exporter'

prepare_jmx_exporter: download_jmx_exporter
	@echo 'prepare jmx exporter'

##
## promethus targets
##
##
download_prometheus: set_prometheus download
	@echo 'download prometheus'

extract_prometheus: set_prometheus extract
	@echo 'extract prometheus'

prepare_prometheus: download_prometheus extract_prometheus
	@echo 'prepare prometheus'
	cp -f ${topdir}/config/prometheus.yml ${topdir}/${appRoot}/${appDir}/

run_prometheus: set_prometheus
	cd ${topdir}/${appRoot}/${appDir}
	nohup ./prometheus --config.file ./prometheus.yml 2>&1 > ./prometheus.log &

kill_prometheus: is_running_prometheus
	kill `lsof -i:9090 -t`

is_running_prometheus:
	lsof -i:9090

clean_prometheus: set_prometheus clean_single

##
## promethus targets
##
##
download_mysqld_exporter: set_mysqld_exporter download
	@echo 'download mysqld_exporter'

extract_mysqld_exporter: set_mysqld_exporter extract
	@echo 'extract mysqld_exporter'

prepare_mysqld_exporter: download_mysqld_exporter extract_mysqld_exporter
	@echo 'prepare mysqld_exporter'

run_mysqld_exporter: set_mysqld_exporter
	cd ${topdir}/${appRoot}/${appDir} &&  nohup ./mysqld_exporter --config.my-cnf ${topdir}/config/mysqld_exporter.conf --collect.auto_increment.columns --collect.binlog_size --collect.engine_innodb_status --collect.engine_tokudb_status --collect.global_status --web.listen-address=0.0.0.0:9104 2>&1 ./mysqld_exporter.log &

kill_mysqld_exporter: is_running_mysqld_exporter
	kill `lsof -i:9104 -t`

is_running_mysqld_exporter:
	lsof -i:9104

clean_mysqld_exporter: set_mysqld_exporter clean_single


##
## redis-source
##
##
download_redis_source: set_redis_source download
	@echo 'download_redis_source'

extract_redis_source: set_redis_source extract
	@echo 'download_redis_source'

prepare_redis_source: download_redis_source extract_redis_source 
	@echo 'prepare_redis_source'
	cd ${topdir}/${appRoot}/${appDir}
	bash ./configure
	make
	make PREFIX=./ install

run_redis: set_redis_source
	@echo 'run_redis_source'
	cd ${topdir}/${appRoot}/${appDir}
	nohup ./src/redis-server 2>&1 > ./redis.log &

kill_redis: is_running_redis
	kill `lsof -i:6379 -t`

is_running_redis:
	lsof -i:6379

##
## postgresql-source
##
##
download_postgresql_source: set_postgresql_source download
	@echo 'download_postgresql_source'

extract_postgresql_source: set_postgresql_source extract
	@echo 'download_postgresql_source'

prepare_postgresql_source: download_postgresql_source extract_postgresql_source 
	@echo 'prepare_postgresql_source'
	cd ${topdir}/${appRoot}/${appDir}
	bash configure --prefix=${topdir}/${appRoot}/${appDir}
	$(MAKE) clean && $(MAKE) all && $(MAKE) install 
	ls data || mkdir data
	./bin/initdb -D ./data
	@echo 'recusive make may failed.'

run_postgresql: set_postgresql_source
	@echo 'run_postgresql_source'
	cd ${topdir}/${appRoot}/${appDir}
	nohup ./bin/pg_ctl -D ./data -l logfile start &

kill_postgresql: is_running_postgresql
	kill `lsof -i:5432 -t`

is_running_postgresql:
	lsof -i:5432

##
## mysql docker
##
prepare_mysql:
	@echo 'prepare for mysql docker'
	mkdir ${topdir}/${appRoot}/mysql-dir

run_mysql:
	@echo 'run mysql docker'
	docker start mysql8 || docker run --name mysql8 -v ${topdir}/${appRoot}/mysql-dir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mysql -p3306:3306 -d mysql:8.0.32

kill_mysql:
	@echo 'kill mysql docker'
	docker stop mysql8
	docker rm mysql8

##
## mysqld_exporter
##
download_node_exporter: set_node_exporter download
	@echo 'download node_exporter'

extract_node_exporter: set_node_exporter extract
	@echo 'extract node_exporter'

prepare_node_exporter: download_node_exporter extract_node_exporter
	@echo 'prepare node_exporter'

run_node_exporter: set_node_exporter
	cd ${topdir}/${appRoot}/${appDir}
	nohup ./node_exporter 2>&1 > ./node_exporter.log &

kill_node_exporter: is_running_node_exporter
	kill `lsof -i:9100 -t`

is_running_node_exporter:
	lsof -i:9100

clean_node_exporter: set_node_exporter clean_single

##
## *_all targets
##
prepare_all: prepare_cassandra prepare_jmx_exporter prepare_zk prepare_prometheus prepare_grafana prepare_node_exporter prepare_redis_source prepare_postgresql_source
	@echo 'prepare all success'

run_all: run_cassandra run_zk run_grafana run_prometheus run_node_exporter run_redis run_postgresql
	@echo 'run all success'

all: prepare_all run_all
	@echo 'all'

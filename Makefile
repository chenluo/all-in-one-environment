.ONESHELL: # in each target, it will use the same shell.

appTar = ${newAppTar}
appDir = ${newAppDir}
appUrl = ${newAppUrl}

appRoot = apps

# locate this Makefile
ifeq ($(filter /%, $(lastword $(MAKEFILE_LIST))),)
	makefile_path := $(CURDIR)/$(strip $(lastword $(MAKEFILE_LIST)))
else
	makefile_path := $(lastword $(MAKEFILE_LIST))
endif
topdir := $(strip $(patsubst %/, %, $(dir $(makefile_path))))

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
	echo $(pwd)
	curl -o ${appTar} -L "${appUrl}"
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


##
## basic settings
##
##

set_cassandra:
	@$(eval newAppTar = cassandra.tar.gz)
	@$(eval newAppDir = apache-cassandra-3.11.2)
	@$(eval newAppUrl = https://archive.apache.org/dist/cassandra/3.11.2/apache-cassandra-3.11.2-bin.tar.gz)

set_zk:
	@$(eval newAppTar = zk.tar.gz)
	@$(eval newAppDir = apache-zookeeper-3.8.0-bin)
	@$(eval newAppUrl = https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz)


##
## ZooKeeper targets
##
##
download_cassandra: set_cassandra download
	@echo 'download cassandra'

extract_cassandra: set_cassandra extract
	@echo 'extract cassandra'

prepare_cassandra: download_cassandra extract_cassandra
	@echo 'prepare cassandra'

run_cassandra: set_cassandra
	cd ${topdir}/${appRoot}/${appDir}
	JAVA_HOME=/home/chen/.jdks/azul-1.8.0_275
	./bin/cassandra

kill_cassandra: is_running_cassandra
	kill `lsof -i:9042 -t`

is_running_cassandra:
	lsof -i:9042

clean_cassandra: set_cassandra
	cd ${topdir}/${appRoot}
	rm -rf ${appDir}
	rm ${appTar}

download_zk: set_zk download
	@echo 'download zk'

##
## ZooKeeper targets
##
##
extract_zk: set_zk extract
	@echo 'extract zk'

prepare_zk: download_zk extract_zk
	@echo 'prepare zk'
	ln -s ${topdir}/config/zoo.cfg ${topdir}/${appRoot}/${appDir}/conf/zoo.cfg


run_zk: set_zk
	cd ${topdir}/${appRoot}/${appDir}
	JAVA_HOME=/home/chen/.jdks/azul-1.8.0_275
	nohup ./bin/zkServer.sh start 2>&1 > ./zookeeper.log &

kill_zk: is_running_zk
	kill `lsof -i:2181 -t`

is_running_zk:
	lsof -i:2181

clean_zk: set_zk
	cd ${topdir}/${appRoot}
	rm -rf ${appDir}
	rm ${appTar}

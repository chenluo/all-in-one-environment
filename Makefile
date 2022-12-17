.ONESHELL:

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

set_cassandra:
	@$(eval newAppTar = cassandra.tar.gz)
	@$(eval newAppDir = apache-cassandra-3.11.2)
	@$(eval newAppUrl = https://archive.apache.org/dist/cassandra/3.11.2/apache-cassandra-3.11.2-bin.tar.gz)

download_cassandra: set_cassandra download
	@echo 'download cassandra'
	@echo ${appTar}
	@echo ${appDir}
	@echo ${appUrl}

extract_cassandra: set_cassandra extract
	@echo 'extract cassandra'
	@echo ${appTar}
	@echo ${appDir}
	@echo ${appUrl}

prepare_cassandra: download_cassandra extract_cassandra
	@echo 'prepare cassandra'
	@echo ${appTar}
	@echo ${appDir}
	@echo ${appUrl}

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
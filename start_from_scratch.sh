#!/bin/bash

# Author: Louis Holbrook <dev@holbrook.no> https://holbrook.no
# License: GPLv3
# GPG: 0826EDA1702D1E87C6E2875121D2E7BB88C2A746
# Description: Create a 100% clean deployment of the sarafu platform for use in development
#
# Script is not in safe state and may not exit cleanly; you might have to manually kill celery and ganache

if [ "$1" != 'REALLY' ]; then
	>&2 echo arg 1 must be "REALLY"
	exit 1
fi
if [ ! -d "$2" ]; then
	>&2 echo arg 2 must be a directory
	exit 1
fi

# dirs and paths

d=`realpath $(dirname ${BASH_SOURCE[0]})`
d_log=$d/var/log/sarafu
d_lib=$d/var/lib/sarafu
d_run=$d/var/run/sarafu

for p in `find $d_run -iname '*.pid'`; do
	pp=`cat $p`
	echo "killing pid $pp"
	kill -TERM $pp
done

mkdir -p $d_log
mkdir -p $d_lib
mkdir -p $d_run

. quick_env.sh
export PYTHONPATH=$d/eth_worker/eth_manager:$d/eth_worker:$d/eth_worker/eth_manager/task_interfaces

GIT_BANCOR_COMMIT_REQUIRED=5cf00451da0cc51db1d4b76d7e8b482d085f9423

# verify tool dependencies

# node version must match bancor requirement
node_bin=`which node`
if [ "$?" -gt 0 ]; then
	>&2 echo "node not found"
	exit 1
fi
node_version=`node --version`
node_version_bancor="10.16.0"
if [ "$node_version" != "v${node_version_bancor}" ]; then
	nvm_bin=`which nvm`
	if [ $? -gt 0 ]; then
		>&2 echo "bancor needs node version $node_version_bancor. Maybe nvm can help you out?"
		exit 1	
	fi
	nvm use 10.16.0
	if [ $? -gt 0 ]; then
		>&2 echo "nvm could not switch to node version $node_version_bancor which is needed by bancor"
		exit 1	
	fi
fi


# prepare the blockchainy part

# fire up ganache

ganache_bin=`which ganache-cli`
mkdir -p $d_lib/ganache.db
rm $d_lib/ganache.db/*
$ganache_bin -i 42 -l 800000000 -g 2000000000 -s 666 -p 7545 --acctKeys $d_lib/ganache.accounts --db $d_lib/ganache.db 2> $d_log/ganache.log &
pid_ganache=$!
echo -n $pid_ganache > $d_run/ganache.pid
echo "waiting 3 secs for ganache to start (pid $pid_ganache)..."
sleep 3

bancor_dir=${BANCOR_DIR:-$2}
if [ ! -d $bancor_dir ]; then
	>&2 echo "bancor dir not a dir"
	exit 1
fi


pushd $bancor_dir
bancor_commit=`git rev-parse HEAD`
if [ "$bancor_commit" != "$GIT_BANCOR_COMMIT_REQUIRED" ]; then
	>&2 echo "wrong bancor version, need $GIT_BANCOR_COMMIT_REQUIRED, have $bancor_commit"
	exit 1
fi
if [ ! -d "node_modules" ]; then # risky, doesn't check the contents
	npm install
fi
if [ ! -f${bancor_dir}/node_modules/truffle/build/cli.bundled.js ]; then
	>&2 echo "cannot find truffle bin"
fi	
truffle=${bancor_dir}/node_modules/truffle/build/cli.bundled.js
pushd solidity


$truffle --network development migrate
popd
popd


# APP
#
# generate new configs from template
# note in section public/local_config.ini;
# contract addresses will always be the same if deployed with same source and same network settings in ganache

# todo move config to etc
rm -rf $d/config_files/secret
mkdir -vp $d/config_files/secret
pushd config_files
python3 generate_dev_test_secrets_ge.py
popd

# purge old database
# and reinstall schema

dropdb -U postgres -h 127.0.0.1 sarafu
dropdb -U postgres -h 127.0.0.1 sarafu_eth
createdb -U postgres -h 127.0.0.1 sarafu
createdb -U postgres -h 127.0.0.1 sarafu_eth
psql -U postgres -h 127.0.0.1 -d sarafu -f schema/sarafu_schema.sql
psql -U postgres -h 127.0.0.1 -d sarafu_eth -f schema/sarafu_eth_schema.sql

if [ "$?" -gt 0 ]; then
	>&2 echo "db setup fail"
	exit 1
fi

# start the celery task manager
# this is needed for seeing the bootstrap data

echo -e "\n>>> STARTING CELERY\n"
celery -E -A celery_tasks worker &
pid_celery=$!
echo -n $pid_celery > $d_run/celery.pid
echo "waiting 5 secs for ganache to start (pid $pid_celery)..."
sleep 5

pushd app
pushd migrations
echo -e "\n>>> STARTING SEED SCRIPT\n"
tfatoken=`python3 seed.py foo@bar.com baz 0xC855bC7519f627117c9e97B6EAFea5a30F294f72 | tail -n 1 | cut -b 3- | tr "'" " " | sed -e 's/ //'`
if [ "$?" -gt 0 ]; then
	>&2 echo seed script failed
	popd
	popd
	exit 1
fi
#echo -e "\n>>> STARTING DEV DATA SCRIPT\n"
#python3 dev_data.py
#if [ "$?" -gt 0 ]; then
#	>&2 echo dev data script failed
#	popd
#	popd
#	exit 1
#fi
popd


# run the actual app for the setup

#python3 run.py &
#pid_app=$!
#popd
#sleep 5

#python3 quick_setup_script.py $tfatoken 

echo -e "\n>>> KILL CELERY ($pid_celery)\n"
kill -TERM $pid_celery
rm -f $d_run/celery.pid
#echo -e "\n>>> KILL APP ($pid_ganache)\n"
#kill -TERM $pid_app
echo -e "\n>>> KILL GANACHE ($pid_ganache)\n"
kill -TERM $pid_ganache
rm -f $d_run/ganache.pid


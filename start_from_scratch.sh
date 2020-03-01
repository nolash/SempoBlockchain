#!/bin/bash

# Author: Louis Holbrook <dev@holbrook.no> https://holbrook.no
# License: GPLv3
#
# this script creates a 100% clean deployment of the sarafu platform
# for use in development
# it is not yet done and may not exit cleanly

if [ "$1" != 'REALLY' ]; then
	>&2 echo arg 1 must be "REALLY"
	exit
fi

d=`realpath $(dirname ${BASH_SOURCE[0]})`

# prerequisites

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

. quick_env.sh

# prepare the blockchainy part

# fire up ganache

ganache_bin=`which ganache-cli`
#$ganache_bin -i 42 -l 800000000 -g 2000000000 --debug -v -s 666 -p 7545 --acctKeys $d/run/accounts 2> $d/log/ganache.log &
$ganache_bin -i 42 -l 800000000 -g 2000000000 -s 666 -p 7545 --acctKeys $d/run/accounts 2> $d/log/ganache.log &
pid_ganache=$!

sleep 3

bancor_dir=${BANCOR_DIR:-$2}
pushd $bancor_dir
if [ ! -d "node_modules" ]; then
	npm install
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

rm -rf $d/config_files/secret
mkdir -vp $d/config_files/secret
pushd config_files
python3 generate_dev_secrets.py
popd

# purge old database
# and reinstall schema

dropdb -U postgres sarafu
dropdb -U postgres sarafu_eth
createdb -U postgres sarafu
createdb -U postgres sarafu_eth
psql -U postgres -d sarafu -f schema/sarafu_schema.sql
psql -U postgres -d sarafu_eth -f schema/sarafu_eth_schema.sql

# start the celery task manager
# this is needed for seeing the bootstrap data

export PYTHONPATH=$d/eth_worker/eth_manager:$d/eth_worker:$d/eth_worker/eth_manager/task_interfaces
echo -e "\n>>> STARTING CELERY\n"
celery -E -A celery_tasks worker &
pid_celery=$!
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

echo "\n>>> KILL CELERY ($pid_celery)\n"
kill -TERM $pid_celery
sleep 3

python3 run.py &
pid_app=$!
popd
sleep 5

python3 quick_setup_script.py $tfatoken 

echo -e "\n>>> KILL APP ($pid_ganache)\n"
kill -TERM $pid_app
echo -e "\n>>> KILL GANACHE ($pid_ganache)\n"
kill -TERM $pid_ganache


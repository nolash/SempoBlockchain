#!/bin/bash

d=`realpath $(dirname ${BASH_SOURCE[0]})`
d_log=$d/var/log/sarafu
d_lib=$d/var/lib/sarafu
d_run=$d/var/run/sarafu

for p in `find $d_run -iname '*.pid'`; do
	pp=`cat $p`
	echo "killing pid $pp"
	kill -TERM $pp
done

pushd $d

# is this necessary now?
#. quick_env.sh

ganache_bin=`which ganache-cli`
$ganache_bin -i 42 -l 800000000 -g 2000000000 -s 666 -p 7545 --acctKeys $d_lib/ganache.accounts --db $d_lib/ganache.db 2> $d_log/ganache.log &
pid_ganache=$!
echo -n $pid_ganache > $d_run/ganache.pid
echo "waiting 3 secs for ganache to start (pid $pid_ganache)..."
sleep 3

export PYTHONPATH=$d/eth_worker/eth_manager:$d/eth_worker:$d/eth_worker/eth_manager/task_interfaces
echo -e "\n>>> STARTING CELERY\n"
celery -E -A celery_tasks worker &
pid_celery=$!
echo -n $pid_celery > $d_run/celery.pid
echo "waiting 5 secs for ganache to start (pid $pid_celery)..."
sleep 5

pushd app
python3 run.py 
popd

echo -e "\n>>> KILL CELERY ($pid_celery)\n"
kill -TERM $pid_celery
rm $d_run/celery.pid

echo -e "\n>>> KILL GANACHE ($pid_ganache)\n"
kill -TERM $pid_ganache
rm $d_run/ganache.pid

popd

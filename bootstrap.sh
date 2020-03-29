#!/bin/bash

# Author: Louis Holbrook <dev@holbrook.no> https://holbrook.no
# License: GPLv3
# Description: Sets up virtualenv with the correct python interpreter and installs module dependencies for python and node
# 
# the dependencies in Debians are quirky; libmysqlclient-dev (mysql_config) and npm (node) are in conflict.
# to work around it use nvm to install node
which node
if [ $? -ne 0 ]; then
	2>&1 echo "node missing" && exit 1
fi

which npm
if [ $? -ne 0 ]; then
	2>&1 echo "npm missing" && exit 1
fi

# double check why mysql actually is needed here
which mysql_config
if [ $? -ne 0 ]; then
	2>&1 echo "mysql_config missing, install libmysqlclient" && exit 1
fi

wd=$(realpath $(dirname $0))
#confd=$wd/config_files # config_files now in repo, not necessary to create it
pushd $wd

# check whether python 3.6 is the system python
# breaks if 3.6 is among multiple 3.x systems are installed, and python3 does not point to 3.6
pyver='3.6'
py=''
pyconfd=''
pylibd="/usr/lib/python${pyver}"
if [ -d $pylibd ]; then
	pyconfd=$(find /usr/lib/python${pyver} -maxdepth 1 -type d  -name "config*" | head -n1)
	if [ -d $pyconfd ]; then
		py=$(which python3)
	fi
fi

# create temporary build dir
tmpd=$wd/.tmp
mkdir -vp $tmpd
pushd $tmpd

# if python is not in the path
# download it along with virtualenv and build
if [ -z "$py" ]; then
	pythonurl='https://www.python.org/ftp/python/3.6.10/Python-3.6.10.tgz'
	sigurl='https://www.python.org/ftp/python/3.6.10/Python-3.6.10.tgz.asc'
	pythonmd5='df5f494ef9fbb03a0264d1e9d406aada'
	pythonkey='0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D'
	pythonfile=$(basename $pythonurl)

	if [ ! -e "$pythonfile" ]; then
		curl -o $pythonfile $pythonurl 
	fi
	sigfile=$(basename $sigurl)
	if [ ! -e "$sigfile" ]; then
		curl -o $sigfile $sigurl 
	fi

	pythonmd5_actual=$(md5sum "$pythonfile" | awk '{ print $1; }')

	if [ "$pythonmd5" != "$pythonmd5_actual" ]; then
	       2>&1 echo "python targz md5 mismatch"
	       exit 1
	fi
	gpg --recv-keys $pythonkey #2> /dev/null
	gpg --verify $sigfile #2> /dev/null
	if [ $? -ne 0 ]; then
	      	2>&1 echo "python targz sig mismatch"
		exit 1
	fi

	tar -zxvf $pythonfile
	pushd 'Python-3.6.10'
	./configure --prefix=/usr
	make
	make install DESTDIR=$(pwd)/..
	popd
	py="$tmpd/usr/bin/python3.6"
	pyconfd="$tmpd/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu"
	export PYTHONPATH="$tmpd/usr/lib/python3.6/site-packages/setuptools"
fi

# if system python lacks wheel or venv then fail
# by checking here we catch faulty new build of 3.6
$($py -m wheel version &> /dev/null)
#if [ $? -ne 0 ]; then
#	echo "wheel not found" && exit 1
#fi
#$($py -m venv -h &> /dev/null)
if [ $? -ne 0 ]; then
	echo "virtualenv not found" && exit 1
fi

popd

# create the virtualenv
$py -m venv venv
if [ "$?" -gt "0" ]; then
	>&2 echo "venv fail"
	exit 1
fi

# remove the build dir
rm -rf $tmpd

# install missing config-3.6m files that virtualenv doesn't put in
pyconfdv="config-${pyver}m"
mkdir -vp venv/lib/python${pyver}/${pyconfdv}
install -vD $pyconfd/* venv/lib/python${pyver}/${pyconfdv}/

# turn on virtualenv
source venv/bin/activate
if [ "$?" -gt "0" ]; then
	>&2 echo "venv fail"
	exit 1
fi

# recursive install dependencies for python
pip install wheel
bash install.sh
pushd app

# install dependencies for node
npm install
npm run-script build

# finish up
popd
deactivate

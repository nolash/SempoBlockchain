#!/bin/bash

d=$(realpath $(dirname ${BASH_SOURCE[0]}))
export PYTHONPATH=$PYTHONPATH:$d/app
export DEPLOYMENT_NAME=local
export LOCAL_EMAIL=foo@sechost.info
export LOCAL_PASSWORD=trala-la
export DATABASE_USER=postgres
export DATABASE_PASSWORD=



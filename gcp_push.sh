#!/bin/bash

set -e

IPADDRESS=$1

if [[ x${IPADDRESS} == x ]]; then {
    echo Usage: $0 [ip address or hostname]
    exit -1
} fi

set -x

LOCALHOME=${HOME}
REMOTEUSER=$(ps -e | grep ${IPADDRESS} | grep -v grep | awk '{print $5;}' | cut -d @ -f 1)

if [[ x${REMOTEUSER} == x ]]; then {
    echo You must be connected with ssh to the host when running this, so we can find the username
    exit -1
} fi

LOCALFOLDER=$PWD
REMOTEFOLDER=${PWD/${LOCALHOME}/\~/}

echo REMOTEFOLDER ${REMOTEFOLDER} REMOTEUSER ${REMOTEUSER}

git diff > gitdiff.txt
git log -n 3 > gitlog.txt

rsync \
    --exclude '*.pt' \
    --exclude '__pycache__' \
    --exclude 'logs' \
    --exclude '.cache.txt' \
    --exclude 'pull' \
    --exclude '*.ipynb' \
    --exclude '.DS_Store' \
    --exclude '_vizdoom.ini' \
    --exclude '*.lmp' \
    --exclude '*.png' \
    --exclude '*.gz' \
    --exclude '.git' \
    --exclude '*.whl' \
    --exclude 'recordings/' \
    --exclude '.pytest_cache/' \
    --exclude '.python-version' \
    --exclude 'dist/' \
    -av \
    ${PWD}/ ${REMOTEUSER}@${IPADDRESS}:${REMOTEFOLDER}/

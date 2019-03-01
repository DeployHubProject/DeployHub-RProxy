#!/bin/sh
set -x
id

if [ ! -e /root/.ssh ]; then
 mkdir /root/.ssh
fi

if [ ! -e /opt/deployhub/engine/log ]; then
 mkdir /opt/deployhub/engine/log
fi

cd /opt/deployhub/engine

export DMHOME=$PWD
export TRILOGYHOME=$PWD
export LD_LIBRARY_PATH=$PWD/lib:$PWD/bin
export PATH=$PWD/lib:$PWD/bin:$PATH
export WEBSERVER=https://console.deployhub.com
export HOME=$(getent passwd `whoami` | cut -d: -f6)
export DM_TARGET_USER=root
cp -r /keys/* $HOME/.ssh
chown -R `whoami` $HOME/.ssh 
chmod -R 600 $HOME/.ssh

echo Running DeployHub Reverse Proxy 

curl -k -sL "$WEBSERVER/dmadminweb/EngineEvent?getkeys=Y&clientid=$CLIENTID" | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["dmodbc"])' > /opt/deployhub/engine/dm.odbc
curl -k -sL "$WEBSERVER/dmadminweb/EngineEvent?getkeys=Y&clientid=$CLIENTID" | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["dmasc"])' > /opt/deployhub/engine/dm.asc
python3 /opt/deployhub/engine/lib/dhlistener.py $WEBSERVER $CLIENTID $PWD 

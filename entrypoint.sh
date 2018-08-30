#!/bin/sh
set -x
id

if [ ! -e /opt/deployhub/engine/logs ]; then
 mkdir /opt/deployhub/engine/logs
fi

cd /opt/deployhub/engine

export DMHOME=$PWD
export LD_LIBRARY_PATH=$PWD/lib:$PWD/bin
export PATH=$PWD/lib:$PWD/bin:$PATH
export WEBSERVER=https://console.deployhub.com
export HOME=$(getent passwd `whoami` | cut -d: -f6)
cp -r /keys/* $HOME/.ssh
chown -R omreleng $HOME/.ssh 

echo Running DeployHub Reverse Proxy 

curl -sL "$WEBSERVER/dmadminweb/EngineEvent?getkeys=Y&clientid=$CLIENTID" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["dmodbc"]' > /opt/deployhub/engine/dm.odbc
curl -sL "$WEBSERVER/dmadminweb/EngineEvent?getkeys=Y&clientid=$CLIENTID" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["dmasc"]' > /opt/deployhub/engine/dm.asc
python /opt/deployhub/engine/lib/dhlistener.py $WEBSERVER $CLIENTID $PWD 

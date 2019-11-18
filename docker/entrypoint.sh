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
export DM_TARGET_USER=root
export HOME=$(getent passwd `whoami` | cut -d: -f6)

sudo cp -r /keys/* /root/.ssh
sudo chown -R root /root/.ssh
sudo chmod 755 /root/.ssh
sudo chmod 600 /root/.ssh/known*

echo Running DeployHub Reverse Proxy 

curl -k -sL "$WEBSERVER/dmadminweb/EngineEvent?getkeys=Y&clientid=$CLIENTID" | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["dmodbc"])' > /opt/deployhub/engine/dm.odbc
curl -k -sL "$WEBSERVER/dmadminweb/EngineEvent?getkeys=Y&clientid=$CLIENTID" | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["dmasc"])' > /opt/deployhub/engine/dm.asc
python3 /opt/deployhub/engine/lib/dhlistener.py $WEBSERVER $CLIENTID $PWD $DBSERVER $DBPORT 

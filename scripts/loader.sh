#!/bin/sh
# include deploy_artifact function
. deploy_artifact.sh

env=$1
#check snap is available in centos . if not install 
#check yq is available in centos . if not install 
#for serverip in $(yq r ../config/server_config2.yaml servers.dev*.remoteip | tr -d \-)

declare i=0
for serverip in $(yq r ../config/dev/server_config.yaml servers[*].remoteip | tr -d \-)
do
  if [ $(yq r ../config/dev/server_config.yaml servers[$i].status | tr -d \-) == "NEW" ] 
  then
    ping -c 1 $serverip
    if [ $? -eq 0 ]; then
      deploy_artifact $env $serverip
      $(yq w -i ../config/dev/server_config.yaml servers[$i].status "DONE")
    fi 
  fi
  let "i+=1" 
done

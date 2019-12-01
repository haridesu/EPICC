#!/bin/sh

deploy_artifact() {

local env=$1
echo $env
local serverip=$2
local remoteid=$(yq r ../config/$env/env_constants.yaml env_const.remoteid)
local remoterootdir=$(yq r ../config/$env/env_constants.yaml env_const.remoterootdir)
local remotedir=$(yq r ../config/$env/env_constants.yaml env_const.remotedir)
local filename=$(yq r ../config/$env/env_constants.yaml env_const.filename)
local key=$(yq r ../config/$env/env_constants.yaml env_const.key)
local giturl=$(yq r ../config/$env/env_constants.yaml env_const.giturl)

#Step1 : Connect to remote server 
ssh -i  $key  $remoteid@$serverip -T << EOSSH
#Step2: Check the remote directory exists . if not create
[ ! -d $remoterootdir$remotedir ] && cd $remoterootdir && mkdir -p $remotedir
#Step3 : Download kafka from github
wget -O $remoterootdir$remotedir$filename $giturl 
#Step4 : unpack 
tar -xvzf $remoterootdir$remotedir$filename -C $remoterootdir$remotedir
#Step5 : delete the tar file
rm $remoterootdir$remotedir$filename
ls -l $remoterootdir$remotedir
#Step6 : Disconnect from remote server
EOSSH

}

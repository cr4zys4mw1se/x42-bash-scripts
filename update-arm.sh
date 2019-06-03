#!/bin/bash

if [ ! -d "X42-FullNode" ]; then
    git clone https://github.com/x42protocol/X42-FullNode.git
    cd X42-FullNode/src
    dotnet restore
    dotnet publish --configuration Release
    mv -f ~/X42-FullNode/src/x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node/
    cd
    ssh USERNAME@xxx.xxx.xxx.xxx 'sudo systemctl stop x42node.service; rm -rf x42node'
    rsync -ahP ~/x42node USERNAME@xxx.xxx.xxx.xxx:/home/USERNAME
    ssh USERNAME@xxx.xxx.xxx.xxx 'sudo systemctl start x42node.service'
elif [ -d "X42-FullNode" ]; then
    cd X42-FullNode
    git pull origin master
    cd src
    dotnet restore
    dotnet publish --configuration Release
    mv -f ~/X42-FullNode/src/x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node/
    cd
    ssh USERNAME@xxx.xxx.xxx.xxx 'sudo systemctl stop x42node.service; rm -rf x42node'
    rsync -ahP ~/x42node USERNAME@xxx.xxx.xxx.xxx:/home/USERNAME
    ssh USERNAME@xxx.xxx.xxx.xxx 'sudo systemctl start x42node.service'
fi

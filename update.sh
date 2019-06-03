#!/bin/bash

if [ ! -d "X42-FullNode" ]; then
    git clone https://github.com/x42protocol/X42-FullNode.git
    sudo systemctl stop x42node.service
    cd X42-FullNode/src
    dotnet restore
    dotnet build --configuration Release
    mv -f ~/X42-FullNode/src/x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node/
    sudo systemctl start x42node.service
    cd
elif [ -d "X42-FullNode" ]; then
    sudo systemctl stop x42node.service
    cd X42-FullNode
    git pull origin master
    cd src
    dotnet restore
    dotnet build --configuration Release
    mv -f ~/X42-FullNode/src/x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node/
    sudo systemctl start x42node.service
    cd
fi

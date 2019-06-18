#!/bin/bash
#
# Created by: cr4zys4mw1se
#
# Donation Addresses:
# x42: XKCm56Q4GmxRYbk3aS8seAQaHdtUDpgEfx
# BTC: 145QLo9jopWK3Z7h43fEgTy7AbUA239Ghz
# LTC: LVkLucNkv43Zwpqx1Vb1mymnQR2YLPXzZR
#

printf "\nChecking if the X42-FullNode folder is available...\n\n"
notAvail=0
if [ ! -d "/home/$USER/X42-FullNode" ]; then
    ((notAvail+=20))
    printf "Folder not found, downloading from GitHub...\n\n"
    git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
    printf "\nBuilding FullNode...\n\n"
    cd ~/X42-FullNode/src
    dotnet restore
    dotnet publish --configuration Release
    if [ ! -d "/home/$USER/x42node" ]; then
        ((notAvail+=22))
        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
    else
        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
    fi
    printf "\nPlease provide the following information for your ARM device.\n\n"
    read -p "Username: " username
    read -p "IP Address: " armIP
    printf "\nStopping service and removing x42node folder from ARM device.\n\n"
    ssh $username@$armIP 'sudo systemctl stop x42node.service; rm -rf ~/x42node'
    printf "\nCopying updated x42node folder to ARM device.\n\n"
    rsync -ahP ~/x42node $username@$armIP:/home/$username
    printf "\nStarting x42node.service\n\n"
    ssh $username@$armIP 'sudo systemctl start x42node.service'
    printf "\nVerifying x42node.service is active...\n\n"
    if [ "$(ssh $username@$armIP 'systemctl is-active x42node.service')" == "active" ]; then
        printf "\nx42node.service started successfully.\n\n"
    else
        printf "\nx42node.service may have not started successfully.\n\nTry connecting to the ARM device and check the status, use: sudo systemctl status x42node.service\n\n"
    fi
    if [ "$notAvail" == "20" ]; then
        rm -rf ~/X42-FullNode
    elif [ "$notAvail" == "22" ]; then
        rm -rf ~/x42node
    elif [ "$notAvail" == "42" ]; then
        rm -rf ~/X42-FullNode
        rm -rf ~/x42node
    fi
    printf "\nExiting.\n\n"
else
    printf "X42-FullNode folder found. Updating now...\n\n"
    cd ~/X42-FullNode
    git pull origin master
    printf "\nBuilding FullNode...\n\n"
    cd src
    dotnet restore
    dotnet publish --configuration Release
    if [ ! -d "/home/$USER/x42node" ]; then
        ((notAvail+=42))
        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
    else
        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
    fi
    printf "\nPlease provide the following information for your ARM device.\n\n"
    read -p "Username: " username
    read -p "IP Address: " armIP
    printf"\nStopping service and removing x42node folder from ARM device.\n\n"
    ssh $username@$armIP 'sudo systemctl stop x42node.service; rm -rf ~/x42node'
    printf "\nCopying updated x42node folder to ARM device.\n\n"
    rsync -ahP ~/x42node $username@$armIP:/home/$username
    printf "\nStarting x42node.service\n\n"
    ssh $username@$armIP 'sudo systemctl start x42node.service'
    printf "\nVerifying x42node.service is active...\n\n"
    if [ "$(ssh $username@$armIP 'systemctl is-active x42node.service')" == "active" ]; then
        printf "\nx42node.service started successfully.\n\n"
    else
        printf "\nx42node.service may have not started successfully.\n\nTry connecting to the ARM device and check the status, use: sudo systemctl status x42node.service\n\n"
    fi
    if [ "$notAvail" == "42" ]; then
        rm -rf ~/x42node
    fi
    printf "\nExiting.\n\n"
fi

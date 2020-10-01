# Created by: cr4zys4mw1se
#
# Donation Addresses:
# x42: XKCm56Q4GmxRYbk3aS8seAQaHdtUDpgEfx
# BTC: 145QLo9jopWK3Z7h43fEgTy7AbUA239Ghz
# LTC: LVkLucNkv43Zwpqx1Vb1mymnQR2YLPXzZR
#
############################################################
# License: GNU GPLv3
#    x42 Bash Scripts - Install or update your X42-FullNode
#    Copyright (C) 2019  cr4zys4mw1se
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
############################################################

#!/usr/bin/env bash

printf "\nChecking if the X42-FullNode folder is available...\n\n"
if [ ! -d "/home/$USER/X42-FullNode" ]; then
    printf "Folder not found, downloading from GitHub...\n\n"
    git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
    printf "\nStopping x42node.service\n\n"
    sudo systemctl stop x42node.service
    printf "\nBuilding FullNode\n\n"
    cd ~/X42-FullNode/src
    dotnet restore
    dotnet build --configuration Release
    if [ ! -d "/home/$USER/x42node" ]; then
        mkdir ~/x42node
        mv x42.x42D/bin/Release/netcoreapp3.1 ~/x42node
    else
        mv -f x42.x42D/bin/Release/netcoreapp3.1 ~/x42node
    fi
    printf "\nStarting x42node.service\n\n"
    sudo systemctl start x42node.service
    sleep 1.25
    if [ "$(systemctl is-active x42node.service)" == "active" ]; then
        printf "\nFinished.\n\nYou may now check your node using: curl http://127.0.0.1:42220/api/Dashboard/Stats\n\n"
    else
        printf "\nThere may be an error with the Node.\n\nCheck the Node status with: sudo systemctl status x42node.service\n\n"
    fi
else
    printf "X42-FullNode folder found, stopping x42node.service\n\n"
    sudo systemctl stop x42node.service
    printf "\nUpdating from GitHub...\n\n"
    cd ~/X42-FullNode
    git pull origin master
    printf "\nBuilding FullNode...\n\n"
    cd src
    dotnet restore
    dotnet build --configuration Release
    if [ ! -d "/home/$USER/x42node" ]; then
        mkdir ~/x42node
        mv x42.x42D/bin/Release/netcoreapp3.1 ~/x42node
    else
        mv -f x42.x42D/bin/Release/netcoreapp3.1 ~/x42node
    fi
    printf "\nStarting x42node.service\n\n"
    sudo systemctl start x42node.service
    sleep 1.25
    if [ "$(systemctl is-active x42node.service)" == "active" ]; then
        printf "\nFinished.\n\nYou may now check your node using: curl http://127.0.0.1:42220/api/Dashboard/Stats\n\n"
    else
        printf "\nThere may be an error with the Node.\n\nCheck the Node status with: sudo systemctl status x42node.service\n\n"
    fi
fi

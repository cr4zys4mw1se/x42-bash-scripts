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

printf "\nChecking Linux version and if dotnet is installed...\n\n"
if [ -x "$(command -v apt -v)" ]; then
    osR="$(lsb_release -r -s)"
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        if [ $osR == "16.04" ]; then
            printf "Using Ubuntu $osR.\n\ndotnet is not installed.\n\nInstalling now..\n\n"
            cd /tmp
            wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            sudo apt -y install apt-transport-https
            sudo apt update
            sudo apt -y install dotnet-sdk-2.2
        elif [ $osR == "18.04" -o $osR == "18.10" ]; then
            printf "Using Ubuntu $osR.\n\ndotnet is not installed.\n\nInstalling now..\n\n"
            cd /tmp
            wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            sudo add-apt-repository universe
            sudo apt -y install apt-transport-https
            sudo apt update
            sudo apt -y install dotnet-sdk-2.2
        elif [ $osR == "19.04" ]; then
            printf "Using Ubuntu $osR.\n\ndotnet is not installed.\n\nInstalling now..\n\n"
            cd /tmp
            wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            sudo apt -y install apt-transport-https
            sudo apt update
            sudo apt -y install dotnet-sdk-2.2
            if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                printf "\nThere may have been an error while installing. Attempting alternative method...\n\n"
                cd /tmp
                sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
                sudo apt update
                sudo apt -y install dotnet-sdk-2.2
                if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                    printf "\nThere may have been another error while installing dotnet.\n\nAttempting final alternative installation method provided by Microsoft...\n\n"
                    cd /tmp
                    sudo apt -y install gpg
                    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                    sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                    wget -q https://packages.microsoft.com/config/ubuntu/19.04/prod.list
                    sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                    sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                    sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                    sudo apt -y install apt-transport-https
                    sudo apt update
                    sudo apt -y install dotnet-sdk-2.2
                    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                        printf "\nIt appears dotnet is not installing properly.\n\nPlease review: https://dotnet.microsoft.com/download/linux-package-manager/ubuntu19-04/sdk-current\n\nPlease attempt installing dotnet manually using the information provided. Verify installation with 'dotnet --list-sdks' before running this script again.\n\nExiting.\n\n"
                        exit 1
                    fi
                fi
            fi
        else
            printf "You may not be on a correct Linux version.\n\nPlease try again later.\n\n"
            exit 1
        fi
    else
        printf "You're running a proper Ubuntu release ($osR) and dotnet is already installed.\n\n"
    fi
    if [ ! -d "/home/$USER/X42-FullNode" ]; then
        printf "\nChecking if Git is installed...\n\n"
        if [ ! -x "$(command -v git --version)" ]; then
            printf "Git not installed, installing now...\n\n"
            sudo apt -y install git
        else
            printf "Git already installed.\n\n"
        fi
        printf "Downloading X42-FullNode.\n\n"
        git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
        printf "\nBuilding FullNode...\n\n"
        cd ~/X42-FullNode/src
        dotnet restore
        dotnet build --configuration Release
        mkdir ~/x42node
        mv x42.x42D/bin/Release/netcoreapp2.1 ~/x42node
    else
        printf "X42-FullNode found, checking for updates before building...\n\n"
        cd ~/X42-FullNode
        git pull origin master
        printf "\nBuilding FullNode...\n\n"
        cd src
        dotnet restore
        dotnet build --configuration Release
        if [ ! -d "/home/$USER/x42node" ]; then
            mkdir ~/x42node
            mv x42.x42D/bin/Release/netcoreapp2.1 ~/x42node
        else
            mv -f x42.x42D/bin/Release/netcoreapp2.1 ~/x42node
        fi
    fi
    if [ ! -e "/etc/systemd/system/x42node.service" ]; then
        printf "\nSetting up startup service.\n\n"
        cat <<EOF > ~/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$USER/x42node
ExecStart=/usr/bin/dotnet /home/$USER/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$USER
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
        sudo mv ~/x42node.service /etc/systemd/system/x42node.service
        printf "\nStarting x42node.service\n\n"
        sudo systemctl start x42node.service
        printf "Verifying service started\n\n"
        sleep 1.25
        if [ "$(systemctl is-active x42node.service)" == "active" ]; then
            printf "Started successfully. Enabling at startup...\n\n"
            sudo systemctl enable x42node.service
        else
            printf "\nThere may be an error with starting the service.\n\nCheck the status using: sudo systemctl status x42node.service\n\n"
            exit 1
        fi
        printf "\nThe x42-FullNode is now installed and running.\n\nTo stop use: sudo systemctl stop x42node.service\nCheck status use: sudo systemctl status x42node.service\nTo disable from startup: sudo systemctl disable x42node.service\n\nYou can check your Node by using: curl http://127.0.0.1:42220/api/Dashboard/Stats\n\nYou can access the Node API at: http://127.0.0.1:42220/swagger/index.html\n\n"
    fi
fi

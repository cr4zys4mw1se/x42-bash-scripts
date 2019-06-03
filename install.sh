#!/bin/bash

if ! [ -x "$(command -v dotnet --list-sdks)" ]; then
    cd /tmp
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo add-apt-repository universe
    sudo apt -y install apt-transport-https
    sudo apt update
    sudo apt -y install dotnet-sdk-2.2
    cd
fi
if [ ! -d "X42-FullNode" ]; then
    git clone https://github.com/x42protocol/X42-FullNode.git
    cd X42-FullNode/src
    dotnet restore
    dotnet build --configuration Release
    cd
    mkdir ~/x42node
    mv ~/X42-FullNode/src/x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node/
fi
if [ ! -e "/etc/systemd/system/x42node.service" ]; then
    sudo -i
    cat <<EOF > /etc/systemd/system/x42node.service
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
    systemctl start x42node.service
    systemctl enable x42node.service
    exit
fi

#!/usr/bin/env bash

armSSH(){
    printf "\nWhat is the following information for your ARM device?\n\n"
    read -p "Username: " username
    read -p "IP Address: " ipAddr
}
mainMenu(){
    os="$(cat /etc/os-release | grep NAME -m 1 | tr -d 'NAME=""')"
    osR="$(cat /etc/os-release | grep VERSION_ID | tr -d 'NAME=""')"
    printf "\n     X42-FullNode Install/Update     \n\nWhat would you like to do?\n\n"
    mainMenu=("Fresh Install" "Update" "Fresh Install ARM" "Update ARM" "Quit")
    select opt in "${mainMenu[@]}"
    do
        case $opt in
            "Fresh Install")
                instMenu(){
                    printf "\n     X42-FullNode Fresh Installation     \n\nWhat would you like to do?\n\n"
                    instMenu=("All-in-One Install" "Install .NET SDK Only" "Download and Build X42-FullNode Only" "Setup x42node.service Only" "Go Back")
                    select opt in "${instMenu[@]}"
                    do
                        case $opt in
                            "All-in-One Install")
                                printf "\nVerifying .NET SDK is installed.\n\n"
                                if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                                    if [ "$os" == "Debian" ]; then
                                        if [ "$osR" == "9" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            cd /tmp
                                            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                                            sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                                            wget -q https://packages.microsoft.com/config/debian/9/prod.list
                                            sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                                            sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                                            sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        else
                                            printf "\nUnfortunately you don't appear to be running a proper Debian release.\n\n"
                                            exit 1
                                        fi
                                    elif [ "$os" == "Ubuntu" ]; then
                                        if [ "$osR" == "16.04" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            cd /tmp
                                            wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
                                            sudo dpkg -i packages-microsoft-prod.deb
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "18.04" -o "$osR" == "18.10" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            cd /tmp
                                            wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
                                            sudo dpkg -i packages-microsoft-prod.deb
                                            sudo add-apt-repository universe
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "19.04" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
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
                                            printf "\nYou may not be running the proper Ubuntu release.\n\nPlease verify it's able to run this.\n\n"
                                            exit 1
                                        fi
                                    elif [ "$os" == "CentOS Linux" ]; then
                                        printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                        sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
                                        sudo yum -y update
                                        sudo yum -y install dotnet-sdk-2.2
                                    elif [ "$os" == "Fedora" ]; then
                                        if [ "$osR" == "27" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                            cd /tmp
                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                            sudo dnf -y update
                                            sudo dnf -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "28" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                            cd /tmp
                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                            sudo dnf -y update
                                            sudo dnf -y install dotnet-sdk-2.2
                                        else
                                            printf "\nYou may not be running the proper Fedora release.\n\nPlease verify it's able to run this.\n\n"
                                            exit 1
                                        fi
                                    else
                                        printf "\nYou may not be running a proper environment for this script.\n\nPlease verify before running again.\n\n"
                                        exit 1
                                    fi
                                else
                                    printf "\nUsing: $os $osR and .NET SDK is currently installed.\n\n"
                                fi
                                if [ ! -d "/home/$USER/X42-FullNode" ]; then
                                    printf "Checking if Git is installed...\n\n"
                                    if [ ! -x "$(command -v git --version)" ]; then
                                        printf "Git not installed, installing now...\n\n"
                                        if [ "$os" == "Debian" -o "$os" == "Ubuntu" ]; then
                                            sudo apt -y install git
                                        elif [ "$os" == "CentOS Linux" ]; then
                                            sudo yum -y install git
                                        elif [ "$os" == "Fedora" ]; then
                                            sudo dnf -y install git
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
                                        mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
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
                                            mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                        else
                                            mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                        fi
                                    fi
                                fi
                                if [ ! -e "/etc/systemd/system/x42node.service" ]; then
                                    printf "\nSetting up startup service.\n\n"
                                    if [ "$os" == "Fedora" ]; then
                                        sudo touch /etc/systemd/system/x42node.service
                                        sudo -s <<SERVICE
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
SERVICE
                                        sudo systemctl daemon-reload
                                    else
                                        sudo mv ~/x42node.service /etc/systemd/system/x42node.service
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
                                    fi
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
                                    printf "\nThe x42-FullNode is now installed and running.\n\nTo stop use: sudo systemctl stop x42node.service\nCheck status use: sudo systemctl status x42node.service\nTo disable from startup: sudo systemctl disable x42node.service\n\nYou can check your Node by using: curl http://127.0.0.1:42220/api/Dashboard/Stats\n\nYou can access the Node API at: http://127.0.0.1:42220/swagger/index.html\n\nReturning to Main Menu in 15s...\n"
                                fi
                                sleep 15
                                clear
                                mainMenu
                                ;;
                            "Install .NET SDK Only")
                                printf "\nVerifying .NET SDK is installed.\n\n"
                                if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                                    if [ "$os" == "Debian" ]; then
                                        if [ "$osR" == "9" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            cd /tmp
                                            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                                            sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                                            wget -q https://packages.microsoft.com/config/debian/9/prod.list
                                            sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                                            sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                                            sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        else
                                            printf "\nUnfortunately you don't appear to be running a proper Debian release.\n\n"
                                            exit 1
                                        fi
                                    elif [ "$os" == "Ubuntu" ]; then
                                        if [ "$osR" == "16.04" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            cd /tmp
                                            wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
                                            sudo dpkg -i packages-microsoft-prod.deb
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "18.04" -o "$osR" == "18.10" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            cd /tmp
                                            wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
                                            sudo dpkg -i packages-microsoft-prod.deb
                                            sudo add-apt-repository universe
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "19.04" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
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
                                            printf "\nYou may not be running the proper Ubuntu release.\n\nPlease verify it's able to run this.\n\n"
                                            exit 1
                                        fi
                                    elif [ "$os" == "CentOS Linux" ]; then
                                        printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                        sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
                                        sudo yum -y update
                                        sudo yum -y install dotnet-sdk-2.2
                                    elif [ "$os" == "Fedora" ]; then
                                        if [ "$osR" == "27" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                            cd /tmp
                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                            sudo dnf -y update
                                            sudo dnf -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "28" ]; then
                                            printf "\nUsing: $os $osR\n\n.NET SDK not installed\n\nInstalling now...\n\n"
                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                            cd /tmp
                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                            sudo dnf -y update
                                            sudo dnf -y install dotnet-sdk-2.2
                                        else
                                            printf "\nYou may not be running the proper Fedora release.\n\nPlease verify it's able to run this.\n\n"
                                            exit 1
                                        fi
                                    else
                                        printf "\nYou may not be running a proper environment for this script.\n\nPlease verify before running again.\n\n"
                                        exit 1
                                    fi
                                else
                                    printf "\nUsing: $os $osR and .NET SDK is currently installed.\n\n"
                                fi
                                printf "\nVerifying .NET SDK installed successfully...\n\n"
                                if [ -x "$(command -v dotnet --list-sdks)" ]; then
                                    printf ".NET installed successfully.\n\nReturning to the prior Menu in 5s...\n\n"
                                    sleep 5
                                else
                                    printf ".NET may not have installed properly.\n\nYou can verify with 'dotnet --list-sdks'.\n\nExiting...\n\n"
                                    exit 1
                                fi
                                clear
                                instMenu
                                ;;
                            "Download and Build X42-FullNode Only")
                                printf "\nChecking if ~/X42-FullNode is available...\n\n"
                                if [ ! -d "/home/$USER/X42-FullNode" ]; then
                                    printf "\nChecking if Git is installed...\n\n"
                                    if [ ! -x "$(command -v git --version)" ]; then
                                        printf "Git not installed, installing now...\n\n"
                                        if [ "$os" == "Debian" -o "$os" == "Ubuntu" ]; then
                                            sudo apt -y install git
                                        elif [ "$os" == "CentOS Linux" ]; then
                                            sudo yum -y install git
                                        elif [ "$os" == "Fedora" ]; then
                                            sudo dnf -y install git
                                        else
                                            printf "Git already installed.\n\n"
                                        fi
                                        printf "Downloading X42-FullNode.\n\n"
                                        git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
                                        printf "\nBuilding FullNode...\n\n"
                                        cd ~/X42-FullNode/src
                                        dotnet restore
                                        dotnet build --configuration Release
                                        if [ ! -d "/home/$USER/x42node" ]; then
                                            mkdir ~/x42node
                                            mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                        else
                                            mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                        fi
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
                                            mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                        else
                                            mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                        fi
                                    fi
                                fi
                                printf "\nThe X42-FullNode is now accessible in ~/x42node\n\nReturning to prior Menu in 5s...\n\n"
                                sleep 5
                                clear
                                instMenu
                                ;;
                            "Setup x42node.service Only")
                                if [ ! -e "/etc/systemd/system/x42node.service" ]; then
                                    printf "\nSetting up startup service.\n\n(Will Not Start/Stop Existing Service IF One Exists)"
                                    if [ "$os" == "Fedora" ]; then
                                        sudo touch /etc/systemd/system/x42node.service
                                        sudo -s <<SUDO
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
SUDO
                                        sudo systemctl daemon-reload
                                        if [ -e "/etc/systemd/system/x42node.service" ]; then
                                            printf "\nFinished setup of: x42node.service.\n\nReturning to prior Menu in 5s...\n\n"
                                        else
                                            printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
                                            exit 1
                                        fi
                                    else
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
                                        if [ -e "/etc/systemd/system/x42node.service" ]; then
                                            printf "\nFinished setup of: x42node.service.\n\nReturning to prior Menu in 5s...\n\n"
                                        else
                                            printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
                                            exit 1
                                        fi
                                    fi
                                fi
                                sleep 5
                                clear
                                instMenu
                                ;;
                            "Go Back")
                                clear
                                mainMenu
                                ;;
                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                        esac
                    done
                }
                clear
                instMenu
                ;;
            "Update")
                updMenu(){
                    printf "\n     X42-FullNode Update     \n\nWhat would you like to do?\n\n"
                    updMenu=("All-in-One Updater" "Update and Build FullNode Only (does NOT touch x42node.service)" "Go Back")
                    select opt in "${updMenu[@]}"
                    do
                        case $opt in
                            "All-in-One Updater")
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
                                        mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    fi
                                    printf "\nStarting x42node.service\n\n"
                                    sudo systemctl start x42node.service
                                    sleep 1.25
                                    if [ "$(systemctl is-active x42node.service)" == "active" ]; then
                                        printf "\nFinished.\n\nYou may now check your node using: curl http://127.0.0.1:42220/api/Dashboard/Stats\n\n"
                                    else
                                        printf "\nThere may be an error with the Node.\n\nCheck the Node status with: sudo systemctl status x42node.service\n\nExiting...\n\n"
                                        exit 1
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
                                        mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    fi
                                    printf "\nStarting x42node.service\n\n"
                                    sudo systemctl start x42node.service
                                    sleep 1.25
                                    if [ "$(systemctl is-active x42node.service)" == "active" ]; then
                                        printf "\nFinished.\n\nYou may now check your node using: curl http://127.0.0.1:42220/api/Dashboard/Stats\n\n"
                                    else
                                        printf "\nThere may be an error with the Node.\n\nCheck the Node status with: sudo systemctl status x42node.service\n\nExiting...\n\n"
                                        exit 1
                                    fi
                                fi
                                printf "Returning to prior Menu in 5s...\n\n"
                                clear
                                updMenu
                                ;;
                            "Update and Build FullNode Only (does NOT touch x42node.service)")
                                printf "\nChecking if the X42-FullNode folder is available...\n\n"
                                if [ ! -d "/home/$USER/X42-FullNode" ]; then
                                    printf "Folder not found, downloading from GitHub...\n\n"
                                    git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
                                    printf "\nBuilding FullNode\n\n"
                                    cd ~/X42-FullNode/src
                                    dotnet restore
                                    dotnet build --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mkdir ~/x42node
                                        mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    fi
                                else
                                    printf "X42-FullNode folder found.\n\nUpdating from GitHub...\n\n"
                                    cd ~/X42-FullNode
                                    git pull origin master
                                    printf "\nBuilding FullNode...\n\n"
                                    cd src
                                    dotnet restore
                                    dotnet build --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mkdir ~/x42node
                                        mv x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/*.* ~/x42node
                                    fi
                                fi
                                printf "\nFinished updating X42-FullNode only.\n\nReturning to prior Menu in 5s...\n\n"
                                sleep 5
                                clear
                                updMenu
                                ;;
                            "Go Back")
                                clear
                                mainMenu
                                ;;
                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                        esac
                    done
                }
                clear
                updMenu
                ;;
            "Fresh Install ARM")
                clear
                armSSH
                instArm(){
                    printf "\n     X42-FullNode Fresh ARM device Installation     \n\nWhat would you like to do?\n\n"
                    instArmMenu=("All-in-One Install" "Install .NET Only" "Download and Build X42-FullNode Only" "Setup x42node.service Only" "Go Back")
                    select opt in "${instArmMenu[@]}"
                    do
                        case $opt in
                            "All-in-One Install")
                                if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                                    printf "\nInstalling .NET SDK, checking Linux release...\n"
                                    if [ "$os" == "Debian" ]; then
                                        if [ "$osR" == "9" ]; then
                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                            cd /tmp
                                            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                                            sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                                            wget -q https://packages.microsoft.com/config/debian/9/prod.list
                                            sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                                            sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                                            sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                                            sudo apt install apt-transport-https
                                            sudo apt update
                                            sudo apt install dotnet-sdk-2.2
                                        else
                                            printf "\nUnfortunately you don't appear to be running a proper Debian release.\n\n"
                                            exit 1
                                        fi
                                    elif [ "$os" == "Ubuntu" ]; then
                                        if [ "$osR" == "16.04" ]; then
                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                            cd /tmp
                                            wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
                                            sudo dpkg -i packages-microsoft-prod.deb
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "18.04" -o "$osR" == "18.10" ]; then
                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                            cd /tmp
                                            wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
                                            sudo dpkg -i packages-microsoft-prod.deb
                                            sudo add-apt-repository universe
                                            sudo apt -y install apt-transport-https
                                            sudo apt update
                                            sudo apt -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "19.04" ]; then
                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
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
                                            printf "\nYou may not be running the proper Ubuntu release.\n\nPlease verify it's able to run this.\n\n"
                                            exit 1
                                        fi
                                    elif [ "$os" == "CentOS Linux" ]; then
                                        printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                        sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
                                        sudo yum -y update
                                        sudo yum -y install dotnet-sdk-2.2
                                    elif [ "$os" == "Fedora" ]; then
                                        if [ "$osR" == "27" ]; then
                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                            cd /tmp
                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                            sudo dnf -y update
                                            sudo dnf -y install dotnet-sdk-2.2
                                        elif [ "$osR" == "28" ]; then
                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                            cd /tmp
                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                            sudo dnf -y update
                                            sudo dnf -y install dotnet-sdk-2.2
                                        else
                                            printf "\nYou may not be running the proper Fedora release.\n\nPlease verify it's able to run this.\n\n"
                                            exit 1
                                        fi
                                    fi
                                elif [ -x "$(command -v dotnet --list-sdks)" ]; then
                                    printf "\n.NET SDK already installed.\n\nInstalling .NET runtime on ARM device...\n\n"
                                else
                                    printf "\nYou may not be running a proper environment for this script.\n\nPlease verify before running again.\n\n"
                                    exit 1
                                fi
                                while true; do
                                    read -p "Is .NET runtime installed on the ARM Device?" yn
                                    case $yn in
                                        y|Y )
                                            break
                                            ;;
                                        n|N ) 
                                            dotnetArm(){
                                                choices=("Ubuntu" "Debian" "CentOS" "Fedora")
                                                select opt in "${choices[@]}"
                                                do
                                                    case $opt in
                                                        "Ubuntu")
                                                            releases(){
                                                                choices=("16.04" "18.04/18.10" "19.04")
                                                                select opt in "${choices[@]}"
                                                                do
                                                                    case $opt in
                                                                        "16.04")
                                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
EOS
                                                                            chmod +x dotnet.sh
                                                                            printf "\nSending script to ARM device.\n\n"
                                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                            printf "\nRemoving script that was created and used...\n\n"
                                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                            rm -rf dotnet.sh
                                                                            break
                                                                            ;;
                                                                        "18.04/18.10")
                                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
    printf "\n.NET runtime may not have installed properly.\n\nAttempting alternative method...\n\n"
    sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install aspnetcore-runtime-2.2
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        printf "\n.NET runtime may still be having issues installing.\n\nAttempting final alternative method provided by Microsoft.\n\n"
        cd /tmp
        sudo apt-get install -y gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt -y install -y apt-transport-https
        sudo apt update
        sudo apt -y install aspnetcore-runtime-2.2
        if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
            printf "\nFor some reason .NET runtime failed to install.\n\nPlease verify on the ARM device using: dotnet --list-sdks"
        fi
    fi
fi
EOS
                                                                            chmod +x dotnet.sh
                                                                            printf "\nSending script to ARM device.\n\n"
                                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                            printf "\nRemoving script that was created and used...\n\n"
                                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                            rm -rf dotnet.sh
                                                                            break
                                                                            ;;
                                                                        "19.04")
                                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
    printf "\n.NET runtime may not have installed properly.\n\nAttempting alternative method...\n\n"
    sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install aspnetcore-runtime-2.2
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        printf "\n.NET runtime may still be having issues installing.\n\nAttempting final alternative method provided by Microsoft.\n\n"
        cd /tmp
        sudo apt -y install -y gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/19.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt -y install apt-transport-https
        sudo apt update
        sudo apt -y install aspnetcore-runtime-2.2
        if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
            printf "\nFor some reason .NET runtime failed to install.\n\nPlease verify on the ARM device using: dotnet --list-sdks"
        fi
    fi
fi
EOS
                                                                            chmod +x dotnet.sh
                                                                            printf "\nSending script to ARM device.\n\n"
                                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                            printf "\nRemoving script that was created and used...\n\n"
                                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                            rm -rf dotnet.sh
                                                                            break
                                                                            ;;
                                                                        *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                                    esac
                                                                done
                                                            }
                                                            releases
                                                            break
                                                            ;;
                                                        "Debian")
                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET runtime now...\n\n"
cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install aspnetcore-runtime-2.2
EOS
                                                            chmod +x dotnet.sh
                                                            printf "\nSending script to ARM device.\n\n"
                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                            printf "\nRemoving script that was created and used...\n\n"
                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                            rm -rf dotnet.sh
                                                            break
                                                            ;;
                                                        "CentOS")
                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum -y update
sudo yum -y install aspnetcore-runtime-2.2
EOS
                                                            chmod +x dotnet.sh
                                                            printf "\nSending script to ARM device.\n\n"
                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                            printf "\nRemoving script that was created and used...\n\n"
                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                            rm -rf dotnet.sh
                                                            break
                                                            ;;
                                                        "Fedora")
                                                            releases(){
                                                                choices=("27" "28")
                                                                select opt in "${choices[@]}"
                                                                do
                                                                    case $opt in
                                                                        "27")
                                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cd /tmp
sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
sudo dnf -y update
sudo dnf -y install aspnetcore-runtime-2.2
EOS
                                                                            chmod +x dotnet.sh
                                                                            printf "\nSending script to ARM device.\n\n"
                                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                            printf "\nRemoving script that was created and used...\n\n"
                                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                            rm -rf dotnet.sh
                                                                            break
                                                                            ;;
                                                                        "28")
                                                                            cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cd /tmp
sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
sudo dnf -y update
sudo dnf -y install aspnetcore-runtime-2.2
EOS
                                                                            chmod +x dotnet.sh
                                                                            printf "\nSending script to ARM device.\n\n"
                                                                            rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                            printf "\nLaunching script to install .NET runtime.\n\n"
                                                                            ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                            printf "\nRemoving script that was created and used...\n\n"
                                                                            ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                            rm -rf dotnet.sh
                                                                            break
                                                                            ;;
                                                                        *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                                    esac
                                                                done
                                                            }
                                                            releases
                                                            break
                                                            ;;
                                                        *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                    esac
                                                done
                                            }
                                            dotnetArm
                                            break
                                            ;;
                                        * ) printf "\nPlease answer yes or no.\n\n";;
                                    esac
                                done
                                if [ ! -d "/home/$USER/X42-FullNode" ]; then
                                    printf "~/X42-FullNode not found, downloading from GitHub...\n\n"
                                    git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
                                    printf "\nBuilding FullNode...\n\n"
                                    cd ~/X42-FullNode/src
                                    dotnet restore
                                    dotnet publish --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    fi
                                    rsync -ahP ~/x42node $username@$ipAddr:/home/$username
                                else
                                    printf "X42-FullNode folder found. Updating now...\n\n"
                                    cd ~/X42-FullNode
                                    git pull origin master
                                    printf "\nBuilding FullNode...\n\n"
                                    cd src
                                    dotnet restore
                                    dotnet publish --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    fi
                                    rsync -ahP ~/x42node $username@$ipAddr:/home/$username
                                fi
                                osChoice(){
                                    printf "\n     ARM x42node.service Setup     \n\nWhich OS is your ARM device using?\n\n"
                                    choices=("Fedora" "Ubuntu/Debian" "CentOS")
                                    select opt in "${choices[@]}"
                                    do
                                        case $opt in
                                            "Fedora")
                                                cat <<EOS > x42node-service.sh
printf "\nCreating x42node.service.\n\n"
sudo touch /etc/systemd/system/x42node.service
sudo -s <<SUDO
cat <<EOF > /etc/systemd/system/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$username/x42node
ExecStart=/usr/bin/dotnet /home/$username/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$username
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
SUDO
sudo systemctl daemon-reload
if [ -e "/etc/systemd/system/x42node.service" ]; then
    printf "\nFinished setup of: x42node.service.\n\n"
else
    printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
    exit 1
fi
printf "\nStarting x42node.service\n\n"
sudo systemctl start x42node.service
sleep 1.25
if [ "$(systemctl is-active x42node.service)" == "active" ]; then
    printf "\nThe x42-FullNode is currently active.\n\nYou can now SSH to the ARM device and check the status using: curl http://127.0.0.1:42220/api/Dashbaord/Stats"
else
    printf "\nIt appears x42node.service did not setup properly.\n\nCheck via SSH using: sudo systemctl status x42node.service\n\n"
fi
EOS
                                                chmod +x x42node-service.sh
                                                printf "\nSending script to ARM device.\n\n"
                                                rsync -ahP x42node-service.sh $username@$ipAddr:/home/$username
                                                printf "\nLaunching script to setup x42node.service\n\n"
                                                ssh $username@$ipAddr "bash -s" < x42node-service.sh
                                                printf "\nRemoving script that was created and used...\n\n"
                                                ssh $username@$ipAddr "rm -rf ~/x42node-service.sh"
                                                rm -rf x42node-service.sh
                                                exit 1
                                                ;;
                                            "Ubuntu/Debian")
                                                cat <<EOS > x42node-service.sh
printf "\nCreating x42node.service.\n\n"
cat <<EOF > ~/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$username/x42node
ExecStart=/usr/bin/dotnet /home/$username/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$username
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
sudo mv ~/x42node.service /etc/systemd/system/x42node.service
if [ -e "/etc/systemd/system/x42node.service" ]; then
    printf "\nFinished setup of: x42node.service.\n\n"
else
    printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
    exit 1
fi
printf "\nStarting x42node.service\n\n"
sudo systemctl start x42node.service
sleep 1.25
if [ "$(systemctl is-active x42node.service)" == "active" ]; then
    printf "\nThe x42-FullNode is currently active.\n\nYou can now SSH to the ARM device and check the status using: curl http://127.0.0.1:42220/api/Dashbaord/Stats"
else
    printf "\nIt appears x42node.service did not setup properly.\n\nCheck via SSH using: sudo systemctl status x42node.service\n\n"
fi
EOS
                                                chmod +x x42node-service.sh
                                                printf "\nSending script to ARM device.\n\n"
                                                rsync -ahP x42node-service.sh $username@$ipAddr:/home/$username
                                                printf "\nLaunching script to setup x42node.service\n\n"
                                                ssh $username@$ipAddr "bash -s" < x42node-service.sh
                                                printf "\nRemoving script that was created and used...\n\n"
                                                ssh $username@$ipAddr "rm -rf ~/x42node-service.sh"
                                                rm -rf x42node-service.sh
                                                exit 1
                                                ;;
                                            "CentOS")
                                                cat <<EOS > x42node-service.sh
printf "\nCreating x42node.service.\n\n"
cat <<EOF > ~/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$username/x42node
ExecStart=/usr/bin/dotnet /home/$username/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$username
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
sudo mv ~/x42node.service /etc/systemd/system/x42node.service
if [ -e "/etc/systemd/system/x42node.service" ]; then
    printf "\nFinished setup of: x42node.service.\n\n"
else
    printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
    exit 1
fi
printf "\nStarting x42node.service\n\n"
sudo systemctl start x42node.service
sleep 1.25
if [ "$(systemctl is-active x42node.service)" == "active" ]; then
    printf "\nThe x42-FullNode is currently active.\n\nYou can now SSH to the ARM device and check the status using: curl http://127.0.0.1:42220/api/Dashbaord/Stats"
else
    printf "\nIt appears x42node.service did not setup properly.\n\nCheck via SSH using: sudo systemctl status x42node.service\n\n"
fi
EOS
                                                chmod +x x42node-service.sh
                                                printf "\nSending script to ARM device.\n\n"
                                                rsync -ahP x42node-service.sh $username@$ipAddr:/home/$username
                                                printf "\nLaunching script to setup x42node.service\n\n"
                                                ssh $username@$ipAddr "bash -s" < x42node-service.sh
                                                printf "\nRemoving script that was created and used...\n\n"
                                                ssh $username@$ipAddr "rm -rf ~/x42node-service.sh"
                                                rm -rf x42node-service.sh
                                                exit 1
                                                ;;
                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                        esac
                                    done
                                }
                                clear
                                osChoice
                                ;;
                            "Install .NET Only")
                                netMenu(){
                                    printf "\n     .NET Installation     \n\nWhat would you like to do?\n\n"
                                    dotnetMenu=("Install for Current OS and ARM" "Install .NET SDK for current device" "Install .NET on ARM device" "Go Back")
                                    select opt in "${dotnetMenu[@]}"
                                    do
                                        case $opt in
                                            "Install for Current OS and ARM")
                                                if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                                                    printf "\nChecking Linux release...\n"
                                                    if [ "$os" == "Debian" ]; then
                                                        if [ "$osR" == "9" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            cd /tmp
                                                            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                                                            sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                                                            wget -q https://packages.microsoft.com/config/debian/9/prod.list
                                                            sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                                                            sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                                                            sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                                                            sudo apt install apt-transport-https
                                                            sudo apt update
                                                            sudo apt install dotnet-sdk-2.2
                                                        else
                                                            printf "\nUnfortunately you don't appear to be running a proper Debian release.\n\n"
                                                            exit 1
                                                        fi
                                                    elif [ "$os" == "Ubuntu" ]; then
                                                        if [ "$osR" == "16.04" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            cd /tmp
                                                            wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
                                                            sudo dpkg -i packages-microsoft-prod.deb
                                                            sudo apt -y install apt-transport-https
                                                            sudo apt update
                                                            sudo apt -y install dotnet-sdk-2.2
                                                        elif [ "$osR" == "18.04" -o "$osR" == "18.10" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            cd /tmp
                                                            wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
                                                            sudo dpkg -i packages-microsoft-prod.deb
                                                            sudo add-apt-repository universe
                                                            sudo apt -y install apt-transport-https
                                                            sudo apt update
                                                            sudo apt -y install dotnet-sdk-2.2
                                                        elif [ "$osR" == "19.04" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
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
                                                            printf "\nYou may not be running the proper Ubuntu release.\n\nPlease verify it's able to run this.\n\n"
                                                            exit 1
                                                        fi
                                                    elif [ "$os" == "CentOS Linux" ]; then
                                                        printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                        sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
                                                        sudo yum -y update
                                                        sudo yum -y install dotnet-sdk-2.2
                                                    elif [ "$os" == "Fedora" ]; then
                                                        if [ "$osR" == "27" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                                            cd /tmp
                                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                                            sudo dnf -y update
                                                            sudo dnf -y install dotnet-sdk-2.2
                                                        elif [ "$osR" == "28" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                                            cd /tmp
                                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                                            sudo dnf -y update
                                                            sudo dnf -y install dotnet-sdk-2.2
                                                        else
                                                            printf "\nYou may not be running the proper Fedora release.\n\nPlease verify it's able to run this.\n\n"
                                                        fi
                                                    else
                                                        printf "\nYou may not be running a proper environment for this script.\n\nPlease verify before running again.\n\n"
                                                        exit 1
                                                    fi
                                                elif [ -x "$(command -v dotnet --list-sdks)" ]; then
                                                    printf "\n.NET appears to be installed already.\n\nPlease verify it's 2.2.x if the installer failed for some reason.\n\nCheck using: dotnet --list-sdks\n\nIf already installed, re-run and use the All-in-One Installer from the Menu.\n\nExiting in 5s"
                                                    sleep 5
                                                    clear
                                                    exit 1
                                                fi
                                                printf "\nVerifying .NET is installed successfully...\n\n"
                                                if [ -x "$(command -v dotnet --list-sdks)" ]; then
                                                    printf ".NET installed successfully.\n\n"
                                                else
                                                    printf ".NET may not have installed properly.\n\nYou can verify with 'dotnet --list-sdks'.\n\nExiting..."
                                                    exit 1
                                                fi
                                                dotnetArm(){
                                                    choices=("Ubuntu" "Debian" "CentOS" "Fedora" "Go Back")
                                                    select opt in "${choices[@]}"
                                                    do
                                                        case $opt in
                                                            "Ubuntu")
                                                                releases(){
                                                                    choices=("16.04" "18.04/18.10" "19.04" "Go Back")
                                                                    select opt in "${choices[@]}"
                                                                    do
                                                                        case $opt in
                                                                            "16.04")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "18.04/18.10")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
    printf "\n.NET runtime may not have installed properly.\n\nAttempting alternative method...\n\n"
    cd /tmp
    sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install aspnetcore-runtime-2.2
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        printf "\n.NET runtime may still be having issues installing.\n\nAttempting final alternative method provided by Microsoft.\n\n"
        cd /tmp
        sudo apt-get install -y gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt -y install -y apt-transport-https
        sudo apt update
        sudo apt -y install aspnetcore-runtime-2.2
        if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
            printf "\nFor some reason .NET runtime failed to install.\n\nPlease verify on the ARM device using: dotnet --list-sdks"
        fi
    fi
fi
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "19.04")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
    printf "\n.NET runtime may not have installed properly.\n\nAttempting alternative method...\n\n"
    cd /tmp
    sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install aspnetcore-runtime-2.2
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        printf "\n.NET runtime may still be having issues installing.\n\nAttempting final alternative method provided by Microsoft.\n\n"
        cd /tmp
        sudo apt -y install -y gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/19.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt -y install apt-transport-https
        sudo apt update
        sudo apt -y install aspnetcore-runtime-2.2
        if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
            printf "\nFor some reason .NET runtime failed to install.\n\nPlease verify on the ARM device using: dotnet --list-sdks"
        fi
    fi
fi
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "Go Back")
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                                        esac
                                                                    done
                                                                }
                                                                clear
                                                                releases
                                                                ;;
                                                            "Debian")
                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET runtime now...\n\n"
cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install aspnetcore-runtime-2.2
EOS
                                                                chmod +x dotnet.sh
                                                                printf "\nSending script to ARM device.\n\n"
                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                rm -rf dotnet.sh
                                                                printf "\nReturning to prior Menu.\n\n"
                                                                clear
                                                                instArm
                                                                ;;
                                                            "CentOS")
                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum -y update
sudo yum -y install aspnetcore-runtime-2.2
EOS
                                                                chmod +x dotnet.sh
                                                                printf "\nSending script to ARM device.\n\n"
                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                rm -rf dotnet.sh
                                                                printf "\nReturning to prior Menu.\n\n"
                                                                clear
                                                                instArm
                                                                ;;
                                                            "Fedora")
                                                                releases(){
                                                                    choices=("27" "28" "Go Back")
                                                                    select opt in "${choices[@]}"
                                                                    do
                                                                        case $opt in
                                                                            "27")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cd /tmp
sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
sudo dnf -y update
sudo dnf -y install aspnetcore-runtime-2.2
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "28")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cd /tmp
sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
sudo dnf -y update
sudo dnf -y install aspnetcore-runtime-2.2
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "Go Back")
                                                                                clear
                                                                                dotnetArm
                                                                                ;;
                                                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                                        esac
                                                                    done
                                                                }
                                                                clear
                                                                releases
                                                                ;;
                                                            "Go Back")
                                                                clear
                                                                instArm
                                                                ;;
                                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                        esac
                                                    done
                                                }
                                                clear
                                                dotnetArm
                                                ;;
                                            "Install .NET SDK for current device")
                                                if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
                                                    printf "\nInstalling .NET SDK only, checking Linux release...\n"
                                                    if [ "$os" == "Debian" ]; then
                                                        if [ "$osR" == "9" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            cd /tmp
                                                            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                                                            sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                                                            wget -q https://packages.microsoft.com/config/debian/9/prod.list
                                                            sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                                                            sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                                                            sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                                                            sudo apt install apt-transport-https
                                                            sudo apt update
                                                            sudo apt install dotnet-sdk-2.2
                                                        else
                                                            printf "\nUnfortunately you don't appear to be running a proper Debian release.\n\n"
                                                            exit 1
                                                        fi
                                                    elif [ "$os" == "Ubuntu" ]; then
                                                        if [ "$osR" == "16.04" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            cd /tmp
                                                            wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
                                                            sudo dpkg -i packages-microsoft-prod.deb
                                                            sudo apt -y install apt-transport-https
                                                            sudo apt update
                                                            sudo apt -y install dotnet-sdk-2.2
                                                        elif [ "$osR" == "18.04" -o "$osR" == "18.10" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            cd /tmp
                                                            wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
                                                            sudo dpkg -i packages-microsoft-prod.deb
                                                            sudo add-apt-repository universe
                                                            sudo apt -y install apt-transport-https
                                                            sudo apt update
                                                            sudo apt -y install dotnet-sdk-2.2
                                                        elif [ "$osR" == "19.04" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
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
                                                            printf "\nYou may not be running the proper Ubuntu release.\n\nPlease verify it's able to run this.\n\n"
                                                            exit 1
                                                        fi
                                                    elif [ "$os" == "CentOS Linux" ]; then
                                                        printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                        sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
                                                        sudo yum update
                                                        sudo yum install dotnet-sdk-2.2
                                                    elif [ "$os" == "Fedora" ]; then
                                                        if [ "$osR" == "27" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                                            cd /tmp
                                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                                            sudo dnf -y update
                                                            sudo dnf -y install dotnet-sdk-2.2
                                                        elif [ "$osR" == "28" ]; then
                                                            printf "\nUsing: $os $osR, Installing .NET SDK now...\n\n"
                                                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                                                            cd /tmp
                                                            sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
                                                            sudo dnf -y update
                                                            sudo dnf -y install dotnet-sdk-2.2
                                                        else
                                                            printf "\nYou may not be running the proper Fedora release.\n\nPlease verify it's able to run this.\n\n"
                                                            exit 1
                                                        fi
                                                    else
                                                        printf "\nYou may not be running a proper environment for this script.\n\nPlease verify before running again.\n\n"
                                                        exit 1
                                                    fi
                                                elif [ -x "$(command -v dotnet --list-sdks)" ]; then
                                                    printf "\n.NET appears to be installed already.\n\nPlease verify it's 2.2.x if the installer failed for some reason.\n\nCheck using: dotnet --list-sdks\n\nIf already installed, re-run and use the All-in-One Installer from the Menu.\n\nExiting in 5s"
                                                    sleep 5
                                                    clear
                                                    exit 1
                                                fi
                                                printf "\nVerifying .NET is installed successfully...\n\n"
                                                if [ -x "$(command -v dotnet --list-sdks)" ]; then
                                                    printf ".NET installed successfully.\n\nReturning to the prior Menu in 5s...\n\n"
                                                    sleep 5
                                                else
                                                    printf ".NET may not have installed properly.\n\nYou can verify with 'dotnet --list-sdks'.\n\nExiting..."
                                                    exit 1
                                                fi
                                                clear
                                                instArm
                                                ;;
                                            "Install .NET on ARM device")
                                                dotnetArm(){
                                                    choices=("Ubuntu" "Debian" "CentOS" "Fedora" "Go Back")
                                                    select opt in "${choices[@]}"
                                                    do
                                                        case $opt in
                                                            "Ubuntu")
                                                                releases(){
                                                                    choices=("16.04" "18.04/18.10" "19.04" "Go Back")
                                                                    select opt in "${choices[@]}"
                                                                    do
                                                                        case $opt in
                                                                            "16.04")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "18.04/18.10")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
    printf "\n.NET runtime may not have installed properly.\n\nAttempting alternative method...\n\n"
    cd /tmp
    sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install aspnetcore-runtime-2.2
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        printf "\n.NET runtime may still be having issues installing.\n\nAttempting final alternative method provided by Microsoft.\n\n"
        cd /tmp
        sudo apt-get install -y gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt -y install -y apt-transport-https
        sudo apt update
        sudo apt -y install aspnetcore-runtime-2.2
        if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
            printf "\nFor some reason .NET runtime failed to install.\n\nPlease verify on the ARM device using: dotnet --list-sdks"
        fi
    fi
fi
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "19.04")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install aspnetcore-runtime-2.2
if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
    printf "\n.NET runtime may not have installed properly.\n\nAttempting alternative method...\n\n"
    cd /tmp
    sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb
    sudo apt update
    sudo apt -y install aspnetcore-runtime-2.2
    if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
        printf "\n.NET runtime may still be having issues installing.\n\nAttempting final alternative method provided by Microsoft.\n\n"
        cd /tmp
        sudo apt -y install -y gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/19.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt -y install apt-transport-https
        sudo apt update
        sudo apt -y install aspnetcore-runtime-2.2
        if [ ! -x "$(command -v dotnet --list-sdks)" ]; then
            printf "\nFor some reason .NET runtime failed to install.\n\nPlease verify on the ARM device using: dotnet --list-sdks"
        fi
    fi
fi
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "Go Back")
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                                        esac
                                                                    done
                                                                }
                                                                clear
                                                                releases
                                                                ;;
                                                            "Debian")
                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET runtime now...\n\n"
cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install aspnetcore-runtime-2.2
EOS
                                                                chmod +x dotnet.sh
                                                                printf "\nSending script to ARM device.\n\n"
                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                rm -rf dotnet.sh
                                                                printf "\nReturning to prior Menu.\n\n"
                                                                clear
                                                                instArm
                                                                ;;
                                                            "CentOS")
                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum -y update
sudo yum -y install aspnetcore-runtime-2.2
EOS
                                                                chmod +x dotnet.sh
                                                                printf "\nSending script to ARM device.\n\n"
                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                rm -rf dotnet.sh
                                                                printf "\nReturning to prior Menu.\n\n"
                                                                clear
                                                                instArm
                                                                ;;
                                                            "Fedora")
                                                                releases(){
                                                                    choices=("27" "28" "Go Back")
                                                                    select opt in "${choices[@]}"
                                                                    do
                                                                        case $opt in
                                                                            "27")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cd /tmp
sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
sudo dnf -y update
sudo dnf -y install aspnetcore-runtime-2.2
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "28")
                                                                                cat <<EOS > dotnet.sh
printf "\nInstalling .NET Runtime now...\n\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cd /tmp
sudo wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/27/prod.repo
sudo dnf -y update
sudo dnf -y install aspnetcore-runtime-2.2
EOS
                                                                                chmod +x dotnet.sh
                                                                                printf "\nSending script to ARM device.\n\n"
                                                                                rsync -ahP dotnet.sh $username@$ipAddr:/home/$username
                                                                                printf "\nLaunching script to install .NET runtime.\n\n"
                                                                                ssh $username@$ipAddr "bash -s" < dotnet.sh
                                                                                printf "\nRemoving script that was created and used...\n\n"
                                                                                ssh $username@$ipAddr "rm -rf ~/dotnet.sh"
                                                                                rm -rf dotnet.sh
                                                                                printf "\nReturning to prior Menu.\n\n"
                                                                                clear
                                                                                instArm
                                                                                ;;
                                                                            "Go Back")
                                                                                clear
                                                                                dotnetArm
                                                                                ;;
                                                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                                        esac
                                                                    done
                                                                }
                                                                clear
                                                                releases
                                                                ;;
                                                            "Go Back")
                                                                clear
                                                                instArm
                                                                ;;
                                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                                        esac
                                                    done
                                                }
                                                clear
                                                dotnetArm
                                                ;;
                                            "Go Back")
                                                clear
                                                instArm
                                                ;;
                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                        esac
                                    done
                                }
                                clear
                                netMenu
                                ;;
                            "Download and Build X42-FullNode Only")
                                if [ ! -d "/home/$USER/X42-FullNode" ]; then
                                    printf "~/X42-FullNode not found, downloading from GitHub...\n\n"
                                    git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
                                    printf "\nBuilding FullNode...\n\n"
                                    cd ~/X42-FullNode/src
                                    dotnet restore
                                    dotnet publish --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    fi
                                    printf "\n~/x42node now available to transfer to ARM device.\n\nReturning to prior menu in 2.5s...\n\n"
                                    sleep 2.5
                                    clear
                                    instArm
                                else
                                    printf "X42-FullNode folder found. Updating now...\n\n"
                                    cd ~/X42-FullNode
                                    git pull origin master
                                    printf "\nBuilding FullNode...\n\n"
                                    cd src
                                    dotnet restore
                                    dotnet publish --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    fi
                                    printf "\n~/x42node now available to transfer to ARM device.\n\nReturning to prior menu in 2.5s...\n\n"
                                    sleep 2.5
                                    clear
                                    instArm
                                fi
                                ;;
                            "Setup x42node.service Only")
                                osChoice(){
                                    printf "\n     ARM x42node.service Setup (ONLY creates service file)     \n\nWhich OS is your ARM device using?\n\n"
                                    choices=("Fedora" "Ubuntu/Debian" "CentOS" "Go Back")
                                    select opt in "${choices[@]}"
                                    do
                                        case $opt in
                                            "Fedora")
                                                cat <<EOS > x42node-service.sh
printf "\nCreating x42node.service.\n\n"
sudo touch /etc/systemd/system/x42node.service
sudo -s <<SUDO
cat <<EOF > /etc/systemd/system/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$username/x42node
ExecStart=/usr/bin/dotnet /home/$username/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$username
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
SUDO
sudo systemctl daemon-reload
if [ -e "/etc/systemd/system/x42node.service" ]; then
    printf "\nFinished setup of: x42node.service.\n\n"
else
    printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
    exit 1
fi
EOS
                                                chmod +x x42node-service.sh
                                                printf "\nSending script to ARM device.\n\n"
                                                rsync -ahP x42node-service.sh $username@$ipAddr:/home/$username
                                                printf "\nLaunching script to setup x42node.service\n\n"
                                                ssh $username@$ipAddr "bash -s" < x42node-service.sh
                                                printf "\nRemoving script that was created and used...\n\n"
                                                ssh $username@$ipAddr "rm -rf ~/x42node-service.sh"
                                                rm -rf x42node-service.sh
                                                printf "\nReturning to prior Menu.\n\n"
                                                clear
                                                instArm
                                                ;;
                                            "Ubuntu/Debian")
                                                cat <<EOS > x42node-service.sh
printf "\nCreating x42node.service.\n\n"
cat <<EOF > ~/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$username/x42node
ExecStart=/usr/bin/dotnet /home/$username/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$username
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
sudo mv ~/x42node.service /etc/systemd/system/x42node.service
if [ -e "/etc/systemd/system/x42node.service" ]; then
    printf "\nFinished setup of: x42node.service.\n\n"
else
    printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
    exit 1
fi
EOS
                                                chmod +x x42node-service.sh
                                                printf "\nSending script to ARM device.\n\n"
                                                rsync -ahP x42node-service.sh $username@$ipAddr:/home/$username
                                                printf "\nLaunching script to setup x42node.service\n\n"
                                                ssh $username@$ipAddr "bash -s" < x42node-service.sh
                                                printf "\nRemoving script that was created and used...\n\n"
                                                ssh $username@$ipAddr "rm -rf ~/x42node-service.sh"
                                                rm -rf x42node-service.sh
                                                printf "\nReturning to prior Menu.\n\n"
                                                clear
                                                instArm
                                                ;;
                                            "CentOS")
                                                cat <<EOS > x42node-service.sh
printf "\nCreating x42node.service.\n\n"
cat <<EOF > ~/x42node.service
[Unit]
Description=x42 Node
[Service]
WorkingDirectory=/home/$username/x42node
ExecStart=/usr/bin/dotnet /home/$username/x42node/x42.x42D.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=x42node
User=$username
Environment=ASPNETCORE_ENVIRONMENT=Development
[Install]
WantedBy=multi-user.target
EOF
sudo mv ~/x42node.service /etc/systemd/system/x42node.service
if [ -e "/etc/systemd/system/x42node.service" ]; then
    printf "\nFinished setup of: x42node.service.\n\n"
else
    printf "\nx42node.service creation failed.\n\nExiting script.\n\n"
    exit 1
fi
EOS
                                                chmod +x x42node-service.sh
                                                printf "\nSending script to ARM device.\n\n"
                                                rsync -ahP x42node-service.sh $username@$ipAddr:/home/$username
                                                printf "\nLaunching script to setup x42node.service\n\n"
                                                ssh $username@$ipAddr "bash -s" < x42node-service.sh
                                                printf "\nRemoving script that was created and used...\n\n"
                                                ssh $username@$ipAddr "rm -rf ~/x42node-service.sh"
                                                rm -rf x42node-service.sh
                                                printf "\nReturning to prior Menu.\n\n"
                                                clear
                                                instArm
                                                ;;
                                            "Go Back")
                                                clear
                                                instArm
                                                ;;
                                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                                        esac
                                    done
                                }
                                clear
                                osChoice
                                ;;
                            "Go Back")
                                clear
                                mainMenu
                                ;;
                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                        esac
                    done
                }
                clear
                instArm
                ;;
            "Update ARM")
                clear
                armSSH
                updArm(){
                    printf "\n     X42-FullNode ARM device Updater     \n\nWhat would you like to do?\n\n"
                    armMenu=("All-in-One Updater" "Update and Build FullNode Only (does NOT transfer ~/x42node folder)" "Go Back")
                    select opt in "${armMenu[@]}"
                    do
                        case $opt in
                            "All-in-One Updater")
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
                                    printf "\nStopping service and removing x42node folder from ARM device.\n\n"
                                    ssh $username@$ipAddr 'sudo systemctl stop x42node.service; rm -rf ~/x42node'
                                    printf "\nCopying updated x42node folder to ARM device.\n\n"
                                    rsync -ahP ~/x42node $username@$ipAddr:/home/$username
                                    printf "\nStarting x42node.service\n\n"
                                    ssh $username@$ipAddr 'sudo systemctl start x42node.service'
                                    printf "\nVerifying x42node.service is active...\n\n"
                                    if [ "$(ssh $username@$ipAddr 'systemctl is-active x42node.service')" == "active" ]; then
                                        printf "\nx42node.service started successfully.\n\n"
                                    else
                                        printf "\nx42node.service may have not started successfully.\n\nTry connecting to the ARM device and check the status, use: sudo systemctl status x42node.service\n\nExiting...\n\n"
                                        if [ "$notAvail" == "20" ]; then
                                            rm -rf ~/X42-FullNode
                                        elif [ "$notAvail" == "22" ]; then
                                            rm -rf ~/x42node
                                        elif [ "$notAvail" == "42" ]; then
                                            rm -rf ~/X42-FullNode
                                            rm -rf ~/x42node
                                        fi
                                        exit 1
                                    fi
                                    if [ "$notAvail" == "20" ]; then
                                        rm -rf ~/X42-FullNode
                                    elif [ "$notAvail" == "22" ]; then
                                        rm -rf ~/x42node
                                    elif [ "$notAvail" == "42" ]; then
                                        rm -rf ~/X42-FullNode
                                        rm -rf ~/x42node
                                    fi
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
                                    printf"\nStopping service and removing x42node folder from ARM device.\n\n"
                                    ssh $username@$ipAddr 'sudo systemctl stop x42node.service; rm -rf ~/x42node'
                                    printf "\nCopying updated x42node folder to ARM device.\n\n"
                                    rsync -ahP ~/x42node $username@$ipAddr:/home/$username
                                    printf "\nStarting x42node.service\n\n"
                                    ssh $username@$ipAddr 'sudo systemctl start x42node.service'
                                    printf "\nVerifying x42node.service is active...\n\n"
                                    if [ "$(ssh $username@$ipAddr 'systemctl is-active x42node.service')" == "active" ]; then
                                        printf "\nx42node.service started successfully.\n\n"
                                    else
                                        printf "\nx42node.service may have not started successfully.\n\nTry connecting to the ARM device and check the status, use: sudo systemctl status x42node.service\n\nExiting...\n\n"
                                        if [ "$notAvail" == "42" ]; then
                                            rm -rf ~/x42node
                                        fi
                                        exit 1
                                    fi
                                    if [ "$notAvail" == "42" ]; then
                                        rm -rf ~/x42node
                                    fi
                                fi
                                printf "Finished updating, returning to Main Menu in 5s...\n"
                                sleep 5
                                clear
                                mainMenu
                                ;;
                            "Update and Build FullNode Only (does NOT transfer ~/x42node folder)")
                                printf "\nChecking if the X42-FullNode folder is available...\n\n"
                                notAvail=0
                                if [ ! -d "/home/$USER/X42-FullNode" ]; then
                                    ((notAvail+=42))
                                    printf "Folder not found, downloading from GitHub...\n\n"
                                    git clone https://github.com/x42protocol/X42-FullNode.git ~/X42-FullNode
                                    printf "\nBuilding FullNode...\n\n"
                                    cd ~/X42-FullNode/src
                                    dotnet restore
                                    dotnet publish --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    fi
                                    if [ "$notAvail" == "42" ]; then
                                        rm -rf ~/X42-FullNode
                                    fi
                                else
                                    printf "X42-FullNode folder found. Updating now...\n\n"
                                    cd ~/X42-FullNode
                                    git pull origin master
                                    printf "\nBuilding FullNode...\n\n"
                                    cd src
                                    dotnet restore
                                    dotnet publish --configuration Release
                                    if [ ! -d "/home/$USER/x42node" ]; then
                                        mv x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    else
                                        mv -f x42.x42D/bin/Release/netcoreapp2.1/publish ~/x42node
                                    fi
                                fi
                                printf "Finished updating ~/x42node\n\nReturning to Main Menu in 5s...\n"
                                sleep 5
                                clear
                                mainMenu
                                ;;
                            "Go Back")
                                clear
                                mainMenu
                                ;;
                            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
                        esac
                    done
                }
                clear
                updArm
                ;;
            "Quit")
                clear
                exit 1
                ;;
            *) printf "\nInvalid option: $REPLY\n\nPlease try another option, ";;
        esac
    done
}
clear
mainMenu

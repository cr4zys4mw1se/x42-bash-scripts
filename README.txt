MAIN:
aio-installer.sh - Menu allows you to select what you would like to do:
   * Install X42-FullNode from scratch
   * Update existing X42-FullNode
   * Install to an ARM device
   * Update an ARM device

It will install .NET SDK if not installed and .NET runtime for the ARM device.
Runs on:
   * Ubuntu 18.04 and 20.04
   * Debian 9
   * CentOS


ADDITIONAL:
install.sh - Detects which Ubuntu release 18.04 and 20.04 is used. Installs .NET SDK based on Ubuntu release, if already installed, it continues to download the X42-FullNode repo. Builds the x42node and moves the needed files to a folder (/home/$USER/x42node | ~/x42node). Finishes by creating a service file (x42node.service) that enables x42node to startup at boot.

update.sh - Will verify if you have the X42-FullNode folder. It will either update or download accordingly. Stops the x42node.service. Runs the normal build process and starts the x42node.service when finished.

update-arm.sh- Similar to update.sh, it will detect if the X42-FullNode folder is available or not and builds the x42node. Prompts for the ARM device username and the ip. Then will ssh to the device, stops the x42node.service and removes the existing x42node folder. Transfers the new x42node folder and starts x42node.service.

_________________________________________________________

Support for Ubuntu 16.04 and Fedora 27/28 has been removed.
_________________________________________________________


Donation Addresses:
  * x42: XKCm56Q4GmxRYbk3aS8seAQaHdtUDpgEfx
  * BTC: 145QLo9jopWK3Z7h43fEgTy7AbUA239Ghz
  * LTC: LVkLucNkv43Zwpqx1Vb1mymnQR2YLPXzZR

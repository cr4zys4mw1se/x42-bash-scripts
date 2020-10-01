# x42 Bash Scripts

A few bash scripts that will allow you to do the following.

1. Install the [x42-FullNode](https://github.com/x42protocol/X42-FullNode) from scratch.
2. Update an existing FullNode on a regular device (pc, vps etc) or on an ARM based device.
___

`aio-installer.sh` - Menu allows you to select what you would like to do:
   * Install X42-FullNode from scratch
   * Update existing X42-FullNode
   * Install to an ARM device
   * Update an ARM device

It will install .NET SDK if not installed and .NET runtime for the ARM device.
Runs on:
   * Ubuntu 18.04 and 20.04
   * Debian 9
   * CentOS
___

`install.sh` - Detects which Ubuntu release *`18.04 and 20.04`* is used. Installs .NET SDK based on Ubuntu release, if already installed, it continues to download the X42-FullNode repo. Builds the x42node and moves the needed files to a folder *`(/home/$USER/x42node | ~/x42node)`*. Finishes by creating a service file *`(x42node.service)`* that enables x42node to startup at boot.

`update.sh` - Will verify if you have the X42-FullNode folder. It will either update or download accordingly. Stops the `x42node.service`. Runs the normal build process and starts the `x42node.service` when finished. *__Read the [Side-Notes](#side-notes)__ if you're __not__ using __`x42node.service`__.*

`update-arm.sh`- Similar to `update.sh`, it will detect if the X42-FullNode folder is available or not and builds the x42node. Prompts for the ARM device __*username*__ and the __*ip*__. Then will ssh to the device, stops the `x42node.service` and removes the existing x42node folder. Transfers the new x42node folder and starts `x42node.service`.
___
# Contents:
   * [Setup](#setup)
   * [Edits Required](#edits-required)
   * [Side-Notes](#side-notes)
___

## Setup
  * Download the script(s)
  * Make it executable - `chmod +x script.sh`
  * Run the script - `./script.sh`
  * Enter requested information when prompted

## Edits Required:
* None at this time

## Side-Notes:
  * Both `update` scripts assume you use a service named `x42node.service` and a folder named `x42node`.
      If you don't, be sure to edit the script accordingly.
  * `update-arm.sh` should be ran via a Debian/Ubuntu PC/Laptop that has dotnet 3.1.x and is on the same network as the ARM based device. (unless you've setup external network access)
  * A valuable guide to reference is [DarthNoodle's Reddit Post](https://www.reddit.com/r/x42/comments/akp6lp/creating_a_headless_staking_node_on_ubuntu_1804/), which thoroughly provides steps on installing the FullNode from scratch.
___
## Recent Adjustments:
  * Added Ubuntu 20.04
  * Removed Ubuntu 16.04, 18.10 and 19.04
  * Removed Fedora in general
  * Added README.txt
___

### *Donation Addresses:*
  * **x42:** XKCm56Q4GmxRYbk3aS8seAQaHdtUDpgEfx
  * **BTC:** 145QLo9jopWK3Z7h43fEgTy7AbUA239Ghz
  * **LTC:** LVkLucNkv43Zwpqx1Vb1mymnQR2YLPXzZR

# x42 Bash Scripts

A few quick and simple bash scripts that will allow you to do the following.

1. Install the x42-FullNode from scratch.
2. Update an existing FullNode on a regular device (pc, vps etc) or on an ARM based device.

A valuable guide to reference is [DarthNoodle's Reddit Post](https://www.reddit.com/r/x42/comments/akp6lp/creating_a_headless_staking_node_on_ubuntu_1804/), which thoroughly provides steps on installing the FullNode from scratch.

# Contents:
   * [Setup](#setup)
   * [Edits Required](#edits-required)
   * [Side-Notes](#side-notes)
___

## Setup
  * Download the script(s)
  * Move the script of choice to your Home folder. `(ex. /home/$USER)`
  * Make it executable - `chmod +x script.sh`
  * Run the script - `./script.sh`
  * Enter password when prompted

## Edits Required:
* General edits that _**need**_ to be made in `update-arm.sh`:
  * Replace `USERNAME` with the username you would use to connect to the device. `(ex. ssh cr4zys4mw1se@255.255.255.255)`
  * Replace `xxx.xxx.xxx.xxx` with the correct internal _IP Address_

## Side-Notes:
  * Both update scripts assume you use `x42node.service` as mentioned in DarthNoodle's guide via [Reddit](https://www.reddit.com/r/x42/comments/akp6lp/creating_a_headless_staking_node_on_ubuntu_1804/).
      If you don't, be sure to edit the script accordingly.
  * `update-arm.sh` should be ran via a Debian/Ubuntu PC/Laptop that has dotnet 2.2.x and is on the same network as the ARM based device. (unless you've setup external network access)

---

### *Donation Addresses:*
  * **x42:** XKCm56Q4GmxRYbk3aS8seAQaHdtUDpgEfx
  * **BTC:** 145QLo9jopWK3Z7h43fEgTy7AbUA239Ghz
  * **LTC:** LVkLucNkv43Zwpqx1Vb1mymnQR2YLPXzZR

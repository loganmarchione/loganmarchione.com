---
title: "ODROID-HC2 as an entry-level NAS"
date: "2018-06-13"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
  - "storage"
cover:
    image: "/assets/featured/featured_generic_storage.svg"
    alt: "featured image"
    relative: false
---
# Introduction

I've been doing some work on my homelab that I haven't documented here.

I recently decommissioned my Raspberry Pi 3 that was running my [Unifi controller](/2016/11/ubiquiti-unifi-controller-setup-raspberry-pi-3/), Dokuwiki, and [Network UPS Tools](/2017/02/raspberry-pi-ups-monitor-with-nginx-web-monitoring/) (NUT). I replaced the RPi3 with an Intel i3 [NUC](https://www.intel.com/content/www/us/en/products/boards-kits/nuc/kits/nuc7i3bnh.html) with 12GB RAM and a Crucial 2.5" SSD. I chose to use [Proxmox](https://www.proxmox.com/en/) as the hypervisor on the NUC because it is open source, has a well-proven record, and has a low learning curve. At the time of this writing, I'm running five KVM virtual machines:

- mgmt01 - Jump server and Ansible master
- unifi01 - Unifi controller
- nginx01 - LEMP stack, running Dokuwiki and NUT
- vpn01 - Pritunl
- log01 - Graylog

However, the one thing I'm missing is a backup server.

## 3-2-1 backup

The golden rule is to follow the 3-2-1 method for backups:

- 3 backups
- 2 different types of media
- 1 backup offsite

Currently, I'm following the 3-2-1 backup method, except the central location is my desktop PC. This is both inconvenient and a waste of space on my desktop. Ideally, I'd like have all the backups go to a NAS-type device, and have that device push the backups to a cloud provider (I already use [Backblaze B2](/2017/07/backblaze-b2-backup-setup/)).

{{< img src="20170612_002.png" alt="3-2-1 backup" >}}

## Devices

I looked at quite a few options, from single-board devices to full NAS devices, but ruled most of them out.

{{< procon/nas >}}

In the end, I decided on the [ODROID-HC2](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G151505170472). The HC2 is the larger version of the [HC1](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G150229074080) (the HC1 holds 2.5" drives, while the HC2 holds 3.5" drives).

{{< img src="20180601_001.jpg" alt="single HC2 in case" >}}

Both the HC2 and HC1 are based on the XU4, but lack the XU4's HDMI port, USB 3.0 ports, eMMC slot, and GPIO connectors. The HC2 features:

- Samsung Exynos 5422 eight-core CPU
- 2GB DDR3 RAM
- USB3.0-based SATA3 port
- Gigabit ethernet (Realtek chipset)
- USB2.0 port
- MicroSD slot
- UART for serial console
- Stackable aluminum frame that acts as a heatsink and drive cage

{{< img src="20180601_002.jpg" alt="multiple HC2s in cases" >}}

I purchased the HC2 from [ameriDroid](https://ameridroid.com/products/odroid-hc2), along with a power cable and clear top cover. I also picked up a [WD Red 4TB 5400 RPM hard drive](https://www.amazon.com/Red-4TB-Hard-Disk-Drive/dp/B00EHBERSE). The Red drives are WD's NAS drives, and the 5400 RPM speed will keep the unit quiet.

I chose the HC2, which is only a single-drive device, because I'm not looking for a 2-bay NAS with RAID support. The primary purpose of this device will be to backup all my other devices, then ship those backups offsite. If the drive dies, I'll put a new drive in and the only thing I'll have lost is old backups (locally, anyways).

## Software

The HC2 has wide support for Linux, including an [Ubuntu image from ODROID](https://wiki.odroid.com/odroid-xu4/os_images/os_images), [Armbian](https://www.armbian.com/odroid-hc1/), [Arch Linux Arm](https://archlinuxarm.org/platforms/armv7/samsung/odroid-hc2), and [OpenMediaVault](https://www.openmediavault.org/). From these, I decided to go with [OpenMediaVault](https://www.openmediavault.org/) (OMV). OMV is a NAS solution based on (at the time of this writing) Debian 9 (Stretch). It runs services like SSH, FTP, SFTP, SMB/CIFS, NFS, rsync and [many more](https://www.openmediavault.org/features.html). It also features a nice web interface, S.M.A.R.T. monitoring, and a plugin system to enhance functionality (e.g., LDAP, iSCSI, etc...).

Currently, OMV3 is being retired, to be replaced with OMV4. However, OMV4 is still being [tested](https://forum.openmediavault.org/index.php/Thread/23065-Call-for-testers-OMV4-for-ARM-boards/?postID=176131#post176131) for ARM boards. Because of this, you can [install OMV4 one of three ways](https://forum.openmediavault.org/index.php/Thread/22908-OMV4-on-ARM-boards-kind-of-a-how-to/?postID=175107#post175107):

- Install Armbian first, then install OMV on top of Armbian
- Install OMV3, then upgrade to OMV4
- Install the current OMV4 [test image](https://sourceforge.net/projects/openmediavault/files/OMV%204.x%20for%20Single%20Board%20Computers/)

For this install, I chose to use the OMV4 test image.

# Installation

The installation of OMV4 was pretty straight-forward, and there are plenty of guides for the XU4 that apply to the HC1 and HC2 (e.g., [here](https://obihoernchen.net/1235/odroid-xu4-with-openmediavault/), [here](https://magazine.odroid.com/article/build-home-server-storing-large-amount-multimedia-files/), and [here](https://beomagi.blogspot.com/2016/09/odroid-xu4-my-new-nas.html)). You can also use any guide for OMV (e.g., [here](https://wiki.kobol.io/omv/), [here](https://ridwankhan.com/tagged/open-media-vault), and [here](https://thepi.io/how-to-use-your-raspberry-pi-as-a-nas-box/)) and take just the parts you need. I'm going to document what worked for me and what I enabled, but you can enable/disable whatever services you like.

## Writing the MicroSD card

First, download the newest OMV4 image for the XU4/HC1/HC2 from [here](https://sourceforge.net/projects/openmediavault/files/OMV%204.x%20for%20Single%20Board%20Computers/OMV_4_Odroid_XU4_HC1_HC2.img.xz/download). You'll need to extract the .img file from the .xz file, then pipe that through dd to write to your MicroSD card (I'm assuming you're running Linux here).

```
sudo unxz OMV_4_Odroid_XU4_HC1_HC2.img.xz
sudo dd status=progress bs=4M if=OMV_4_Odroid_XU4_HC1_HC2.img of=/dev/sdX
sudo sync
```

## First boot

When you boot the HC2 for the very first time, expect it to take 30 minutes or so. Since this server is headless (i.e., it has no graphics output), you won't have the option to watch a screen to verify its state. Wait for the server to ping, then head to the web interface. By default, the web interface username/password is _admin/openmediavault_.

## Date and time settings

Navigate to _System_, then _Date & Time_, set your timezone, and enable NTP.

{{< img src="20180612_001.png" alt="screenshot" >}}

## Update packages

Navigate to _System_, then _Update Management_. Click _Check_ at the top of the page to check for available updates.

Check the box next to each package, then click _Upgrade_ at the top of the page to update the package(s).

{{< img src="20180612_002.png" alt="screenshot" >}}

Once completed, reboot the HC2 from the menu at the top-right of the page.

## Enable HTTPS

Navigate to _System_, then _Certificates_, then select the _SSL_ tab, click _Add_, then click _Create_. Fill in the information as necessary.

{{< img src="20180612_003.png" alt="screenshot" >}}

Navigate to _System_, then _General Settings_. In the _Secure connection_ section, enable SSL/TLS and select the certificate you created. You will need to open a new tab using HTTPS instead of HTTP.

{{< img src="20180612_004.png" alt="screenshot" >}}

## Change default web admin password

Navigate to _System_, then _General Settings_, then select the _Web Administrator Password_ tab to update the password.

{{< img src="20180612_005.png" alt="screenshot" >}}

## Enable SSH

I do most of my updating and management through Ansible, which requires SSH access.

Navigate to _Services_, then _SSH_, and enable the SSH service. Also, enable _Permit root login_.

{{< img src="20180612_006.png" alt="screenshot" >}}

## Change default root password

By default, the root username/password is _root_/_openmediavault_.

Now that SSH is enabled, you can SSH to the server as root. Upon login, you should be prompted to change root's password

```
ssh root@IP_goes_here
```

Once you've changed the password, logout.

```
exit
```

## Disable SSH for root

Navigate to _Services_, then _SSH_, and disable _Permit root login_.

{{< img src="20180612_007.png" alt="screenshot" >}}

## Add a secondary user

Navigate to _Access Rights Management_, then _User_. Click _Add_, name your user, and set a password.

{{< img src="20180612_008.png" alt="screenshot" >}}

## Enable S.M.A.R.T

Navigate to _Storage_, then _S.M.A.R.T._, then select the _Settings_ tab, and enable S.M.A.R.T. monitoring.

{{< img src="20180612_009.png" alt="screenshot" >}}

Navigate to the Devices tab, select your device and click Edit at the top of the page, then enable S.M.A.R.T. monitoring.

{{< img src="20180612_010.png" alt="screenshot" >}}

# Drive setup

## Physical setup

Navigate to _Storage_, then _Disks_. Select your hard drive (e.g., _/dev/sda_) and click _Wipe_ at the top of the page.

{{< img src="20180612_011.png" alt="screenshot" >}}

## Setup LVM - SKIP THIS STEP

I tried to setup LVM so that I could have one encrypted partition, and one unencrypted partition. I was able to get it working, however, every reboot would break the setup. Specifically, under _Filesystems_, the filesystem would be marked _Missing_ after a reboot. Checking dmesg, I would see the drive was offline with the error _Medium access timeout failure. Offlining disk!_.

```
root@backup01:~# dmesg | grep sda
[ 14.588107] sd 0:0:0:0: [sda] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
[ 14.588119] sd 0:0:0:0: [sda] 4096-byte physical blocks
[ 14.589011] sd 0:0:0:0: [sda] Write Protect is off
[ 14.589025] sd 0:0:0:0: [sda] Mode Sense: 53 00 00 08
[ 14.589455] sd 0:0:0:0: [sda] Disabling FUA
[ 14.589466] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 14.603406] sd 0:0:0:0: [sda] Attached SCSI disk
[ 14.868930] device-mapper: table: 254:0: adding target device sda caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=33553920
[ 14.868939] device-mapper: table: 254:0: adding target device sda caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=33553920
[ 14.870900] device-mapper: table: 254:1: adding target device sda caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=2194476629504
[ 14.870908] device-mapper: table: 254:1: adding target device sda caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=2194476629504
[ 30.572176] sd 0:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD IN 
[ 30.572231] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x85 85 08 0e 00 00 00 01 00 00 00 00 00 00 40 ec 00
[ 45.597301] sd 0:0:0:0: [sda] tag#1 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD IN 
[ 45.597352] sd 0:0:0:0: [sda] tag#1 CDB: opcode=0x88 88 00 00 00 00 00 ff 78 7f 7f 00 00 00 08 00 00
[ 61.612177] sd 0:0:0:0: [sda] tag#1 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD IN 
[ 61.612228] sd 0:0:0:0: [sda] tag#1 CDB: opcode=0x85 85 08 0e 00 00 00 01 00 00 00 00 00 00 40 a1 00
[ 76.637308] sd 0:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD IN 
[ 76.637361] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x88 88 00 00 00 00 00 ff 78 7f 7f 00 00 00 08 00 00
[ 76.786240] sd 0:0:0:0: [sda] tag#0 Medium access timeout failure. Offlining disk!
[ 76.786522] sd 0:0:0:0: [sda] killing request
[ 76.786690] sd 0:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x01 driverbyte=0x00
[ 76.786787] sd 0:0:0:0: [sda] CDB: opcode=0x88 88 00 00 00 00 00 ff 78 7f 7f 00 00 00 08 00 00
[ 76.786834] blk_update_request: I/O error, dev sda, sector 4286087039
[ 76.859645] blk_update_request: I/O error, dev sda, sector 0
[ 1462.638016] blk_update_request: I/O error, dev sda, sector 0
[ 1462.640632] blk_update_request: I/O error, dev sda, sector 0
[ 1462.655726] blk_update_request: I/O error, dev sda, sector 0
[ 1462.674249] blk_update_request: I/O error, dev sda, sector 0
[ 1462.678512] blk_update_request: I/O error, dev sda, sector 0
[ 1462.697718] blk_update_request: I/O error, dev sda, sector 0
[ 2675.814067] blk_update_request: I/O error, dev sda, sector 0
[ 2698.300818] blk_update_request: I/O error, dev sda, sector 0
```

I could verify this by checking the file below.

```
cat /sys/block/sda/device/state
```

The only way to bring the device back online was to echo _running_ to that file. In fact, this is the official "fix" according to [RedHat](https://access.redhat.com/solutions/1283543).

```
echo running > /sys/block/sda/device/state
```

Upon reboot, the device would go offline again. Because of this, I recommend skipping the LVM setup and moving straight onto creating one large filesystem.

~~Instead of having shares that are at a fixed size, I'm going to use [Logical Volume Manager](https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)) (LVM) to create smaller volumes that I can extend/shrink as needed. If you want to skip this setup, you can move on to _Format and mount volumes_.~~

~~Navigate to _System_, then _Plugins_. From the search box, search for _lvm_. Select _openmediavault-lvm2_ and click _Install_ at the top of the page.~~

~~For LVM to work, we need to create three types of groups~~

- ~~a physical volume~~
- ~~a volume group~~
- ~~one or more logical volumes~~

~~Navigate to _Storage_, then _Logical Volume Management_.~~

~~Navigate to the _Physical volumes_ tab, click _Add_, and select your primary drive.~~

~~Navigate to the _Volume groups_ tab, click _Add_, name your volume group, and select the physical volume you just created.~~

~~Navigate to the _Logical volumes_ tab, click _Add_, name your logical volume, select the volume group you just created, and choose a partition size.~~

## Format and mount volumes

Navigate to _Storage_, then _File System_, then click _Create_. Select the logical volume you just created, then choose a name and filesystem type (I'm using [XFS](https://en.wikipedia.org/wiki/XFS)).

{{< img src="20180612_017.png" alt="screenshot" >}}

Once the filesystem is created, select your new filesystem and click _Mount_ at the top of the page.

{{< img src="20180612_018.png" alt="screenshot" >}}

## Create shared folder

Navigate to _Access Rights Management_, then _Shared Folders_. Click _Add_, name your folder, and select the filesystem we created earlier.

{{< img src="20180612_019.png" alt="screenshot" >}}

## Enable SMB/CIFS

I have Windows, Linux, and Mac clients on my network. Because of this, I'm choosing to use [Server Message Block](https://en.wikipedia.org/wiki/Server_Message_Block) (SMB) to share files.

Navigate to _Services_, then _SMB/CIFS_. On the _Settings_ tab, enable the SMB service.

{{< img src="20180612_020.png" alt="screenshot" >}}

Navigate to the _Shares_ tab, click _Add_, then enable the share and select the shared folder we created earlier.

{{< img src="20180612_021.png" alt="screenshot" >}}

## Grant privileges

Navigate to _Access Rights Management_, then _Shared Folders_, select your shared folder, and click _Privileges_. Here, grant _Read/Write_ privileges to the user you created earlier.

{{< img src="20180612_022.png" alt="screenshot" >}}

# Client setup

I won't cover how to setup every single type of client. In this case, Google "[how to connect to smb from YOUR DEVICE HERE](https://www.google.com/search?q=how+to+connect+to+smb+from+)".

# Performance

As you can see below, the performance is close to 1Gbps, which means the HC2 is able to almost saturate the network connection. Because of this, I don't believe any of the tweaks suggested [here](https://obihoernchen.net/1235/odroid-xu4-with-openmediavault/) or [here](https://beomagi.blogspot.com/2016/09/odroid-xu4-my-new-nas.html) apply. Specifically, the CPU governor is set to _ondemand_ by default (shown in the command below) and since we're using XFS, the NTFS tweaks don't apply.

```
sudo grep GOVERNOR /etc/default/openmediavault
```

## Write performance

Here, I'm copying a 1GB file from a Windows 10 laptop to OMV4 over wired ethernet.

{{< img src="20180612_023.png" alt="screenshot" >}}

Here is the same test, but with a 10GB file.

{{< img src="20180612_024.png" alt="screenshot" >}}

## Read performance

Here, I'm copying a 1GB file from a OMV4 to aWindows 10 laptop over wired ethernet.

{{< img src="20180612_025.png" alt="screenshot" >}}

Here is the same test, but with a 10GB file.

{{< img src="20180612_026.png" alt="screenshot" >}}

\-Logan

# Comments

[Old comments from WordPress](/2018/06/odroid-hc2-as-an-entry-level-nas/comments.txt)
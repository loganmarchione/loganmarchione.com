---
title: "OpenWrt upgrade process"
date: "2016-04-28"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_openwrt.svg"
    alt: "featured image"
    relative: false
---

{{< series/openwrt >}}

# Introduction

Typically, when a new version of OpenWrt is released, I completely wipe the router and start over. However, with the recent release of [15.05.1](https://downloads.openwrt.org/), I wanted to perform an in-place upgrade while preserving all of my data.

Before we begin, it's important to understand how the OpenWrt upgrade process works. It's best to quote the [wiki](https://wiki.openwrt.org/doc/howto/generic.sysupgrade#how_the_openwrt_os_upgrade_works) on this one:

> Both the LuCI and sysupgrade upgrade procedures work by saving specified configuration files, **wiping the entire file system**, installing the new version of OpenWrt and then restoring back the saved configuration files. **This means that any parts of the file system that are not specifically saved will be lost.**
> 
> In particular, any manually installed software packages you may have installed after the initial OpenWrt installation have to be reinstalled after an OpenWrt upgrade. That way everything will match, e.g. the updated Linux kernel and any installed kernel modules.
> 
> Any configuration files or data files placed in locations not specifically listed as being preserved below will also be lost in an OpenWrt upgrade. Be sure to check any files you have added or customized from a default OpenWrt install to back up these items before an upgrade.

This is important to note because OpenWrt doesn't automatically preserve everything by default. You'll need to tell OpenWrt which files and directories to preserve in a configuration file.

# Preparation

## Check your release

Start by viewing the _/etc/openwrt\_release_ file to double-check the version you're running. Here, you can see I'm on 15.05.

```
DISTRIB_ID='OpenWrt'
DISTRIB_RELEASE='15.05'
DISTRIB_REVISION='r46767'
DISTRIB_CODENAME='chaos_calmer'
DISTRIB_TARGET='ar71xx/generic'
DISTRIB_DESCRIPTION='OpenWrt Chaos Calmer 15.05'
DISTRIB_TAINTS=''
```

## Backup

I would highly recommend you make a backup of any necessary configuration files. Also, it's important to test your backups before you need them! :)

## Preservation

Next, you'll need to determine what files will be preserved through the upgrade by using the command below.

```
opkg list-changed-conffiles
```

If a file or directory is not in this list, it will not be preserved through the upgrade.

OpenWrt will preserve any files or directories listed in _/lib/upgrade/keep.d/_ (e.g., _/lib/upgrade/keep.d/keep.me_) or _/etc/sysupgrade.conf_. The easiest thing to do is list your needed files or directories in _/etc/sysupgrade.conf_. My file is shown below.

```
## This file contains files and directories that should
## be preserved during an upgrade.

/etc/config/
/etc/crontabs/
/etc/uhttpd.crt
/etc/uhttpd.key
/etc/rc.local
```

You can see that I'm choosing to preserve the entire _/etc/config_ directory, as well as all my crontabs, the certificate and key for LuCI, and my startup file.

# Upgrade

I recommend using the [sysupgrade utility](https://wiki.openwrt.org/doc/techref/sysupgrade), since it's tailor-made for this process.

Start by [downloading](https://downloads.openwrt.org/) the new firmware. For upgrades, always use the firmware that ends in _sysupgrade.bin_, not the _factory.bin_ firmware. In my case, I'm using a [TP-Link Archer C7 v2](/2015/08/openwrt-with-openvpn-server-on-tp-link-archer-c7/#hardware) going from 15.05 to 15.05.1, so I'll be using [this](https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/openwrt-15.05.1-ar71xx-generic-archer-c7-v2-squashfs-sysupgrade.bin) file. Keep in mind, you'll need enough [space in RAM](https://wiki.openwrt.org/doc/howto/generic.sysupgrade#for_sysupgrade-based_upgrades) to download the files.

```
cd /tmp
wget https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/openwrt-15.05.1-ar71xx-generic-archer-c7-v2-squashfs-sysupgrade.bin
```

Next, I highly recommend checking the MD5 sum to make sure the file isn't corrupt.

```
cd /tmp
wget https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/md5sums
md5sum -c md5sums 2> /dev/null | grep OK
```

If the MD5 sum returns OK, you can proceed with the upgrade (the _-v_ flag tells sysupgrade to be verbose.).

```
sysupgrade -v /tmp/openwrt-15.05.1-ar71xx-generic-archer-c7-v2-squashfs-sysupgrade.bin
```

Expect the upgrade to take a few minutes. The router should reboot when completed.

# Verification

Verify you can SSH into your router (assuming you chose to preserve the correct configuration files), then view the _/etc/openwrt\_release_ file to check the new version you're running.

```
DISTRIB_ID='OpenWrt'
DISTRIB_RELEASE='15.05.1'
DISTRIB_REVISION='r48532'
DISTRIB_CODENAME='chaos_calmer'
DISTRIB_TARGET='ar71xx/generic'
DISTRIB_DESCRIPTION='OpenWrt Chaos Calmer 15.05.1'
DISTRIB_TAINTS=''
```

Now, you'll need to re-download all your previously installed packages (this is where that backup list comes in handy).

```
opkg update
opkg list-upgradable
opkg install package1 package2 package3
```

I had to re-enable LuCI, you probably will too.

```
/etc/init.d/uhttpd start
/etc/init.d/uhttpd enable
```

In addition, you'll need to disable any unneeded services again.

```
/etc/init.d/telnet stop
/etc/init.d/telnet disable
```

Let me know how your upgrade went!

\-Logan

# Comments

[Old comments from WordPress](/2016/04/openwrt-upgrade-process/comments.txt)
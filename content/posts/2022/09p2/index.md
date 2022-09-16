---
title: "Adding a ZFS mirror to Proxmox"
date: "2022-09-07"
author: "Logan Marchione"
categories:
  - "oc"
  - "pc-hardware"
  - "zfs"
cover:
    image: "/assets/featured/featured_proxmox.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_deskmini_h470 %}}

# Introduction

In my last post, I [added two Intel D3-S4510 960 SSDs to my ASRock DeskMini H470](/2022/09/adding-data-center-ssds-to-the-deskmini-h470/) running Proxmox. I also upgraded the firmware, as well as ran some basic tests on the drives. In this post, I'll be creating a ZFS mirror and adding it to Proxmox.

# ZFS

:warning: WARNING :warning:

- This was my first time using ZFS
- I am not a ZFS expert
- Don't blindly follow my instructions
- Almost all of my ZFS knowledge came from [this ArsTechnica article](https://arstechnica.com/information-technology/2020/05/zfs-101-understanding-zfs-storage-and-performance/), [Jim Salter's blog](https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/), and [this article](https://bigstep.com/blog/zfs-best-practices-and-caveats).

## Create mirror

Using the GUI, you can create the mirror and add it to Proxmox in one step. However, I'm specifically looking to add one extra thing that is not in the GUI, so I'm using the CLI.

Start by creating the mirror.

```
zpool create -f -o ashift=12 intel_mirror mirror /dev/disk/by-id/xxxxxx /dev/disk/by-id/yyyyyy
```

In the command above, it's important that `ashift` be the correct size (that's why I had to find the sector size [in the last post](/2022/09/adding-data-center-ssds-to-the-deskmini-h470/#identify-disks)). It generally won't hurt if `ashift` is too big, but if it's too small (the default is `9`), there will definitely be some performance impact as the drive will do write amplification to fill a 4096B sector with 512B writes. For most modern SSDs, `ashift=12` is what you *probably* want. Oh, and you can't change this setting without destroying the mirror, so no pressure.

* `ashift=9` (2^9) = 512B sectors
* `ashift=10` (2^10) = 1024B sectors
* `ashift=11` (2^11) = 2048B sectors
* `ashift=12` (2^12) = 4096B sectors
* `ashift=13` (2^13) = 8192B sectors

Here, I'm turning on `compression` and `relatime` (the option that is not in the GUI).

```
zfs set compression=lz4 intel_mirror
zfs set atime=on intel_mirror
zfs set relatime=on intel_mirror
```

Check the status of the mirror and the settings.

```
zpool status
zfs get all intel_mirror | grep 'compression\|atime'

```

## Extras

I didn't cover them here (because everyone's setup might be different), but below were some extra ZFS-related things I had to take care of.

* Setup [email notifications](https://pve.proxmox.com/wiki/ZFS_on_Linux#_configure_e_mail_notification) for ZED (ZFS Event Daemon)
  * Set an email for the root user (`Datacenter-->Permissions-->Users-->root-->Edit`)
  * Ensure the correct email/user is set in `/etc/zfs/zed.d/zed.rc` (you can probably leave `root`)
  * Setup Postfix to send to a SMTP server (e.g., I'm using an [external SMTP server](https://forum.proxmox.com/threads/get-postfix-to-send-notifications-email-externally.59940/))
  * Test email (`echo -e "Subject: Test\n\nThis is a test" | /usr/bin/pvemailforward`)
* Make sure there is a ZFS scrub cronjob (`cat /etc/cron.d/zfsutils-linux`)
* Make sure there is enough RAM for ZFS, as it will use up to 50% of the host's RAM for ARC. You can [change](https://pve.proxmox.com/wiki/ZFS_on_Linux#sysadmin_zfs_limit_memory_usage) how much is used for ARC, but keep in mind that you'll see increased RAM usage when you activate ZFS.

# Proxmox

## Add storage to Proxmox

Add the storage to Proxmox and set the content type to VM images and container root directories.

```
pvesm add zfspool intel_mirror -pool intel_mirror
pvesh set /storage/intel_mirror -content images,rootdir
```

In the GUI, under `Datacenter-->node_name-->Disks-->ZFS`, you should see the mirror.

{{< img src="20220906_001.png" alt="GUI mirror" >}}

Under `Datacenter-->Storage`, you should see the mirror with the correct content types set.

{{< img src="20220906_002.png" alt="GUI storage" >}}

## Migrate VMs/CTs

Shutdown all VMs/CTs that you intend to move to the new storage pool. In the VM `Hardware` menu (or CT `Resources` menu), select the disk, then click on *Disk Action*, then *Move Storage* (you can't move a VM/CT disk to another storage if you have snapshots).

{{< img src="20220906_003.png" alt="move storage" >}}

Then, select the new ZFS mirror.

{{< img src="20220906_004.png" alt="move storage" >}}

By [default](https://pve.proxmox.com/wiki/Storage_Migration), the source disk is added as an "unused disk" for safety. If you don't want this, you can select the *Delete source* box.

For me, an 8GB VM disk took 1 minute to move, and a 55GB VM disk took 8 minutes to move.

# Conclusion

I moved three VMs and am going to give them a few days before moving the rest of my VMs/CTs. So far, so good. :man-shrugging:

I will also experiment with alerting scripts for ZFS and possibly a cronjob to send me the output of `zpool status` and `smartctl -a /dev/sdX` once a month.

\-Logan

---
title: "Adding a ZFS pool to Proxmox"
date: "2022-09-15"
author: "Logan Marchione"
categories:
  - "oc"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_proxmox.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_deskmini_h470 %}}

# Introduction

In my last post, I [added two Intel D3-S4510 960 SSDs to my ASRock DeskMini H470](/2022/09/adding-data-center-ssds-to-the-deskmini-h470/) running Proxmox. I also upgrade the firmware, as well as ran some basic tests on the drives.

## Current configuration and goals

# ZFS

:warning: WARNING :warning:

- This is my first time using ZFS
- I am not a ZFS expert
- Don't blindly follow my instructions
- Almost all of my ZFS knowledge came from [this ArsTechnica article](https://arstechnica.com/information-technology/2020/05/zfs-101-understanding-zfs-storage-and-performance/), [Jim Salter's blog](https://jrs-s.net/), and [this article](https://bigstep.com/blog/zfs-best-practices-and-caveats).

## Create pool

Using the GUI, you can create the pool and add it to Proxmox in one step.

However, I'm specifically looking to add one extra thing that is not in the GUI, so I'm using the CLI. Start by creating the pool.

```
zpool create -f -o ashift=12 intel_mirror mirror /dev/disk/by-id/xxxxxx /dev/disk/by-id/yyyyyy
```

In the command above, it's important that `ashift` be the correct size (that's why we had to find our sector size earlier). It generally won't hurt if it's too big, but if it's too small, you'll defintely have some performance impact as the drive will do write amplification to fill a 4096B sector with 512B writes. For most modern SSDs, `ashift=12` is what you want. Oh, and you can't change this setting without destroying the pool, so no pressure.

* `ashift=9` (2^9) = 512B sectors
* `ashift=10` (2^10) = 1024B sectors
* `ashift=11` (2^11) = 2048B sectors
* `ashift=12` (2^12) = 4096B sectors
* `ashift=13` (2^13) = 8192B sectors

Here, I'm turning on `compression` and `relatime` (the option that is not in the GUI).

```
zfs set compression=lz4 intel_mirror
zfs set relatime=on intel_mirror
```

Check the status of the pool.

```
zpool status
```

Finally, add the storage to Proxmox.

```
pvesm add zfspool intel_mirror -pool intel_mirror
```

## Migrate VMs/CTs

Shutdown all VMs/CTs

Note that you can't move a VM/CT disk to another location if you have snapshots.

## Current state

# Conclusion

\-Logan

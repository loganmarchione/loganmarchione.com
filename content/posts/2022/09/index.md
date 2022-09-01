---
title: "Adding data center SSDs to the DeskMini H470"
date: "2022-09-01"
author: "Logan Marchione"
categories:
  - "oc"
  - "cloud-internet"
  - "external"
cover:
    image: "/assets/featured/featured_generic_storage.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_deskmini_h470 %}}

# Introduction

## Current configuration and goals

Currently, my only storage in the DeskMini H470 is a single [Samsung 970 Pro 512GB NVMe SSD](https://semiconductor.samsung.com/consumer-storage/internal-ssd/970pro/).

{{< img src="20220901_001.jpg" alt="samsung 970 pro" >}}

By [default](https://pve.proxmox.com/wiki/Installation), Proxmox uses 25% of the disk for root storage, 12.5% of the disk for swap (max 8GB), then the rest for LVM storage (mainly for VMs/CTs). Below is my current partition layout. Note that backups, ISOs, and container templates are stored on a physically separate NAS, so their storage is not taken into account here.

```
nvme0n1                      259:0    0 476.9G  0 disk 
├─nvme0n1p1                  259:1    0  1007K  0 part 
├─nvme0n1p2                  259:2    0   512M  0 part /boot/efi
└─nvme0n1p3                  259:3    0 476.4G  0 part 
  ├─pve-swap                 253:0    0     8G  0 lvm  [SWAP]
  ├─pve-root                 253:1    0    96G  0 lvm  /
  ├─pve-data_tmeta           253:2    0   3.6G  0 lvm  
  │ └─pve-data-tpool         253:4    0 349.3G  0 lvm  
  │   ├─pve-data             253:5    0 349.3G  1 lvm  
  │   ├─pve-vm--105--disk--0 253:6    0     4M  0 lvm  
  │   ├─pve-vm--105--disk--1 253:7    0    16G  0 lvm  
  │   ├─pve-vm--100--disk--0 253:8    0    55G  0 lvm  
  │   ├─pve-vm--112--disk--0 253:9    0     8G  0 lvm  
  │   ├─pve-vm--101--disk--0 253:10   0     8G  0 lvm  
  │   ├─pve-vm--111--disk--0 253:11   0     8G  0 lvm  
  │   ├─pve-vm--113--disk--0 253:12   0     8G  0 lvm  
  │   ├─pve-vm--102--disk--0 253:13   0     8G  0 lvm  
  │   ├─pve-vm--106--disk--0 253:14   0    65G  0 lvm  
  │   ├─pve-vm--103--disk--0 253:15   0     8G  0 lvm  
  │   ├─pve-vm--104--disk--0 253:16   0     8G  0 lvm  
  │   └─pve-vm--104--disk--1 253:17   0    75G  0 lvm  
  └─pve-data_tdata           253:3    0 349.3G  0 lvm  
    └─pve-data-tpool         253:4    0 349.3G  0 lvm  
      ├─pve-data             253:5    0 349.3G  1 lvm  
      ├─pve-vm--105--disk--0 253:6    0     4M  0 lvm  
      ├─pve-vm--105--disk--1 253:7    0    16G  0 lvm  
      ├─pve-vm--100--disk--0 253:8    0    55G  0 lvm  
      ├─pve-vm--112--disk--0 253:9    0     8G  0 lvm  
      ├─pve-vm--101--disk--0 253:10   0     8G  0 lvm  
      ├─pve-vm--111--disk--0 253:11   0     8G  0 lvm  
      ├─pve-vm--113--disk--0 253:12   0     8G  0 lvm  
      ├─pve-vm--102--disk--0 253:13   0     8G  0 lvm  
      ├─pve-vm--106--disk--0 253:14   0    65G  0 lvm  
      ├─pve-vm--103--disk--0 253:15   0     8G  0 lvm  
      ├─pve-vm--104--disk--0 253:16   0     8G  0 lvm  
      └─pve-vm--104--disk--1 253:17   0    75G  0 lvm  

```

My goal is to install two SSDs into my case, setup a ZFS mirror of the two disks, and then move my VMs/CTs to that storage. This will leave only Proxmox on the 970 Pro.

{{< img src="20220901_002.png" alt="zfs mirror" >}}

Although a ZFS mirror will only be able to write as fast a single disk, it will be able to read as fast as the number of disks in the mirror (i.e., two disks).

# Disks

## Disk selection

The [DeskMini H470](https://www.asrock.com/nettop/Intel/DeskMini%20H470%20Series/index.asp#Specification) has the following storage options:

- 2x SATA 6Gb 2.5-inch 7mm/9.5mm
- 1x M.2 Socket 2280 PCIe Gen3 (my NVMe SSD is installed here)
- 1x M.2 Socket 2280 PCIe Gen4 (requires 11th Gen Intel CPU)

Without having to reinstall Proxmox, the easiest way to add storage was to add 2x SATA SSDs.

I spent way too much time deciding on SSDs. I knew I wanted enterprise-grade SSDs, which have power-loss protection and are generally rated for more writes than consumer SSDs. However, enterprise-grade SSDs are hard to find new on sale to the general public. Although I did look on eBay, I wanted the warranty that came with a new drive. Below were my options (for comparision, I added the 970 Pro to the list).

| Make    | Model                                                                                                                                     | Year introduced  | NAND type             | IOPS (4K read) | IOPS (4K write) | Mean Time Between Failures (MTBF) | Endurance Rating (Lifetime Writes) | Price                                                                                                                                                                                                                   |
|---------|-------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|----------------|-----------------|-----------------------------------|------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Intel   | [D3-S4510 960GB](https://ark.intel.com/content/www/us/en/ark/products/134912/intel-ssd-d3s4510-series-960gb-2-5in-sata-6gbs-3d2-tlc.html) | Q3'18            | 64-layer TLC 3D NAND  | 95k            | 36k             | 2 million hours                   | 3.5 PBW                            | [$265 @ Newegg](https://www.newegg.com/intel-d3-s4510-960gb/p/0D9-002V-003V6?Item=0D9-002V-003V6), [$261 @ B&H](https://www.bhphotovideo.com/c/product/1466176-REG/intel_ssdsc2kb960g801_s4510_960gb_internal_ssd.html) |
| Intel   | [D3-S4610 960GB](https://ark.intel.com/content/www/us/en/ark/products/134917/intel-ssd-d3s4610-series-960gb-2-5in-sata-6gbs-3d2-tlc.html) | Q3'18            | 64-layer TLC 3D NAND  | 96k            | 51k             | 2 million hours                   | 5.8 PBW                            | [$351 @ Insight](https://www.insight.com/en_US/shop/product/SSDSC2KG960G801/INTEL/SSDSC2KG960G801/Intel-SolidState-Drive-D3S4610-Series--SSD--960-GB--SATA-6Gbs/)                                                       |
| Intel   | [D3-S4520 960GB](https://ark.intel.com/content/www/us/en/ark/products/208143/intel-ssd-d3s4520-series-960gb-2-5in-sata-6gbs-3d4-tlc.html) | Q3'21            | 144-layer TLC 3D NAND | 90k            | 43k             | 2 million hours                   | 5.3 PBW                            | [$285 @ Insight](https://www.insight.com/en_US/shop/product/SSDSC2KB960GZ01/INTEL/SSDSC2KB960GZ01/Intel-SolidState-Drive-D3S4520-Series--SSD--960-GB--SATA-6Gbs/)                                                       |
| Samsung | [PM893 960GB](https://semiconductor.samsung.com/ssd/datacenter-ssd/pm893/mz7l3960hcjr-00a07/)                                             | Q1'21            | 128-layer TLC V-NAND  | 98k            | 30k             | 2 million hours                   | 1.752 PBW                          | [$171 @ SuperMicro](https://store.supermicro.com/960gb-sata-hds-s2t0-mz7l3960hcjra7.html), [$218 @ CDW](https://www.cdw.com/product/samsung-pm893-960gb-2.5-sata-6gbps-solid-state-drive/6763102)                       |
| Samsung | [970 Pro 512GB](https://semiconductor.samsung.com/consumer-storage/internal-ssd/970pro/)                                                  | Q3'18            | 64-layer MLC V-NAND   | 370k           | 500k            | 1.5 million hours                 | 0.6 PBW                            | $149 (at time of purchase in 2021)                                                                                                                                                                                      |

In the end, I ended up choosing the Intel D3-S4510 960GB. It came recommended on Reddit, and I wasn't 100% sure if Insight was selling new drives or not (again, conflicting reports on Reddit.

## Physical installation

The physical installation was easy enough, though I did need to remove the motherboard from the tray to access the screws. ASRock uses a propriety SATA cable for these ultra-tiny connectors.


## Identify disks

Start by identifying your disks. We are looking for the disk ID, as well as the sector size (this will be important later on).

Legacy HDDs used 512B sectors, but SSDs (because they're flash-based) don't really have "sectors". Instead, they try to translate their storage layout into something the operating system can understand. As such, they typically report that they have 512B sectors, but most SSDs actually use 4096B sectors (or larger). It's important to attempt to find your sector size, and do research on your SSD online, but remember, **the SSD will lie to you**.

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

---
title: "Moving Proxmox VMs/CTs to a separate ZFS pool"
date: "2022-10-01"
author: "Logan Marchione"
categories:
  - "oc"
  - "cloud-internet"
  - "external"
cover:
    image: "/assets/featured/featured_proxmox.svg"
    alt: "featured image"
    relative: false
---

# Introduction

## Current configuration and goals

Right now, my only storage in the DeskMini H470 is a single [Samsung 970 Pro 512GB NVMe SSD](https://semiconductor.samsung.com/consumer-storage/internal-ssd/970pro/).

{{< img src="20220830_001.jpg" alt="samsung 970 pro" >}}

By [default](https://pve.proxmox.com/wiki/Installation), Proxmox uses 25% of the disk for root storage, 12.5% of the disk for swap (max 8GB), then the rest for LVM storage (mainly for VMs/CTs). Below is my current partition layout. I will mention that backups, ISOs, and container templates are stored on a physically separate NAS.

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

My goal is to install two SSDs into my case, setup a ZFS mirror of the two disks, and then move my VMs/CTs to that storage.

{{< img src="20220830_002.png" alt="zfs mirror" >}}

# Disks

## Disk selection

The [DeskMini H470](https://www.asrock.com/nettop/Intel/DeskMini%20H470%20Series/index.asp#Specification) has the following storage options:

- 2x SATA 6Gb 2.5-inch 7mm/9.5mm
- 1x Ultra M.2 Socket 2280 PCIe Gen3 (my NVMe SSD is installed here)
- 1x Hyper M.2 Socket 2280 PCIe Gen4 (requires 11th Gen Intel CPU)

Without having to reinstall Proxmox, the easiest way to add storage was to add 2x SATA SSDs.

I spent way too much time deciding on SSDs. I knew I wanted enterprise-grade SSDs, which have power-loss protection and are generally rated for more writes than consumer SSDs. However, enterprise-grade SSDs are hard to find new on sale to the general public. Although I did look on eBay, I wanted the warranty that came with a new drive. Below were my options (for comparision, I added the 970 Pro to the list).

| Make    | Model                                                                                                                                     | Year introduced  | NAND type             | IOPS (4K read) | IOPS (4K write) | Mean Time Between Failures (MTBF) | Endurance Rating (Lifetime Writes) | Price                                                                                                                                                                                                                   |
|---------|-------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|----------------|-----------------|-----------------------------------|------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Intel   | [D3-S4510 960GB](https://ark.intel.com/content/www/us/en/ark/products/134912/intel-ssd-d3s4510-series-960gb-2-5in-sata-6gbs-3d2-tlc.html) | Q3'18            | 64-layer TLC 3D NAND  | 95k            | 36k             | 2 million hours                   | 3.5 PBW                            | [$265 @ Newegg](https://www.newegg.com/intel-d3-s4510-960gb/p/0D9-002V-003V6?Item=0D9-002V-003V6), [$261 @ B&H](https://www.bhphotovideo.com/c/product/1466176-REG/intel_ssdsc2kb960g801_s4510_960gb_internal_ssd.html) |
| Intel   | [D3-S4610 960GB](https://ark.intel.com/content/www/us/en/ark/products/134917/intel-ssd-d3s4610-series-960gb-2-5in-sata-6gbs-3d2-tlc.html) | Q3'18            | 64-layer TLC 3D NAND  | 96k            | 51k             | 2 million hours                   | 5.8 PBW                            | [$351 @ Insight](https://www.insight.com/en_US/shop/product/SSDSC2KG960G801/INTEL/SSDSC2KG960G801/Intel-SolidState-Drive-D3S4610-Series--SSD--960-GB--SATA-6Gbs/)                                                       |
| Intel   | [D3-S4520 960GB](https://ark.intel.com/content/www/us/en/ark/products/208143/intel-ssd-d3s4520-series-960gb-2-5in-sata-6gbs-3d4-tlc.html) | Q3'21            | 144-layer TLC 3D NAND | 90k            | 43k             | 2 million hours                   | 5.3 PBW                            | [$285 @ Insight](https://www.insight.com/en_US/shop/product/SSDSC2KB960GZ01/INTEL/SSDSC2KB960GZ01/Intel-SolidState-Drive-D3S4520-Series--SSD--960-GB--SATA-6Gbs/)                                                       |
| Samsung | [PM893 960GB](https://semiconductor.samsung.com/ssd/datacenter-ssd/pm893/mz7l3960hcjr-00a07/)                                             | Q1'21            | 128-layer TLC V-NAND  | 98k            | 30k             | 2 million hours                   | 1.752 PBW                          | [$171 @ SuperMicro](https://store.supermicro.com/960gb-sata-hds-s2t0-mz7l3960hcjra7.html), [$218 @ CDW](https://www.cdw.com/product/samsung-pm893-960gb-2.5-sata-6gbps-solid-state-drive/6763102)                       |
| Samsung | [970 Pro 512GB](https://semiconductor.samsung.com/consumer-storage/internal-ssd/970pro/)                                                  | Q3'18            | 64-layer MLC V-NAND   | 370k           | 500k            | 1.5 million hours                 | 0.6 PBW                            | $149 (at time of purchase in 2021)                                                                                                                                                                                      |

In the end, I ended up choosing the Intel D3-S4510 960GB. It came recommended on Reddit, and I wasn't 100% if Insight was selling new drives or not (again, conflicting reports on Reddit.

## Physical installation

# ZFS

:warning: WARNING :warning:

- This is my first time using ZFS
- I am not a ZFS expert
- Don't blindly follow my instructions

## Create pool

## Migrate VMs/CTs

Shutdown all VMs/CTs

Note that you can't move a VM/CT disk to another location if you have snapshots.

## Current state

# Conclusion

\-Logan

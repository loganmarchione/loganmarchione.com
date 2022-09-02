---
title: "Adding data center SSDs to the DeskMini H470"
date: "2022-09-02"
author: "Logan Marchione"
categories:
  - "oc"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_generic_storage.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_deskmini_h470 %}}

# Introduction

Last year, I [setup the ASRock DeskMini H470 as a compact hypervisor](/2021/06/asrock-deskmini-h470-as-a-compact-hypervisor/) running Proxmox. During setup, I only installed a single NVMe SSD. However, I specifically chose the DeskMini H470 because it had space for more drives, which I knew I would eventually want to make use of. Today is that day.

## Current configuration

The [DeskMini H470](https://www.asrock.com/nettop/Intel/DeskMini%20H470%20Series/index.asp#Specification) has the following storage options:

- 2x SATA 6Gb 2.5-inch 7mm/9.5mm
- 1x M.2 Socket 2280 PCIe Gen3 (my NVMe SSD is installed here)
- 1x M.2 Socket 2280 PCIe Gen4 (requires an 11th Gen Intel CPU, which I don't have)

Currently, my only storage in the DeskMini H470 is a single [Samsung 970 Pro 512GB NVMe SSD](https://semiconductor.samsung.com/consumer-storage/internal-ssd/970pro/).

{{< img src="20220901_001.jpg" alt="samsung 970 pro" >}}

By [default](https://pve.proxmox.com/wiki/Installation), Proxmox uses 25% of the disk for root storage, 12.5% of the disk for swap (max 8GB), then the rest for LVM storage (mainly for VMs/CTs). Below is my current partition layout. Note that backups, ISOs, and container templates are stored on a physically separate NAS, so their storage is not taken into account here.

```
NAME                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
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

## Goals

Without having to reinstall Proxmox, the easiest way to add storage was to add 2x SATA SSDs. My goals were to:

1. Install two SSDs into my case
1. Verify the SSDs work, firmware is up to date, etc...
1. Setup a ZFS mirror of the two disks
1. Move my VMs/CTs to that storage (this will leave only Proxmox on the 970 Pro)

{{< img src="20220901_002.png" alt="zfs mirror" >}}

I'll be covering the former two steps in this post, and the latter in another.

# Disks

## Disk selection

I spent way too much time deciding on SSDs. I knew I wanted enterprise-grade SSDs, which have power-loss protection and are generally rated for more writes than consumer SSDs. However, enterprise-grade SSDs are hard to find new on sale to the general public. Although I did look on eBay, I wanted the warranty that came with a new drive. Below were my options (for comparision, I added the 970 Pro to the list).

| Make    | Model                                                                                                                                     | Year introduced  | NAND type             | IOPS (4K read) | IOPS (4K write) | Mean Time Between Failures (MTBF) | Endurance Rating (Lifetime Writes) | Price                                                                                                                                                                                                                   |
|---------|-------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------|----------------|-----------------|-----------------------------------|------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Intel   | [D3-S4510 960GB](https://ark.intel.com/content/www/us/en/ark/products/134912/intel-ssd-d3s4510-series-960gb-2-5in-sata-6gbs-3d2-tlc.html) | Q3'18            | 64-layer TLC 3D NAND  | 95k            | 36k             | 2 million hours                   | 3.5 PBW                            | [$265 @ Newegg](https://www.newegg.com/intel-d3-s4510-960gb/p/0D9-002V-003V6?Item=0D9-002V-003V6), [$261 @ B&H](https://www.bhphotovideo.com/c/product/1466176-REG/intel_ssdsc2kb960g801_s4510_960gb_internal_ssd.html) |
| Intel   | [D3-S4610 960GB](https://ark.intel.com/content/www/us/en/ark/products/134917/intel-ssd-d3s4610-series-960gb-2-5in-sata-6gbs-3d2-tlc.html) | Q3'18            | 64-layer TLC 3D NAND  | 96k            | 51k             | 2 million hours                   | 5.8 PBW                            | [$351 @ Insight](https://www.insight.com/en_US/shop/product/SSDSC2KG960G801/INTEL/SSDSC2KG960G801/Intel-SolidState-Drive-D3S4610-Series--SSD--960-GB--SATA-6Gbs/)                                                       |
| Intel   | [D3-S4520 960GB](https://ark.intel.com/content/www/us/en/ark/products/208143/intel-ssd-d3s4520-series-960gb-2-5in-sata-6gbs-3d4-tlc.html) | Q3'21            | 144-layer TLC 3D NAND | 90k            | 43k             | 2 million hours                   | 5.3 PBW                            | [$285 @ Insight](https://www.insight.com/en_US/shop/product/SSDSC2KB960GZ01/INTEL/SSDSC2KB960GZ01/Intel-SolidState-Drive-D3S4520-Series--SSD--960-GB--SATA-6Gbs/)                                                       |
| Samsung | [PM893 960GB](https://semiconductor.samsung.com/ssd/datacenter-ssd/pm893/mz7l3960hcjr-00a07/)                                             | Q1'21            | 128-layer TLC V-NAND  | 98k            | 30k             | 2 million hours                   | 1.752 PBW                          | [$171 @ SuperMicro](https://store.supermicro.com/960gb-sata-hds-s2t0-mz7l3960hcjra7.html), [$218 @ CDW](https://www.cdw.com/product/samsung-pm893-960gb-2.5-sata-6gbps-solid-state-drive/6763102)                       |
| Samsung | [970 Pro 512GB](https://semiconductor.samsung.com/consumer-storage/internal-ssd/970pro/)                                                  | Q3'18            | 64-layer MLC V-NAND   | 370k           | 500k            | 1.5 million hours                 | 0.6 PBW                            | $149 (at time of purchase in 2021)                                                                                                                                                                                      |

In the end, I ended up choosing the Intel D3-S4510 960GB, as it came recommended on multiple forums. I would have preferred the D3-S4610 960GB (since it's more write-intensive), but I wasn't 100% sure if Insight was selling new drives or not (conflicting reports on Reddit).

## Physical installation

The physical installation was easy enough, although I did need to remove the motherboard from the tray to access the screws. Also, ASRock uses a propriety SATA cable for these ultra-tiny connectors.

{{< img src="20220902_001.jpeg" alt="intel ssd installation" >}}

{{< img src="20220902_002.jpeg" alt="intel ssd installation" >}}

{{< img src="20220902_003.jpeg" alt="intel ssd installation" >}}

{{< img src="20220902_004.jpeg" alt="intel ssd installation" >}}

## Identify disks

The basic smoke test was to make sure the disks worked and showed up to the kernel. I ran `lshw -class disk`, but you could also use `hwinfo --disk` to see similiar info.

```
root@proxmox02:~# lshw -class disk
  *-disk:0                  
       description: ATA Disk
       product: INTEL SSDSC2KB96
       physical id: 0
       bus info: scsi@2:0.0.0
       logical name: /dev/sda
       version: 0132
       serial: XXXXXXXXXXXXXXXXXX
       size: 894GiB (960GB)
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=4096
  *-disk:1
       description: ATA Disk
       product: INTEL SSDSC2KB96
       physical id: 1
       bus info: scsi@3:0.0.0
       logical name: /dev/sdb
       version: 0132
       serial: XXXXXXXXXXXXXXXXXX
       size: 894GiB (960GB)
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=4096
```

## Firmware

In 2018, Intel [identified a bug](https://www.intel.com/content/www/us/en/download/19412/28673/intel-ssd-s4510-s4610-2-5-material.html?) in the 1.92TB and 3.84TB models that caused the SSDs to "hang" after 1700 hours of power-on time. Even though my drives were not affected, I wanted to make sure the firmware was up-to-date.

### LVFS

I tried using LVFS, but Intel/Solidigm don't seem to be contributing a ton of firmware files (compared to [vendors](https://fwupd.org/lvfs/vendors/) like Dell and Lenovo).

```
sudo apt -y install fwupd
fwupdmgr get-devices
fwupdmgr get-updates
```

I kept receiving this.

```
No updatable devices
```

### Solidigm Storage Tool

Intel [sold their NAND flash business to SK Hynix (under the name Solidigm)](https://www.intel.com/content/www/us/en/support/articles/000060218/memory-and-storage.html) in November 2020, so I used the [Solidigm Storage Tool](https://www.intel.com/content/www/us/en/download/715595/solidigm-storage-tool-intel-branded-nand-ssds.html) to update the firmware.

I followed [this guide](https://downloadmirror.intel.com/735799/SST-CLI-Install-Guide-727325-003US.pdf) to install the tool and [this guide](https://downloadmirror.intel.com/735799/SST-CLI-User-Guide-Public-727329-003US.pdf) to use it. The firmware is built into the tool, so there are no external downloads.

I started by identifying my SSDs (my 970 Pro was SSD `0` in this case).

```
sst show -ssd
sst show -ssd 1
sst show -ssd 2
```

From the output above, I was able to see the firmware on each device was out of date.

```
Firmware : XCV10132
FirmwareUpdateAvailable : XCV10140
```

I checked a few sensors and SMART data to make sure the drives were healthy.

```
sst show -sensor -ssd 1
sst show -sensor -ssd 2
sst show -smart -ssd 1
sst show -smart -ssd 2
```

Then, I finally updated the firmware.

```
sst load -ssd 1
```

Once successful, I saw the message below, repeated with the second drive, then rebooted.

```
Status : Firmware updated successfully. Please reboot the system.
```

Now, checking the status, I could see the firmware was up-to-date.

```
Firmware : XCV10140
FirmwareUpdateAvailable : The selected drive contains current firmware as of this tool release.
```

I also kicked off SMART tests to double-check the drives.

```
sudo smartctl -t long /dev/sda
sudo smartctl -t long /dev/sdb
```

# Conclusion

That's it for now. Below is my new current configuation (see the two drives at the top). In my next post, I'll be setting up a ZFS pool and moving my VMs/CTs to that storage.

```
NAME                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                            8:0    0 894.3G  0 disk 
sdb                            8:16   0 894.3G  0 disk 
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
  │   └─pve-vm--104--disk--0 253:16   0     8G  0 lvm  
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
      └─pve-vm--104--disk--0 253:16   0     8G  0 lvm
```

\-Logan
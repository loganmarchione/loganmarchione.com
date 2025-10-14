---
title: "Linux (more specifically, Proxmox Backup Server) on the OPNsense DEC740"
date: "2025-10-31"
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

# Introduction

I know I'm about five years too late too the party, but I finally setup [Proxmox Backup Server (PBS)](https://www.proxmox.com/en/products/proxmox-backup-server/overview).

Right now, I have 10 servers inside my Proxmox Virtual Environment (VE) setup, made up of a mix of virtual machines (VMs) and LXC containers (LXCs). I'm using the [built-in Proxmox VE backup system](https://pve.proxmox.com/wiki/Backup_and_Restore) to backup my VMs/LXCs to my NAS. This results in about 250GB of backups, which happen once a week. I keep 12 weeks of backups, so that's 3TB of backups on my NAS. Even if nothing changes week-to-week on a single server, the entire machine is getting backed up every week, taking up the full amount of space.

Proxmox Backup Server is a separate backup solution that has a [ton of features](https://www.proxmox.com/en/products/proxmox-backup-server/features):

- designed specifically to work with Proxmox VE
- open-source
- written in Rust (so it's memory safe)
- free (as in freedom and beer), though they do have a [paid support plan](https://www.proxmox.com/en/products/proxmox-backup-server/pricing) (but I'm unsure why it's so much more expensive than [the Proxmox VE support plan](https://www.proxmox.com/en/products/proxmox-virtual-environment/pricing))
- incremental backups
- deduplication
- compression
- encryption
- checksums
- granular restores (e.g., single files from a machine)

The big selling points here are incremental backups and deduplication. Incremental, meaning that there is a single, large, initial backup for each machine, and then each subsequent backup only backs up the changed files. Deduplication, meaning that files that are the same across backups are only stored once. Both of these combined can save you a *ton* of space on backups. I've read online that the deduplication ratio can be as high as 50:1 or 100:1 (as in, `ratio = original_data_size / stored_data_size`).

# Hardware

I was looking for the following things in a PBS box:

- small (needs to fit in my [mini-rack](/2021/01/homelab-10-mini-rack/))
- x86 (to run PBS)
- DDR4/DDR5 memory (ECC if possible)
- fanless (one less thing to dust)
- Intel NICs
- M.2 storage

It's easy to find all of that in cheap Chinese mini PCs on Amazon, except ECC support. [Error correcting code (ECC) memory](https://en.wikipedia.org/wiki/ECC_memory) is special memory that has an extra chip on the RAM stick that is used for parity bits to detect and correct bit-flips in memory. It's generally used on servers, and hardly ever used on consumer PCs (especially mini PCs). I was also trying to find something that was from a relatively well-known manufacturer that wouldn't burn my house down. The Chinese mini PCs worry me, because they're all no-name brands that disappear from Amazon after a few months (or provide no support if they don't disappear).

## Comparison

I must have looked at hundreds or thousands of mini PCs on obscure industrial and electronics distributor websites. Below are the devices that I found in my searching.

| Make/Model                                                                                                                                                | Specific model number   | CPU                                    | RAM                                    | ECC  | Storage                                    | NICs                                | Price (main unit only) | Comments                                          |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------|----------------------------------------|----------------------------------------|------|--------------------------------------------|-------------------------------------|------------------------|---------------------------------------------------|
| [ASRock iBOX-250J](https://www.asrockind.com/en-gb/iBOX-250J)                                                                                             | N/A                     | Intel J6412 (4c/4t, 10W)               | 2x DDR4-3200 SO-DIMM slots (max 32GB)  | No   | 1x M.2 2280 NVMe PCIe Gen3 x1, 1x 2.5" bay | 2x Intel i225V                      |                        | Seems impossible to buy as an individual          |
| [ASRock iBOX-260J](https://www.asrockind.com/en-gb/iBOX-260J)                                                                                             | N/A                     | Intel N97 (4c/4t, 12W)                 | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1, 1x 2.5" bay | 1x Intel i210AT, 1x Intel i226V     |                        | Seems impossible to buy as an individual          |
| [Shuttle DL30N](https://global.shuttle.com/products/productsDetail?pn=DL30N%20SERIES&c=xpc-fanless)                                                       | N/A                     | Intel N100/N200/N300                   | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2, 1x 2.5" bay | 2x Intel i226LM                     | ~$500                  |                                                   |
| [Jetway FBU03](https://jetwaycomputer.com/FBU03.html)                                                                                                     | HBFBU03-6412-B          | Intel J6412 (4c/4t, 10W)               | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2              | 2x Intel i225V                      | ~$299                  |                                                   |
| [Jetway BFTADN1](https://jetwaycomputer.com/BFTADN1.html)                                                                                                 | BFTADN1-N97-N           | Intel N97 (4c/4t, 12W)                 | 1x DDR5-4800 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2              | 2x Intel i225V                      | ~$550                  |                                                   |
| [GIGAIPC QBiX-EHLA6412-A1](https://www.gigaipc.com/en/products-detail/QBiX-EHLA6412-A1/)                                                                  | N/A                     | Intel J6412 (4c/4t, 10W)               | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2              | 1x Intel i211AT                     | ~$300                  |                                                   |
| [GIGAIPC QBiX-ADNAN97-A1](https://www.gigaipc.com/en/products-detail/QBiX-ADNAN97-A1/)                                                                    | N/A                     | Intel N97 (4c/4t, 12W)                 | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Realtek RTL8111H 👎              | ~$350                  | So close, but Realtek NICs                        |
| [SuperMicro SYS-E100-14AM-E](https://www.supermicro.com/en/products/system/iot/box_pc/sys-e100-14am-e)                                                    | N/A                     | Intel x7433RE (4c/4t, 9W)              | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i226IT                     | ~$500                  |                                                   |
| [SuperMicro SYS-E100-14AM-H](https://www.supermicro.com/en/products/system/iot/box_pc/sys-e100-14am-h)                                                    | N/A                     | Intel x7835RE (8c/8t, 12W)             | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i226IT                     | ~$500                  |                                                   |
| [SuperMicro SYS-E100-14AM-L](https://www.supermicro.com/en/products/system/iot/fanless%20embedded/sys-e100-14am-l)                                        | N/A                     | Intel N97 (4c/4t, 12W)                 | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i226IT                     | ~$500                  |                                                   |

## Purchase

I once again found myself purchasing a second [OPNsense DEC740](https://shop.opnsense.com/product/dec740-opnsense-desktop-security-appliance/) ([the last one was for my pfSense router](/2025/03/pfsense-on-the-opnsense-dec740/)). I would love to find out who OEMs these for OPNsense so I could purchase 10 of them (without OPNsense installed). I really love these little boxes, I just wish they weren't so expensive 😅.

{{< img src="20250215_002.jpg" alt="dec740" >}}

I also picked up two upgrades:

- a stick of 16GB DDR4 ECC UDIMM VLP (specifically model number MTA18ADF2G72AZ-2G6 from [Memory.net](https://memory.net/product/mta18adf2g72az-2g6-micron-1x-16gb-ddr4-2666-ecc-udimm-pc4-21300v-e-dual-rank-x8-module/)) for $84
- an industrial-grade 2TB NVMe SSD (specifically model number OM8SGP42048K2-A00 from [Mouser.com](https://www.mouser.com/ProductDetail/Kingston/OM8SGP42048K2-A00?qs=%252BICfH0Hx1eSIkRKcGCyUfA%3D%3D)) for $229

You can see my post [here](/2025/03/pfsense-on-the-opnsense-dec740/#ecc-ram-upgrade) on what the inside of the DEC740 looks like, so I won't re-hash that.

# Pre-installation

## Console settings

The serial adapter shows up as `Exar Corp. XR21B1411 UART` in Linux, and I verifed it connected to `/dev/ttyUSB0` to by using `sudo dmesg | grep tty`. I tried to use `screen` to connect to it, but after a while, the characters on the screen would get misaligned and impossible to read.

```
screen /dev/ttyUSB0 115200
```

I ended up using [tio](https://github.com/tio/tio), which worked great.

```
tio /dev/ttyUSB0
```

This was the BIOS that shipped with the DEC740. According to [this page](https://docs.opnsense.org/hardware/bios.html), it's up-to-date.

```
BIOS Version : 05.38.26.0025-A10.33
BIOS Build Date : 03/05/2025
Processor Type : AMD Ryzen Embedded V1500B
System Memory Speed : 2400 MHz
```

At boot, you can press `ESC` once to enter the BIOS "Front Page" (you need to very quick with this first `ESC`).

```
                                                           Front Page
  Front Page
/-------------------------------------------------------------------------------------+----------------------------------------\
|Continue                                                                             |This selection will direct the system   |
|>Boot Manager                                                                        |to continue to booting process          |
|>Device Management                                                                   |                                        |
|>Boot From File                                                                      |                                        |
|>Administer Secure Boot                                                              |                                        |
|>Setup Utility                                                                       |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
\-------------------------------------------------------------------------------------+----------------------------------------/
 F1  Help                                                       Enter Select > SubMenu
 ^/v Select Item
```

## BIOS settings

### Enable ECC

At the Front Page, go to `Setup Utility`, then `AMD CBS`, then `UMC Common Options`, then `DDR4 Common Options`, then `Common RAS`, then `ECC Configuration`. Then, set the `DRAM ECC Enable` to `Enabled`.

```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
                                                  AMD CBS
/-------------------------------------------------------------------------------------+----------------------------------------\
|ECC Configuration                                                                    |Use this option to enable / disable     |
|                                                                                     |DRAM ECC. Auto will set ECC to enable.  |
|DRAM ECC Symbol Size                       <x8>                                      |                                        |
|DRAM ECC Enable                            <Auto>                                    |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                      /---------------\              |                                        |
|                                                      |DRAM ECC Enable|              |                                        |
|                                                      |---------------|              |                                        |
|                                                      |Disabled       |              |                                        |
|                                                      |Enabled        |              |                                        |
|                                                      |Auto           |              |                                        |
|                                                      \---------------/              |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
\-------------------------------------------------------------------------------------+----------------------------------------/
 F1  Help                       ^/v Select Item                F5/F6 Change Values            F9  Setup Defaults
 Esc Exit                       </> Select Item                Enter Select > SubMenu         F10 Save and Exit
```

### ECC error injection

At the Front Page, go to `Setup Utility`, then `AMD CBS`, then `UMC Common Options`, then `DDR4 Common Options`, then `Common RAS`. Then, set the `Disable Memory Error Injection` to `False` (since we want to test ECC memory errors).

```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
                                                  AMD CBS
/-------------------------------------------------------------------------------------+----------------------------------------\
|Common RAS                                                                           |True: UMC::CH::MiscCfg[DisErrInj]=1     |
|                                                                                     |                                        |
|Data Poisoning                             <Disabled>                                |                                        |
|>ECC Configuration                                                                   |                                        |
|Disable Memory Error Injection             <True>                                    |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                               /------------------------------\      |                                        |
|                                               |Disable Memory Error Injection|      |                                        |
|                                               |------------------------------|      |                                        |
|                                               |False                         |      |                                        |
|                                               |True                          |      |                                        |
|                                               \------------------------------/      |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
\-------------------------------------------------------------------------------------+----------------------------------------/
 F1  Help                       ^/v Select Item                F5/F6 Change Values            F9  Setup Defaults
 Esc Exit                       </> Select Item                Enter Select > SubMenu         F10 Save and Exit
```

### Console/serial settings

These settings are required to get Linux to boot. If you want to go back to OPNsense at some point, you'll probably need to change these back.

At the Front Page, go to `Setup Utility`, then `AMD CBS`, then `FCH Common Options`, then `Uart Configuration Options`. Then, set the `Uart 0 Legacy Options` to `COM1 0x3F8`.

```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
                                                  AMD CBS
/-------------------------------------------------------------------------------------+----------------------------------------\
|Uart Configuration Options                                                           |No help string                          |
|                                                                                     |                                        |
|Uart 0 Enable                              <Enabled>                                 |                                        |
|Uart 0 Legacy Options                      <Disabled>                                |                                        |
|Uart Driver Type                           <AMD UART Driver>                         |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                   /---------------------\           |                                        |
|                                                   |Uart 0 Legacy Options|           |                                        |
|                                                   |---------------------|           |                                        |
|                                                   |Disabled             |           |                                        |
|                                                   |COM1 0x3F8           |           |                                        |
|                                                   |COM2 0x2F8           |           |                                        |
|                                                   |COM3 0x3E8           |           |                                        |
|                                                   |COM4 0x2E8           |           |                                        |
|                                                   |Auto                 |           |                                        |
|                                                   \---------------------/           |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
\-------------------------------------------------------------------------------------+----------------------------------------/
 F1  Help                       ^/v Select Item                F5/F6 Change Values            F9  Setup Defaults
 Esc Exit                       </> Select Item                Enter Select > SubMenu         F10 Save and Exit
```

On the same screen, set `Uart Driver Type` to `AMD Serial Driver`.

```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
                                                  AMD CBS
/-------------------------------------------------------------------------------------+----------------------------------------\
|Uart Configuration Options                                                           |Select UART driver.                     |
|                                                                                     |AMD UART Driver (HID AMDI0020)          |
|Uart 0 Enable                              <Enabled>                                 |AMD Serial Driver (HID AMDI0021)        |
|Uart 0 Legacy Options                      <COM1 0x3F8>                              |                                        |
|Uart Driver Type                           <AMD UART Driver>                         |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                     /-----------------\             |                                        |
|                                                     |Uart Driver Type |             |                                        |
|                                                     |-----------------|             |                                        |
|                                                     |AMD UART Driver  |             |                                        |
|                                                     |AMD Serial Driver|             |                                        |
|                                                     \-----------------/             |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
\-------------------------------------------------------------------------------------+----------------------------------------/
 F1  Help                       ^/v Select Item                F5/F6 Change Values            F9  Setup Defaults
 Esc Exit                       </> Select Item                Enter Select > SubMenu         F10 Save and Exit
```

TODO remove this?
```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
        Advanced
/-------------------------------------------------------------------------------------+----------------------------------------\
|Console Redirection Setup                                                            |Console Redirection continue works      |
|                                                                                     |after Legacy Boot.                      |
|Console Serial Redirect                    <Enabled>                                 |                                        |
|Terminal Type                              <VT_100>                                  |                                        |
|Baud Rate                                  <115200>                                  |                                        |
|Data Bits                                  <8 Bits>                                  |                                        |
|Parity                                     <None>                                    |                                        |
|Stop Bits                                  <1 Bit>                                   |                                        |
|Flow Control                               <None>                                    |                                        |
|Information Wait Time                      < 5 Seconds>                              |                                        |
|C.R. After Legacy Boot                     <No>                                      |                                        |
|Text Mode Resolution                       <AUTO>                                    |                                        |
|Auto Refresh                               <Disabled>                                |                                        |
|Auto adjust Terminal resolution            <Disabled>                                |                                        |
|                                                   /----------------------\          |                                        |
|>UART0                                             |C.R. After Legacy Boot|          |                                        |
| Enable VT-100,115200,N81                          |----------------------|          |                                        |
|                                                   |Yes                   |          |                                        |
|                                                   |No                    |          |                                        |
|                                                   \----------------------/          |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
|                                                                                     |                                        |
\-------------------------------------------------------------------------------------+----------------------------------------/
 F1  Help                       ^/v Select Item                F5/F6 Change Values            F9  Setup Defaults
 Esc Exit                       </> Select Item                Enter Select > SubMenu         F10 Save and Exit
```

## Memory test

I always test my memory, but since this was ECC memory, I needed a program to test the ECC functionality. Apparently, MemTest86+ (the open-source tool), [doesn't support testing ECC](https://github.com/memtest86plus/memtest86plus/discussions/248) yet. MemTest86 Pro (the closed-source tool) does [support ECC injection](https://www.memtest86.com/ecc.htm), so that's what I went with.

For reference, here is the [MemTest86 Pro configuration file](https://www.memtest86.com/tech_configuring-memtest.html) called `mt86.cfg` that I was using.

```
ECCPOLL=1
ECCINJECT=1
LANG=en-US
AUTOMODE=1
AUTOREPORT=1
AUTOREPORTFMT=HTML
EXITMODE=0
CONSOLEONLY=1
```

At the Front Page, go to `Boot Manager`. I was able to boot from a USB flash drive containing MemTest86 Pro and it started the test right away.

```
/------------------------------------------------------------------------------------------------------------------------------\
|                                                         Boot Manager                                                         |
\------------------------------------------------------------------------------------------------------------------------------/


  Boot Option Menu

  EFI Boot Devices
  EFI USB Device 1 (USB)
  EFI USB Device (USB)
  Internal EFI Shell

  ^ and v to change option, ENTER to select an option, ESC to exit






















/------------------------------------------------------------------------------------------------------------------------------\
| F1  Help                                                      ^/v   Select Item                                              |
| Esc Exit                                                      Enter Select > SubMenu                                         |
\------------------------------------------------------------------------------------------------------------------------------/
```

You will see errors in MemTest86 Pro, since it's injecting ECC errors to test the ECC functionality. I left MemTest86 Pro to run for about 12 hours and came back to this (report below).

[Link to MemTest86 Pro HTML report](/2025/03/pfsense-on-the-opnsense-dec740/MemTest86-Report-20250218-165252.html)

## Installing Proxmox Backup Server

This is where things get difficult. I found [this](https://wiki.junicast.de/en/junicast/review/opnsense_dec740) really helpful page by Jochen Demmer, along with this accompanying [YouTube video](https://www.youtube.com/watch?v=w33ijSZEEUc). In it, Jochen describes how he tried to install Proxmox, but was unable to get it to boot. I even emailed Jochen, but he had no further information than what was in the post and video. He actually ended up pulling the NVMe SSD out of the DEC740 and installing it in a different PC to write Proxmox to it.


Armed with that information, I wrote the [PBS ISO](https://www.proxmox.com/en/downloads/proxmox-backup-server/iso) directly to a USB flash drive using `dd` and immediately ran into the same issue as Jochen (not sure what I expected to happen). The error is below, nothing else on the screen.

```
error: file `/boot/' not found.
```

As a last-ditch attempt, I then wrote [Ventoy](https://www.ventoy.net/en/index.html) to the USB flash drive and copied the PBS ISO to the mounted directory. Sure enough, Ventoy booted without issue! If you don't set the two `Uart Configuration Options` in the BIOS (from above), this won't work.

```
                             GNU GRUB  version 2.04

 /----------------------------------------------------------------------------\
 |*proxmox-backup-server_4.0-1.iso                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 \----------------------------------------------------------------------------/

      Use the ^ and v keys to select which entry is highlighted.
      Ventoy 1.1.07 UEFI  www.ventoy.net
      L:Language  F1:Help  F2:Browse  F3:TreeView  F4:Localboot  F5:Tools
    F6:ExMenu
```

Choosing `Boot in normal mode` resulted in a black screen. However, choosing `Boot in grub2 mode` presented some other options.

```
                             GNU GRUB  version 2.04

 /----------------------------------------------------------------------------\
 |*Boot in normal mode                                                        |
 | Boot in grub2 mode                                                         |
 | File checksum                                                              |
 | Return to previous menu                                                    |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 \----------------------------------------------------------------------------/

      Use the ^ and v keys to select which entry is highlighted.
```

Here, the only one that worked was choosing `Advanced Options`.

```
                             GNU GRUB  version 2.04

 /----------------------------------------------------------------------------\
 | Install Proxmox Backup Server (Graphical)                                  |
 | Install Proxmox Backup Server (Terminal UI)                                |
 |*Advanced Options                                                           |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 \----------------------------------------------------------------------------/

      Use the ^ and v keys to select which entry is highlighted.
```

Here, the only one that worked was choosing `Install Proxmox Backup Server (Serial Console Debug Mode)`.

```
                             GNU GRUB  version 2.04

 /----------------------------------------------------------------------------\
 | Install Proxmox Backup Server (Debug Mode)                                 |
 | Install Proxmox Backup Server (Terminal UI, Debug Mode)                    |
 |*Install Proxmox Backup Server (Serial Console Debug Mode)                  |
 | Install Proxmox Backup Server (Automated)                                  |
 | Rescue Boot                                                                |
 | Test memory (memtest86+)                                                   |
 | UEFI Firmware Settings                                                     |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 |                                                                            |
 \----------------------------------------------------------------------------/

      Use the ^ and v keys to select which entry is highlighted.
```

After showing the Linux boot log (progress!), I had to press `Ctrl+D` two separate times, and then the PBS serial installer started! From here, I was able to install PBS like normal.

{{< img src="20251013_001.png" alt="proxmox serial installer" >}}

I'm unsure why Ventoy worked, when writing the PBS ISO directly to a USB flash drive didn't. A few notes:

- I was unable to set the [`nomodeset`](https://pbs.proxmox.com/docs/using-the-installer.html#nomodeset-kernel-param) kernel parameter, since I never got to the boot menu in the first place.
- The installation [documation](https://pbs.proxmox.com/docs/using-the-installer.html) says that the `Serial Console Debug Mode` "sets up the Linux kernel to use the (first) serial port of the machine for in- and output", but I was unsure how to set this manually.
- I tried to edit the PBS ISO on the USB flash drive to change boot settings in `/boot/grub/grub.cfg`, but the filesystem seemed to be read-only, so I was unable to change anything (no matter how I wrote the ISO or how I mounted it).

From here, you can connect an ethernet cable to your LAN interface and setup PBS.

# Conclusion

\-Logan
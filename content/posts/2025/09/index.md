---
title: "Proxmox Backup Server"
date: "2025-09-01"
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
| [ASRock iBOX-250J](https://www.asrockind.com/en-gb/iBOX-250J)                                                                                             | N/A                     | Intel J6412 (4c/4t, 10W)               | 2x DDR4-3200 SO-DIMM slots (max 32GB)  | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i225V                      |                        | Seems impossible to buy as an individual          |
| [ASRock iBOX-260J](https://www.asrockind.com/en-gb/iBOX-260J)                                                                                             | N/A                     | Intel N97 (4c/4t, 12W)                 | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 1x Intel i210AT, 1x Intel i226V     |                        | Seems impossible to buy as an individual          |
| [Shuttle DL30N](https://global.shuttle.com/products/productsDetail?pn=DL30N%20SERIES&c=xpc-fanless)                                                       | N/A                     | Intel N100/N200/N300                   | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2, 1x 2.5" bay | 2x Intel i226LM                     | ~$500                  |                                                   |
| [Jetway FBU03](https://jetwaycomputer.com/FBU03.html)                                                                                                     | HBFBU03-6412-B          | Intel J6412 (4c/4t, 10W)               | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2              | 2x Intel i225V                      | ~$299                  |                                                   |
| [Jetway BFTADN1](https://jetwaycomputer.com/BFTADN1.html)                                                                                                 | BFTADN1-N97-N           | Intel N97 (4c/4t, 12W)                 | 1x DDR5-4800 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2              | 2x Intel i225V                      | ~$550                  |                                                   |
| [GIGAIPC QBiX-EHLA6412-A1](https://www.gigaipc.com/en/products-detail/QBiX-EHLA6412-A1/)                                                                  | N/A                     | Intel J6412 (4c/4t, 10W)               | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x2              | 1x Intel i211AT                     | ~$300                  |                                                   |
| [GIGAIPC QBiX-ADNAN97-A1](https://www.gigaipc.com/en/products-detail/QBiX-ADNAN97-A1/)                                                                    | N/A                     | Intel N97 (4c/4t, 12W)                 | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Realtek RTL8111H 👎              | ~$350                  | So close, but Realtek NICs                        |
| [SuperMicro SYS-E100-14AM-E](https://www.supermicro.com/en/products/system/iot/box_pc/sys-e100-14am-e)                                                    | N/A                     | Intel x7433RE (4c/4t, 9W)              | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i226IT                     | ~$500                  |                                                   |
| [SuperMicro SYS-E100-14AM-H](https://www.supermicro.com/en/products/system/iot/box_pc/sys-e100-14am-h)                                                    | N/A                     | Intel x7835RE (8c/8t, 12W)             | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i226IT                     | ~$500                  |                                                   |
| [SuperMicro SYS-E100-14AM-L](https://www.supermicro.com/en/products/system/iot/fanless%20embedded/sys-e100-14am-l)                                        | N/A                     | Intel N97 (4c/4t, 12W)                 | 1x DDR5-4800 SO-DIMM slot (max 16GB)   | No   | 1x M.2 2280 NVMe PCIe Gen3 x1              | 2x Intel i226IT                     | ~$500                  |                                                   |

# Conclusion

\-Logan
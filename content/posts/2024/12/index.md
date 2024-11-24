---
title: "A new pfSense machine"
date: "2024-12-01"
author: "Logan Marchione"
categories:
  - "cloud-internet"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_pfsense.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_pfsense %}}

# Introduction

My [APU2 is five years old now](http://localhost:1313/2019/08/pfsense-on-the-pc-engines-apu2/) and I notice that it sometimes runs slow when making changes. For something as critical as a router, I didn't want to wait until it died to replace it. I went to [PC Engines website](https://www.pcengines.ch/), only to see that they are [ending production and closing their company](https://www.pcengines.ch/eol.htm) :cry:.

{{< img src="20241107_001.png" alt="pc engines eol" >}}

This was really disheartening, but I understand the decision given the circumstances. The APU2 was a great machine that would be hard to replace: x86, ECC memory, fanless, Intel NICs, and M.2 storage.

# Hardware

As I stated above, I was looking for the following things in a replacement box:

- small
- x86
- ECC memory
- fanless
- Intel NICs
- M.2 storage

It's easy to find all of that, except ECC support...

[Error correcting code (ECC) memory](https://en.wikipedia.org/wiki/ECC_memory) is special memory that has an extra chip on the stick that is used for parity bits to detect and correct bit-flips in memory. It's generally used on server, and hardly ever used on consumer PCs (especially mini PCs).

## Comparison

Below are the devices that I found in my searching (the first one is the current APU2D4 that I have now).

<details>
<summary><b>Click here to expand</b></summary>

| Make/Model                                                                                                                                                | Specific model number                                    | CPU                                    | RAM                                    | ECC                           | Storage                              | Ports                      | NICs                                | Price (main unit only) | Comments                                          |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|----------------------------------------|----------------------------------------|-------------------------------|--------------------------------------|----------------------------|-------------------------------------|------------------------|---------------------------------------------------|
| [PC Engines APU2](https://pcengines.ch/apu2.htm)                                                                                                          | [APU2D4](https://pcengines.ch/apu2d4.htm)                | AMD GX-412TC (4c/4t, 6W)               | 4GB DDR3-1333 (soldered)               | Yes                           | 1x mSATA SSD                         | 3x RJ-45                   | 3x Intel i210AT                     | $120 (2019)            | This is the device I have now                     |
| [Advantech FWA-1112VCL](https://www.advantech.com/en/products/9a23a3dc-d732-478f-a4f0-69cc7b8f8402/fwa-1112vcl/mod_d5165919-9f60-4553-bcba-9eaf3c37ca53)  | FWA-1112VCL-2CA1S                                        | Intel Atom C3338 (2c/2t, 8.5W)         | 1x DDR4-1866 SO-DIMM slot (max 32GB)   | Yes                           | 1x M.2 2280 SATA3 SSD                | 6x RJ-45                   | 1x Marvell 88E1543, 2x Intel i210AT | $482                   | Unsure which NICs are connected to which ports    |
| [Advantech FWA-1112VCL](https://www.advantech.com/en/products/9a23a3dc-d732-478f-a4f0-69cc7b8f8402/fwa-1112vcl/mod_d5165919-9f60-4553-bcba-9eaf3c37ca53)  | FWA-1112VCL-4CA1S                                        | Intel Atom C3558 (4c/4t, 16W)          | 1x DDR4-2133 SO-DIMM slot (max 32GB)   | Yes                           | 1x M.2 2280 SATA3 SSD                | 4x RJ-45, 2x 10G SFP+      | 1x Marvell 88E1543, 2x Intel i210AT | $558                   | Unsure which NICs are connected to which ports    |
| [Contec BX-220](https://www.contec.com/products-services/edge-computing/embedded-computers/box-pc/bx-220)                                                 | BX-220D-DC700000                                         | Intel Atom E3845 (4c/4t, 10W)          | 4GB DDR3-1333 (soldered)               | Yes                           | 1x CFast card slot                   | 2x RJ-45                   | 2x Intel i210                       | $675                   | Only supports DC terminal jack                    |
| [Contec BX-U200](https://www.contec.com/products-services/edge-computing/embedded-computers/box-pc/bx-u200)                                               | BX-U200-NA01M03                                          | Intel Atom x5-E3940 (4c/t4,9.5W)       | 4GB DDR3-1333 (soldered)               | Yes                           | 1x M.2 2242, SATA3 SSD               | 2x RJ-45                   | 2x Intel i210                       | $689                   | Only supports DC terminal jack                    |
| [Deciso DEC700 Series](https://shop.opnsense.com/dec700-series-opnsense-desktop-security-appliance/)                                                      | DEC740                                                   | AMD Embedded Ryzen V1500B (4c/8t, 12W) | 4GB DDR4-2666 VLP UDIMM (max 32GB)     | Supported (not default)       | 128GB M.2 2280 NVMe SSD              | 3x RJ-45, 2x 10G SFP+      | 3x Intel i210, 2x AMD Silicon       | $847                   | Unit supports, but does not ship with, ECC memory |
| [Deciso DEC700 Series](https://shop.opnsense.com/dec700-series-opnsense-desktop-security-appliance/)                                                      | DEC750                                                   | AMD Embedded Ryzen V1500B (4c/8t, 12W) | 8GB DDR4-2666 VLP UDIMM (max 32GB)     | Supported (not default)       | 256GB M.2 2280 NVMe SSD              | 3x RJ-45, 2x 10G SFP+      | 3x Intel i210, 2x AMD Silicon       | $960                   | Unit supports, but does not ship with, ECC memory |
| [DFI EC700-BT](https://www.dfi.com/product/index/169)                                                                                                     | EC700-BT4051-E454                                        | Intel Atom E3845 (4c/4t, 10W)          | 4GB DDR3-1333 (soldered)               | Yes                           | 1x 2.5" SATA drive bay, 1x mSATA SSD | 2x RJ-45                   | 2x Intel i210                       | ???                    |                                                   |
| [Portwell ANS-9122-21](https://portwell.com/products/detail.php?CUSTCHAR1=ANS-9122-21)                                                                    | AS1-3324                                                 | Intel Atom C3436L (4c/4t, 10.75W)      | 1x DDR4-1866 SO-DIMM slot (max 32GB)   | Yes                           | 1x eMMC 5.0 (16GB), 1x M.2 slot      | 4x RJ-45                   | Unknown                             | ???                    |                                                   |
| Broadcom AppNeta m50                                                                                                                                      |                                                          | Intel Atom C3558 (4c/4t, 16W)          | ???                                    | Yes                           | ???                                  | 4x RJ-45                   | 4x Intel X553                       | ???                    | This is only available as an eBay special         |
| [Nexcom DNA 141](https://www.nexcomusa.com/Products/network-and-communication-solutions/cyber-security-solutions/desktop-x86-based-appliance/desktop-x86-based-appliance-dna-141) | 10L00014100X0                    | Intel Atom x7203C (2c/2t, 9W)          | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | ???                           | 1x M.2 2242                          | 4x RJ-45                   | Unknown                             | ???                    |                                                   |
| [Lanner NCA-1510](https://www.lannerinc.com/products/network-appliances/x86-desktop-network-appliances/nca-1510)                                          | NCA-1510A                                                | Intel Atom C3558 (4c/4t, 16W)          | 1x DDR4-2133 SO-DIMM slot (max 16GB)   | Yes                           | eMMC                                 | 6x RJ-45                   | Unknown                             | ???                    |                                                   |


</details>

Below are devices that I looked at, but didn't have ECC memory, so they didn't make the cut.

<details>
<summary><b>Click here to expand</b></summary>

| Make/Model                                                                                                                                                | Specific model number                                    | CPU                                    | RAM                                    | ECC                           | Storage                              | Ports                      | NICs                                | Price (main unit only) | Comments                                          |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|----------------------------------------|----------------------------------------|-------------------------------|--------------------------------------|----------------------------|-------------------------------------|------------------------|---------------------------------------------------|
| [AAEON FWS-2277](https://eshop.aaeon.com/desktop-network-appliance-sd-wan-intel-celeron-n3350-fws-2277.html)                                              | FWS-2277-E2-A10-000                                      | Intel Celeron N3350 (2c/2t, 6W)        | 4GB DDR4 (soldered)                    | No                            | 1x eMMC (16GB)                       | 2x RJ-45                   | 2x Intel i210/i211                  | $319                   | Unsure if both NICs are the same or one of each   |
| [Deciso DEC600 Series](https://shop.opnsense.com/new-dec600-series-opnsense-desktop-security-appliances/)                                                 | DEC675                                                   | AMD GX-420MC (4c/4t, 17.5W)            | 4GB DDR3 SO-DIMM                       | No                            | 32GB microSD card                    | 4x RJ-45                   | 4x Intel i211                       | $620                   |                                                   |
| [Deciso DEC600 Series](https://shop.opnsense.com/new-dec600-series-opnsense-desktop-security-appliances/)                                                 | DEC695                                                   | AMD GX-420MC (4c/4t, 17.5W)            | 8GB DDR3 SO-DIMM                       | No                            | 256GB M.2 2280 NVMe SSD              | 4x RJ-45                   | 4x Intel i211                       | $733                   |                                                   |
| [DFI EC800-AL](https://www.dfi.com/product/index/129)                                                                                                     | EC800-AL552CHV-E3950-4                                   | Intel Atom x7-E3950 (4c/4t, 12W)       | 4GB DDR4-2400 (soldered)               | Unknown (sales never replied) | 1x M.2 2242, SATA3 SSD               | 2x RJ-45                   | 2x Intel i210                       | $568                   |                                                   |
| [Portwell APTNS-33045](https://portwell.com/products/detail.php?CUSTCHAR1=APTNS-33045)                                                                    | APTNS-33045                                              | Intel Atom x5-E3930 (2c/2t, 6.5W)      | 1x DDR3-1600 SO-DIMM slot (max 8GB)    | Only with custom project      | 1x eMMC 5.1 (8GB), 1x mSATA SSD      | 4x RJ-45                   | 4x Intel i211                       | ???                    |                                                   |
| [Portwell CAF-0252](https://portwell.com/products/detail.php?CUSTCHAR1=CAF-0252)                                                                          | 18-E02520-000                                            | Intel Celeron N3350 (2c/2t, 6W)        | 1x DDR3-1333 SO-DIMM slot (max 8GB)    | No                            | 1x eMMC 5.1 (4GB), 1x SATA3 DOM      | 2x RJ-45                   | 2x Intel i211                       | ???                    |                                                   |
| [Protectli FW4C](https://protectli.com/product/fw4c/)                                                                                                     | FW4C                                                     | Intel Pentium J3710 (4c/4t, 6.5W)      | 1x DDR3-1600 SO-DIMM slot (max 8GB)    | No                            | 1x mSATA SSD                         | 4x RJ-45 2.5GB             | 4x Intel I225-V                     | $249                   |                                                   |

</details>

# Conclusion

\-Logan

---
title: "pfSense on the OPNsense DEC740"
date: "2025-02-28"
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

My [APU2 is five years old now](http://localhost:1313/2019/08/pfsense-on-the-pc-engines-apu2/) and I notice that it runs slow when making changes in pfSense's web UI. The CPU is an AMD GX-412TC (from 2014) and it's running 4GB of DDR3 memory, so I guess that's to be expected. Also, I only have 500/500Mbps internet, but would like to update to 1Gbps at some point, and I'm left wondering if the APU2 could keep up with that speed. I've seen [this post](https://teklager.se/en/knowledge-base/apu2-1-gigabit-throughput-pfsense/) about routing at 1Gbps on the APU2 hardware, but I'm also running pfBlockerNG and wondering if that would affect speed.

For something as critical as a router, I didn't want to wait until it died to replace it. Thinking there would be a newer model, I went to the [PC Engines website](https://www.pcengines.ch/), only to see that they are [ending production and closing their company](https://www.pcengines.ch/eol.htm) :cry:.

{{< img src="20241107_001.png" alt="pc engines eol" >}}

This was really disheartening, but I understand the decision given the circumstances. The APU2 was a great machine that would be hard to replace.

# Hardware

I was looking for the following things in a replacement box:

- small (needs to fit in my [mini-rack](/2021/01/homelab-10-mini-rack/))
- x86 (to run pfSense)
- DDR4 memory (ECC if possible)
- fanless (one less thing to dust)
- Intel NICs
- M.2 storage

It's easy to find all of that in cheap Chinese mini PCs on Amazon, except ECC support. [Error correcting code (ECC) memory](https://en.wikipedia.org/wiki/ECC_memory) is special memory that has an extra chip on the stick that is used for parity bits to detect and correct bit-flips in memory. It's generally used on servers, and hardly ever used on consumer PCs (especially mini PCs). However, I was also trying to find something that was from a relatively well-known manufacturer that wouldn't burn my house down. The Chinese mini PCs worry me, because they're all no-name brands that disappear from Amazon after a few months and provide no support if they don't disappear.

## Comparison

Below are the devices that I found in my searching (the first one is the current APU2D4 that I have now).

| Make/Model                                                                                                                                                | Specific model number                                    | CPU                                    | RAM                                    | ECC                           | Storage                              | Ports                      | NICs                                | Price (main unit only) | Comments                                          |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|----------------------------------------|----------------------------------------|-------------------------------|--------------------------------------|----------------------------|-------------------------------------|------------------------|---------------------------------------------------|
| [PC Engines APU2](https://pcengines.ch/apu2.htm)                                                                                                          | [APU2D4](https://pcengines.ch/apu2d4.htm)                | AMD GX-412TC (4c/4t, 6W)               | 4GB DDR3-1333 (soldered)               | Yes                           | 1x mSATA SSD                         | 3x RJ-45                   | 3x Intel i210AT                     | $120 (2019)            | This is the device I have now                     |
| [Advantech FWA-1112VCL](https://www.advantech.com/en/products/9a23a3dc-d732-478f-a4f0-69cc7b8f8402/fwa-1112vcl/mod_d5165919-9f60-4553-bcba-9eaf3c37ca53)  | FWA-1112VCL-2CA1S                                        | Intel Atom C3338 (2c/2t, 8.5W)         | 1x DDR4-1866 SO-DIMM slot (max 32GB)   | Yes                           | 1x M.2 2280 SATA3 SSD                | 6x RJ-45                   | 1x Marvell 88E1543, 2x Intel i210AT | $482                   | Unsure which NICs are connected to which ports    |
| [Deciso DEC700 Series](https://shop.opnsense.com/dec700-series-opnsense-desktop-security-appliance/)                                                      | DEC740                                                   | AMD Embedded Ryzen V1500B (4c/8t, 12W) | 4GB DDR4-2666 VLP UDIMM (max 32GB)     | Supported (not default)       | 128GB M.2 2280 NVMe SSD              | 3x RJ-45, 2x 10G SFP+      | 3x Intel i210, 2x AMD Silicon       | $847                   | Unit supports, but does not ship with, ECC memory |
| [Portwell ANS-9122-21](https://portwell.com/products/detail.php?CUSTCHAR1=ANS-9122-21)                                                                    | AS1-3324                                                 | Intel Atom C3436L (4c/4t, 10.75W)      | 1x DDR4-1866 SO-DIMM slot (max 32GB)   | Yes                           | 1x M.2 slot                          | 4x RJ-45                   | ???                                 | ???                    |                                                   |
| Broadcom AppNeta m50                                                                                                                                      | Custom fanless version of the AAEON FWS-2362             | Intel Atom C3558 (4c/4t, 16W)          | ???                                    | Yes                           | ???                                  | 4x RJ-45                   | 4x Intel X553                       | ???                    | This is only available as an eBay special         |
| [Nexcom DNA 141](https://www.nexcomusa.com/Products/network-and-communication-solutions/cyber-security-solutions/desktop-x86-based-appliance/desktop-x86-based-appliance-dna-141) | 10L00014100X0                    | Intel Atom x7203C (2c/2t, 9W)          | 1x DDR4-3200 SO-DIMM slot (max 32GB)   | ??? (sales never replied)     | 1x M.2 2242                          | 4x RJ-45                   | 4x Intel i226                       | ???                    |                                                   |
| [Lanner NCA-1510](https://www.lannerinc.com/products/network-appliances/x86-desktop-network-appliances/nca-1510)                                          | NCA-1510A                                                | Intel Atom C3558 (4c/4t, 16W)          | 1x DDR4-2133 SO-DIMM slot (max 16GB)   | Yes                           | 1x 2.5" bay                          | 6x RJ-45                   | ???                                 | ???                    |                                                   |

Below are devices that I looked at, but there was one reason or another that they didn't make the cut...

- [AAEON FWS-2277](https://eshop.aaeon.com/desktop-network-appliance-sd-wan-intel-celeron-n3350-fws-2277.html) (Celeron CPU, which means no ECC support)
- [DFI EC800-AL](https://www.dfi.com/product/index/129) (Atom CPUs, but no ECC support)
- [GIGAIPC QBiX-EHLA6412-A1](https://www.gigaipc.com/en/products-detail/QBiX-EHLA6412-A1/) (Celeron CPU, which means no ECC support)
- [Jetway FBU03](https://jetwaycomputer.com/FBU03.html) (Celeron CPU, which means no ECC support)
- [Polywell Nano-N305L4](https://www.polywell.com/nano-n305l4) (i3-N305 CPU, which means no ECC support)
- [Portwell CAF-0100](https://portwell.com/products/detail.php?CUSTCHAR1=CAF-0100) (Too wide for a half-rack, IB-ECC)


## Purchase

I must have looked at hundreds or thousands of mini PCs on obscure industrial and electronics distributor websites.

The [Nexcom DNA 141](https://www.nexcomusa.com/Products/network-and-communication-solutions/cyber-security-solutions/desktop-x86-based-appliance/desktop-x86-based-appliance-dna-141) would have made the perfect router (chef's kiss), but I was unable to find a reseller/distributor. I reached out to Nexcom, but they informed me that they don't sell to individuals. When I asked about a reseller/distributor in the US, they stopped replying 🤷.

I almost ended up purchasing a Lanner NCA-1510. Funny enough, the Lanner NCA-1510A is the OEM of the Netgate SG-5100, according to a few posts ([here](https://forum.netgate.com/post/1040249), [here](https://chaos.social/@JeGr/112512006883278146), [here](https://www.reddit.com/r/PFSENSE/comments/1b8lg3z/comment/kttopfw/), and [here](https://www.reddit.com/r/PFSENSE/comments/93kl91/comment/e4admnm/)).

I ended up going with the Deciso DEC740, as it was the only one that had ECC memory in such a small footprint and it was easy to purchase as a non-business.

{{< video_figure src="20250202_001.mp4" width="100%" attr="Video from OPNsense" attrlink="https://shop.opnsense.com/product/dec740-opnsense-desktop-security-appliance/" >}}

To me, it's the spritual successor to the APU2 (it's almost the same size, same layout, but updated with modern hardware for modern applications). There is some really good information [here](https://wiki.junicast.de/en/junicast/review/opnsense_dec740) and [here](https://web.archive.org/web/20240407173603/https://www.deciso.com/netboard-a10-gen3/) about the DEC740 and its specifications (the second link is an Archive.org link because the URL is currently returning a 404). The box included the DEC740, the US power adapter, and a mini-USB cable (for the serial port).

{{< img src="20250215_002.jpg" alt="dec740" >}}

Based on [this comparison](https://www.cpubenchmark.net/compare/5050vs4304/AMD-GX-412TC-SOC-vs-AMD-Ryzen-Embedded-V1500B), the CPU in the new device should run rings around my own APU2. Plus, this device has 2x 10Gbps SFP+ ports.

{{< img src="20250203_002.png" alt="cpu comparison" >}}

## ECC RAM upgrade

I also picked up a stick of 32GB DDR4 ECC UDIMM VLP (specifically model number MTA18ADF4G72AZ-2G6 from [Memory.net](https://memory.net/product/mta18adf4g72az-2g6-micron-1x-32gb-ddr4-2666-ecc-udimm-pc4-21300v-e-dual-rank-x8-module/)) for $124. I would assume any ECC memory would work here, but it has to be UDIMM and it has to be Very Low Profile (VLP). I've never used VLP RAM before, so here is a picture comparing two sticks of regular DDR4 DIMMs (top) to a single DDR4 VLP DIMM (bottom).

{{< img src="20250215_001.jpg" alt="vlp ram" >}}

There are four Torx screws on the bottom of the unit (one with an [unenforcable-in-the-USA](https://en.wikipedia.org/wiki/Magnuson%E2%80%93Moss_Warranty_Act) "void if removed" sticker). Then, the black heatsink part of the unit slides away from the front face.

{{< img src="20250215_003.jpg" alt="dec740 opened" >}}

There are four more Torx screws holding the PCB onto the black heatsink. The SSD is a Transcend 128GB NVMe PCIe Gen3 x4 (TS128GMTE110S). I didn't bother to replace this, since I ship my logs to [Graylog](https://graylog.org/), so they're not stored on the SSD anyway.

{{< img src="20250215_004.jpg" alt="dec740 opened" >}}

I upgraded the RAM, cleaned the old paste off with isopropyl, then re-pasted the CPU using Noctua NT-H2.

{{< img src="20250215_005.jpg" alt="dec740 opened" >}}

This is the view from the other side of the RAM stick (you can see the button-cell battery here for the BIOS).

{{< img src="20250215_006.jpg" alt="dec740 opened" >}}

Here is the die shot of the CPU.

{{< img src="20250215_007.jpg" alt="ryzen cpu" >}}

# Decisions

## Did I pay over $800 for a router?!

Yes. My router is arguably the most important device on my network. It protects my network from the big, bad internet. I don't mind paying for a product that can do that job silently, reliably, 24/7, now and 10 years into the future. If I amortize the $800 over 10 years, that's only $80 per year (I spend more money per year on Chipotle).

Side note - This is a week of data from my Graylog instance. This is what my router is protecting me from.

{{< img src="20250203_001.png" alt="grafana wan dashboard" >}}

## Why pfSense?

I know that Netgate (the company that owns pfSense) has had some controversies:

- 2016: When OPNsense sense was forked from pfSense, Netgate purchased the domain OPNsense.com and [setup a parody site](https://web.archive.org/web/20160314132836/http://www.opnsense.com/) to discredit OPNsense. OPNsense had to [appeal](https://opnsense.org/opnsense-com/) to the World Intellectual Property Organization (WIPO) to get control of the domain.
- 2017: Netgate announced ([here](https://www.netgate.com/blog/pfsense-2-5-and-aes-ni) and [here](https://www.netgate.com/blog/more-on-aes-ni)) that pfSense 2.5 would require [AES-NI](https://en.wikipedia.org/wiki/AES_instruction_set), then [walked that back in 2019](https://www.netgate.com/blog/pfsense-2-5-0-development-snapshots-now-available)
- 2017: Netgate implemented a scary-looking popup [disclaimer](https://www.netgate.com/blog/its-still-free-to-use) in order to use pfSense
- 2019: Netgate hired a developer to implement WireGuard for pfSense and then upstream the code to FreeBSD (side note - apparently the developer was [slighty crazy](https://www.theregister.com/2008/04/24/kip_macy_arrest/)). This was finished in 2020. In 2021, it was clear the code was not production-ready. Netgate gets defensive and is [called out by the WireGuard developer himself](https://lists.freebsd.org/pipermail/dev-commits-src-all/2021-March/004413.html). Netgate then has to do [damage control](https://www.netgate.com/blog/painful-lessons-learned-in-security-and-community).
- 2021: Netgate [announced](https://www.netgate.com/blog/announcing-pfsense-plus) a closed-source version of pfSense called pfSense Plus (which gets more love and attention from Netgate than the open-source version)
- 2023: Netgate pushed homelabbers from a free Community Edition license to pfSense Plus (called Home+Lab edition), then changed their mind and [started charging for the Home+Lab license](https://www.netgate.com/blog/addressing-changes-to-pfsense-plus-homelab)
- 2024: Netgate locked the installer for pfSense CE (the free version) [behind a login page](https://www.reddit.com/r/PFSENSE/comments/1chzp1n/comment/l29c7gw/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)

So, with all that said: why am I using pfSense?

To be honest, I just don't care about any of the drama above because it doesn't affect me. I don't pay for pfSense (and wouldn't with the way Netgate acts), so I don't feel like I'm "supporting" their bad behavior. I'll continue to use the free version of pfSense until they make it paid, or closed-source, then I'll switch to OPNsense. But right now, I don't feel like learning OPNsense and re-building my firewall from scratch (I just want to restore a backup and get on with life).

# Pre-installation

## Console settings

The serial adapter shows up as `Exar Corp. XR21B1411 UART` in Linux, and I verifed it connected to `/dev/ttyUSB0` to by using `sudo dmesg | grep tty`. Then, I was able to use screen to connect to it.

```
screen /dev/ttyUSB0 115200
```

This was the BIOS that shipped with the DEC740. According to [this page](https://docs.opnsense.org/hardware/bios.html), it's up-to-date.

```
BIOS Version : 05.38.09.0023-A10.30
BIOS Build Date : 05/01/2024
Processor Type : AMD Ryzen Embedded V1500B
System Memory Speed : 2400 MHz
```

At boot, you can press `ESC` once to enter the BIOS "Front Page".

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

### Memory overclock

At the Front Page, go to `Setup Utility`, then `AMD CBS`, then `UMC Common Options`, then `DDR4 Common Options`, then `DRAM Timing Configuration`, then accept the warning, then set `Memory Overclock Settings` to `Enabled`.

```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
                                                  AMD CBS
/-------------------------------------------------------------------------------------+----------------------------------------\
|I Accept                                                                             |Memory Overclock Settings               |
|                                                                                     |                                        |
|Overclock                                  <Auto>                                    |                                        |
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
|                                                         /---------\                 |                                        |
|                                                         |Overclock|                 |                                        |
|                                                         |---------|                 |                                        |
|                                                         |Auto     |                 |                                        |
|                                                         |Enabled  |                 |                                        |
|                                                         \---------/                 |                                        |
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

Then, set the `Memory Clock Speed` to `1333MHz` (since it's DDR memory, this works out to 2666MHz).

```
                                                    InsydeH2O Setup Utility                                             Rev. 5.0
                                                  AMD CBS
/-------------------------------------------------------------------------------------+----------------------------------------\
|I Accept                                                                             |Set the memory clock frequency.         |
|                                                                                     |                                        |
|Overclock                                  <Enabled>                                 |                                        |
|Memory Clock Speed                         <Auto>                                    |                                        |
|Tcl                                        <Auto>                                    |                                        |
|Trcdrd                                     <Auto>                                    |                                        |
|Trcdwr                                     <Auto>    /------------------\            |                                        |
|Trp                                        <Auto>    |Memory Clock Speed|            |                                        |
|Tras                                       <Auto>    |------------------|            |                                        |
|Trc Ctrl                                   <Auto>    |Auto              |            |                                        |
|TrrdS                                      <Auto>    |667MHz            |            |                                        |
|TrrdL                                      <Auto>    |800MHz            |            |                                        |
|Tfaw Ctrl                                  <Auto>    |933MHz            |            |                                        |
|TwtrS                                      <Auto>    |1067MHz           |            |                                        |
|TwtrL                                      <Auto>    |1200MHz           |            |                                        |
|Twr Ctrl                                   <Auto>    |1333MHz           |            |                                        |
|Trcpage Ctrl                               <Auto>    |1400MHz           |            |                                        |
|TrdrdScL Ctrl                              <Auto>    |1467MHz           |            |                                        |
|TwrwrScL Ctrl                              <Auto>    |1533MHz           |            |                                        |
|Trfc Ctrl                                  <Auto>    |1600MHz           |            |                                        |
|Trfc2 Ctrl                                 <Auto>    |1667MHz           |            |                                        |
|Trfc4 Ctrl                                 <Auto>    |1733MHz           |            |                                        |
|Fail_CNT                                   [0x5]     |1800MHz           |            |                                        |
|ProcODT                                    <Auto>    |1867MHz           |            |                                        |
|Tcwl                                       <Auto>    |1933MHz           |            |                                        |
|Trtp                                       <Auto>    |2000MHz           |            |                                        |
|Tcke                                       <Auto>    \------------------/            |                                        |
|TrdrdSc                                    <Auto>                                    |                                        |
|TrdrdSd                                    <Auto>                                    |                                        |
|TrdrdDd                                    <Auto>                                    |                                        |
|TwrwrSc                                    <Auto>                                    |                                        |
|TwrwrSd                                    <Auto>                                    |                                        |
|TwrwrDd                                    <Auto>                                    |                                        |
|Trdwr                                      <Auto>                                    |                                        |
\-------------------------------------------------------------------------------------v----------------------------------------/
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
|Disable Memory Error Injection             <False>                                   |                                        |
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

Press `F10` to save and reboot.

## Memory test

At the Front Page, go to `Boot Manager`. I was able to boot from a flash drive containing MemTest86 Pro (since it [supports ECC injection](https://www.memtest86.com/ecc.htm) for testing ECC).

```
/------------------------------------------------------------------------------------------------------------------------------\
|                                                         Boot Manager                                                         |
\------------------------------------------------------------------------------------------------------------------------------/


  Boot Option Menu

  EFI Boot Devices
  EFI Hard Drive (I947122223-TS128GMTE110S)
  EFI USB Device 1 (Samsung Flash Drive)
  EFI USB Device (Samsung Flash Drive)
  Internal EFI Shell

  ^ and v to change option, ENTER to select an option, ESC to exit





















/------------------------------------------------------------------------------------------------------------------------------\
| F1  Help                                                      ^/v   Select Item                                              |
| Esc Exit                                                      Enter Select > SubMenu                                         |
\------------------------------------------------------------------------------------------------------------------------------/
```

I left MemTest to run and came back to this.

```
```

## Installing pfSense

https://forum.netgate.com/topic/180986/dec740-desktop-security-appliance-cannot-proceed-with-installation-of-pfsense/9?_=1739734218359

The installation process couldn't have been easier. pfSense has excellent documentation, and Tom Lawrence has a [great video](https://www.youtube.com/watch?v=0oi02LayIIM) talking about the process of restoring from a backup (both to the same hardware, and different hardware).

# Conclusion

\-Logan

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

The [Nexcom DNA 141](https://www.nexcomusa.com/Products/network-and-communication-solutions/cyber-security-solutions/desktop-x86-based-appliance/desktop-x86-based-appliance-dna-141) would have made the perfect router, but I was unable to find a reseller/distributor. I reached out to Nexcom, but they informed me that they don't sell to individuals. When I asked about a reseller/distributor in the US, they stopped replying 🤷.

I almost ended up purchasing a Lanner NCA-1510. Funny enough, the Lanner NCA-1510A is the OEM of the Netgate SG-5100, according to a few posts ([here](https://forum.netgate.com/post/1040249), [here](https://chaos.social/@JeGr/112512006883278146), [here](https://www.reddit.com/r/PFSENSE/comments/1b8lg3z/comment/kttopfw/), and [here](https://www.reddit.com/r/PFSENSE/comments/93kl91/comment/e4admnm/)).

Based on [this comparison](https://www.cpubenchmark.net/compare/5050vs3129/AMD-GX-412TC-SOC-vs-Intel-Atom-C3558), the CPU in the new device should run rings around my own APU2.

{{< img src="20241125_001.png" alt="cpu comparison" >}}

# Conclusion

\-Logan

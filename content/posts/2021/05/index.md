---
title: "Dell Precision 3240 Compact Hypervisor"
date: "2021-05-01"
author: "Logan Marchione"
categories: 
  - "oc"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_generic_storage.svg"
    alt: "featured image"
    relative: false
---

# Introduction

My hypervisor since 2017 has been an Intel [NUC7i3BNH](https://ark.intel.com/content/www/us/en/ark/products/95066/intel-nuc-kit-nuc7i3bnh.html). It ran a 2c/4t 15W laptop CPU ([Core i3-7100U](https://ark.intel.com/content/www/us/en/ark/products/95442/intel-core-i3-7100u-processor-3m-cache-2-40-ghz.html)), with 2x 16GB Crucial DDR4, and a 512GB Samsung 860 Pro. While it served me well over these years, I've outgrown the CPU.

# Hardware selection

## Size, power, and noise

As outlined in my [homelab mini-rack](/2021/01/homelab-10-mini-rack/) post, my homelab devices (router, switch, AP, NAS, and hypervisor) all sit on the bottom shelf of the entertainment center in my living room. Because of this, everything needs to be small, quiet, power efficient, and have a high [WAF](https://www.urbandictionary.com/define.php?term=Wife%20Acceptance%20Factor) (in that order).


{{< img src="20210104_003.jpg" alt="mini-rack on shelf" >}}

When searching for a new hypervisor, my first requirements were size, power, and noise. Luckily for me, [ServeTheHome](https://www.servethehome.com/) has an excellent series called [TinyMiniMicro](https://www.servethehome.com/tag/tinyminimicro/) where they review [Lenovo Tiny](https://www.lenovo.com/us/en/desktops-and-all-in-ones/thinkcentre/m-series-tiny/c/M-Series-Tiny), [HP Mini](https://store.hp.com/us/en/vwa/mini-desktops/form=Mini), and [Dell Micro](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/sr/desktops-n-workstations/optiplex-desktops/micro?appliedRefinements=13723) PCs as servers. Though their series mainly focuses on last-gen hardware, it gave me a great insight to the differences between manufacturers and models, as well as a starting point when looking for ultra-small form-factor (USFF) PCs.

## AMD vs Intel

Normally, I would recommend AMD for almost any application, since the cores-per-dollar ratio is so good. However, in this case, one of the applications I will be running is Plex, which can greatly benefit from hardware-enabled video transcoding. While AMD has its own [hardware transcoding engine](https://en.wikipedia.org/wiki/Video_Core_Next), it is nowhere near as efficient or as supported as [Intel's QuickSync](https://en.wikipedia.org/wiki/Intel_Quick_Sync_Video). Because of that, I specifically looked for an Intel CPU with an integrated GPU.

## Proposed hardware

Here is a comparison of my original NUC and the final four devices I considered (all with relatively the same specs).

{{< comparison/hypervisors >}}

Even though the Dell Precision 3240 Compact was the most expensive build, it offered something no other chassis could: ECC memory (and a CPU to run it) in a small form-factor.

Here is what I ended up buying and the prices I paid:

*  Dell Precision 3240 Compact
*  2x Dell 32GB DDR4-3200 SODIMM ECC
*  Intel SSD D3-S4610 (960GB)

## Build pics

# Hardware-specific things

## Thermal limits

If you read around, you'll find complaints about thermal problems ([one](https://www.reddit.com/r/Dell/comments/iy12iv/precision_3240_compact/), [two](https://forums.redflagdeals.com/dell-dell-precision-3240-compact-workstation-usff-2-3l-i3-10100-8g-279-313-i5-10500-8g-419-470-2403015/21/#p33901450)) on the 3240 Compact. Dell offers two different heatsinks depending on the CPU you choose. Of the reported thermal issues, they all seemed to be using the Core processors which have a smaller heatsink. If you look at Dell's documentation, you can see the differences on [pages 61 and 62](https://dl.dell.com/topicspdf/precision-3240-workstation_owners-manual_en-us.pdf#_OPENTOPIC_TOC_PROCESSING_d111e10824) of the service manual.


The Core processors are all 65W and use a smaller heatsink.

{{< img src="20210501_001.jpg" alt="small heatsink" >}}

The Xeon processors, however, are all 80W and use a larger heatsink and heatpipes.

{{< img src="20210501_002.jpg" alt="large heatsink" >}}

There is a Dell [parts list](http://ftpbox.us.dell.com/slg/TXDIR/Pricelist/Dell_TXDIR_Pricelist.xlsx) where you can find the 80W heatsink+fan combo (apparently part# 412-AATU). I haven't confirmed this part number and I'm unsure how you would order it. If it worked, however, you could probably replace the stock 65W heatsink+fan combo (part# 412-AATV) with this, even if you were running a Core processor.

## Memory

Dell charges 2-3x standard memory prices if you use their customizer. I chose to stick with the lowest-price 8GB stick they included (I'll throw it in a drawer), then purchase ECC memory separately (ironically, also from dell.com) at half the price that the customizer offered.

## Storage

The 3240 Compact has space for three storage drives:
 
*  1x 2.5" HDD/SSD (SATA connector)
*  2x 2230/2280 NVMe SSD (M.2 connector)

Again, Dell charges 2-3x standard storage prices if you use their customizer. I decided to purchase an Intel data center 2.5" SSD, but will probably add an NVMe drive in the future as well.

## Extra customizer options

Dell offers a few customization options that may be useful to some people.

*  WiFi+bluetooth combo cards from Intel (WiFi 6) or Qualcomm
*  An "extra port" slot that can be VGA, HDMI, DisplayPort, USB-C, or serial
*  vPro options (defaults to Intel ME disabled, nice!)

There are also quite a few PCIe-based devices to choose from. Keep in mind there is only one half-height Gen. 3 PCIe x8 slot.

*  Nvidia GPUs (P400, P620, P1000, or RTX 3000)
*  Thunderbolt 3 card
*  NICs from Aquantia (5Gb) or Intel (1Gb)

# Proxmox performance
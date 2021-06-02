---
title: "FIND A BETTER TITLE"
date: "2021-06-01"
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

My hypervisor since 2017 has been an Intel [NUC7i3BNH](https://ark.intel.com/content/www/us/en/ark/products/95066/intel-nuc-kit-nuc7i3bnh.html). It has a 2c/4t 15W laptop CPU ([Core i3-7100U](https://ark.intel.com/content/www/us/en/ark/products/95442/intel-core-i3-7100u-processor-3m-cache-2-40-ghz.html)), with 2x 16GB Crucial DDR4, and a 512GB Samsung 860 Pro. While it served me well over these years, I've outgrown the CPU and cooling solution.

# The search for a new hypervisor

## Size, noise, and power

As outlined in my [homelab mini-rack](/2021/01/homelab-10-mini-rack/) post, my homelab devices (router, switch, AP, NAS, and hypervisor) all sit on the bottom shelf of the entertainment center in my living room. Because of this, everything needs to be small, quiet, power efficient, and have a high [WAF](https://www.urbandictionary.com/define.php?term=Wife%20Acceptance%20Factor).


{{< img src="20210104_003.jpg" alt="mini-rack on shelf" >}}

When searching for a new hypervisor, my first requirements were size, noise, and power draw. Luckily for me, [ServeTheHome](https://www.servethehome.com/) has an excellent series called [TinyMiniMicro](https://www.servethehome.com/tag/tinyminimicro/) where they review [Lenovo Tiny](https://www.lenovo.com/us/en/desktops-and-all-in-ones/thinkcentre/m-series-tiny/c/M-Series-Tiny), [HP Mini](https://store.hp.com/us/en/vwa/mini-desktops/form=Mini), and [Dell Micro](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/sr/desktops-n-workstations/optiplex-desktops/micro-small-78l-or-less?appliedRefinements=33718) PCs as servers. The ServeTheHome series gave me a great insight to the differences between manufacturers and models, as well as a starting point when looking for ultra-small form-factor (USFF) PCs.

## AMD vs Intel

Normally, I would recommend AMD for almost any application, since the cores-per-dollar ratio is so good. However, in this case, one of the applications I will be running is Jellyfin, which can greatly benefit from hardware-enabled video transcoding. While AMD has its own [hardware transcoding engine](https://en.wikipedia.org/wiki/Video_Core_Next), it is nowhere near as efficient or as supported as [Intel's QuickSync](https://en.wikipedia.org/wiki/Intel_Quick_Sync_Video). Because of that, I specifically looked for an Intel CPU with an integrated GPU.

## Hardware comparison

Here is a comparison of my current NUC and the new hypervisor (all with relatively similar specs).

{{< comparison/hypervisors >}}

## Build pics

## Other devices that didn't make the cut

*  [11th Generation Intel NUC](https://www.intel.com/content/www/us/en/products/details/nuc/kits/products.html)
    * This was an upgrade of the problems I had to begin with: U-Series processors (laptop chip) with poor cooling.
*  [Lenovo Tiny](https://www.lenovo.com/us/en/desktops-and-all-in-ones/thinkcentre/m-series-tiny/c/M-Series-Tiny), [HP Mini](https://store.hp.com/us/en/vwa/mini-desktops/form=Mini), and [Dell Micro](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/sr/desktops-n-workstations/optiplex-desktops/micro-small-78l-or-less?appliedRefinements=33718)
    * These were all basically the same devices, with different physical layouts: Intel T-Series processors (low-power chip), a poor CPU heatsink, a blower fan, and limited expansion options.
*  [Dell Precision 3240 Compact](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/precision-3240-workstation/spd/precision-3240-workstation)
    * I really wanted to like this. It offered Intel Core or Xeon processors, the latter of which could use ECC memory, in a super-small form-factor.
    * It had [different heatsinks](https://dl.dell.com/topicspdf/precision-3240-workstation_owners-manual_en-us.pdf#_OPENTOPIC_TOC_PROCESSING_d111e10824) for the Core vs Xeon models, but both the Core ([one](https://www.reddit.com/r/Dell/comments/iy12iv/precision_3240_compact/), [two](https://forums.redflagdeals.com/dell-dell-precision-3240-compact-workstation-usff-2-3l-i3-10100-8g-279-313-i5-10500-8g-419-470-2403015/21/#p33901450), [three](https://www.reddit.com/r/Dell/comments/m6ao4k/does_anyone_use_a_dell_precision_3240_compact/gsbb4yc)) and Xeon ([one](https://www.reddit.com/r/Dell/comments/mv0vx4/feedback_on_precision_3240_compact_with_xeon/)) models suffered from poor thermals and loud fans.
*  [HPE ProLiant MicroServer Gen10 Plus](https://buy.hpe.com/us/en/servers/proliant-microserver/proliant-microserver/proliant-microserver/hpe-proliant-microserver-gen10-plus/p/1012241014)
    * The included Xeon processor (Xeon E-2224) was only 4c/4t and it didn't support QuickSync. Although you could physically replace the CPU, there was a BIOS limitation by HP that prevented QuickSync from working.
    * The included cooler and external PSU (180W) probably couldn't handle processors rated for more than 71W, which really limited my options for CPUs.
    * There was a single PCIe slot which I could use to install a small GPU (e.g., Nvidia Quadro P400), or run a PCIe-to-NVMe card for a boot drive, but not both. Again, devices taking up more power.

# Hardware-specific things

## Storage

# Proxmox
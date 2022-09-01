---
title: "ASRock DeskMini H470 as a compact hypervisor"
date: "2021-06-23"
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

My hypervisor since 2017 has been an Intel [NUC7i3BNH](https://ark.intel.com/content/www/us/en/ark/products/95066/intel-nuc-kit-nuc7i3bnh.html). It has a 2c/4t 15W laptop CPU (Core i3-7100U), with 2x 16GB Crucial DDR4, and a 512GB Samsung 860 Pro. While it served me well over these years, I've outgrown the CPU and cooling solution.

# The search for a new hypervisor

## Size, noise, and power

As outlined in my [homelab mini-rack](/2021/01/homelab-10-mini-rack/) post, my homelab devices (router, switch, AP, NAS, and hypervisor) all sit on the bottom shelf of the entertainment center in my living room. Because of this, everything needs to be small, quiet, power efficient, and have a high [WAF](https://www.urbandictionary.com/define.php?term=Wife%20Acceptance%20Factor).


{{< img src="20210104_003.jpg" alt="mini-rack on shelf" >}}

When searching for a new hypervisor, my first requirements were size, noise, and power draw. Luckily for me, [ServeTheHome](https://www.servethehome.com/) has an excellent series called [TinyMiniMicro](https://www.servethehome.com/tag/tinyminimicro/) where they review [Lenovo Tiny](https://www.lenovo.com/us/en/desktops-and-all-in-ones/thinkcentre/m-series-tiny/c/M-Series-Tiny), [HP Mini](https://store.hp.com/us/en/vwa/mini-desktops/form=Mini), and [Dell Micro](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/sr/desktops-n-workstations/optiplex-desktops/micro-small-78l-or-less?appliedRefinements=33718) PCs as servers. The ServeTheHome series gave me a great insight into the differences between manufacturers and models, as well as a starting point when looking for ultra-small form-factor (USFF) PCs.

## AMD vs Intel

Normally, I would recommend AMD for almost any application, since the cores-per-dollar ratio is so good. However, in this case, one of the applications I will be running is Jellyfin, which can greatly benefit from hardware-enabled video transcoding. While AMD has its own [hardware transcoding engine](https://en.wikipedia.org/wiki/Video_Core_Next), it is nowhere near as efficient or as supported as [Intel's QuickSync](https://en.wikipedia.org/wiki/Intel_Quick_Sync_Video). Because of that, I specifically looked for an Intel CPU with an integrated GPU.

## Hardware comparison

[This](https://www.reddit.com/r/HomeServer/comments/l2qsh4/my_first_homeserver_running_esxi_7_nothing_like/) Reddit post convinced me to go with the ASRock DeskMini H470, as it was almost exactly the same build as what I was looking for.

{{< img src="20210621_004.png" alt="deskmini" >}}

Below is a comparison of my current NUC and the new hypervisor (it's obviously not a like-for-like comparison because of the CPU, cooler, and RAM differences).

{{< comparison/hypervisors >}}

## Build pics

{{< img src="20210622_001.jpg" alt="build pics" >}}

{{< img src="20210622_002.jpg" alt="build pics" >}}

{{< img src="20210622_006.jpg" alt="build pics" >}}

{{< img src="20210622_007.jpg" alt="build pics" >}}

## Other devices that didn't make the cut

*  [11th Generation Intel NUC](https://www.intel.com/content/www/us/en/products/details/nuc/kits/products.html)
    * This was an upgrade of the problems I had to begin with: U-Series processors (laptop chip) with poor cooling.
*  [Lenovo Tiny](https://www.lenovo.com/us/en/desktops-and-all-in-ones/thinkcentre/m-series-tiny/c/M-Series-Tiny), [HP Mini](https://store.hp.com/us/en/vwa/mini-desktops/form=Mini), and [Dell Micro](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/sr/desktops-n-workstations/optiplex-desktops/micro-small-78l-or-less?appliedRefinements=33718)
    * These were all basically the same devices, with different physical layouts: T-Series processors (low-power chip), a poor CPU heatsink, a blower fan, and limited expansion options.
*  [Dell Precision 3240 Compact](https://www.dell.com/en-us/work/shop/desktops-all-in-one-pcs/precision-3240-workstation/spd/precision-3240-workstation)
    * I really wanted to like this. It offered Intel Core or Xeon processors, the latter of which could use ECC memory, in a super-small form-factor.
    * It had [different heatsinks](https://dl.dell.com/topicspdf/precision-3240-workstation_owners-manual_en-us.pdf#_OPENTOPIC_TOC_PROCESSING_d111e10824) for the Core vs Xeon models, but both the Core ([one](https://www.reddit.com/r/Dell/comments/iy12iv/precision_3240_compact/), [two](https://forums.redflagdeals.com/dell-dell-precision-3240-compact-workstation-usff-2-3l-i3-10100-8g-279-313-i5-10500-8g-419-470-2403015/21/#p33901450), [three](https://www.reddit.com/r/Dell/comments/m6ao4k/does_anyone_use_a_dell_precision_3240_compact/gsbb4yc)) and Xeon ([one](https://www.reddit.com/r/Dell/comments/mv0vx4/feedback_on_precision_3240_compact_with_xeon/)) models suffered from poor thermals and loud fans.
*  [HPE ProLiant MicroServer Gen10 Plus](https://buy.hpe.com/us/en/servers/proliant-microserver/proliant-microserver/proliant-microserver/hpe-proliant-microserver-gen10-plus/p/1012241014)
    * The included Xeon processor (Xeon E-2224) was only 4c/4t and it didn't support QuickSync. Although you could physically replace the CPU, there was a BIOS limitation by HP that prevented QuickSync from working.
    * The included cooler and external PSU (180W) probably couldn't handle processors rated for more than 71W, which really limited my options for CPUs with more cores.
    * There was a single PCIe slot which I could use to install a small GPU (e.g., Nvidia Quadro P400), or run a PCIe-to-NVMe card for a boot drive, but not both.

# Hardware-specific things

## 11th Generation CPUs

### General issues

According to [this post](https://forum.asrock.com/forum_posts.asp?TID=18980&title=various-deskmini-h470-issues), there may be some problems with 11th Generation CPUs on the DeskMini H470. I purchased a 10th Generation CPU, so I can't confirm this. Just something to be aware of.

### BIOS update

The DeskMini H470 [BIOS](https://www.asrock.com/nettop/Intel/DeskMini%20H470%20Series/index.asp#BIOS) was recently updated to version v2.00 to support Intel 11th Generation CPUs. However, as confirmed by [this post](https://www.reddit.com/r/sffpc/comments/n6aidb/deskmini_h470_needs_bios_updatebut_has_no_video/), if your BIOS is v1.x, you can't update it to v2.x with an 11th Generation CPU installed. You would need a 10th Generation CPU to perform the update (unless you got lucky and your DeskMini H470 shipped with the v2.x BIOS already installed).

My device shipped with BIOS v2.10 (see the red circle below), so it _should_ support Intel 11th Generation CPUs out of the box.

{{< img src="20210622_003.jpg" alt="build pics" >}}

## Storage

The DeskMini H470 has four storage connections:

*  2x 2.5" HDD/SSD (proprietary SATA connector)
*  1x 2280 PCIe Gen3 NVMe SSD (M.2 connector)
*  1x 2280 PCIe Gen4 NVMe SSD (M.2 connector)
    *  This only works when using 11th Generation CPUs.

Right now, I'm running Proxmox and the VM storage on the same NVMe SSD. However, I will probably end up purchasing 2x SATA SSDs to run in RAID1 for VM storage.

## Motherboard flex

There is a little bit of motherboard flex from the cooler because this cooler does not have a backplate. Not sure if that will be a problem, I guess we'll see.

{{< img src="20210622_004.jpg" alt="build pics" >}}

If you zoom in, the red line is drawn between the two motherboard screws, and you can see a tiny gap between the red line and the motherboard.

{{< img src="20210622_005.jpg" alt="build pics" >}}

## Sensors and VRM temperatures

According to [this post](https://www.reddit.com/r/HomeServer/comments/l2qsh4/my_first_homeserver_running_esxi_7_nothing_like/gkcn5dt), the temperature sensor kernel driver (nct6683) is not loaded by default. I confirmed this was the case and loaded it manually.

Both [KitGuru](https://www.kitguru.net/desktop-pc/leo-waldock/asrock-deskmini-h470w-review-100c-vrms/) and [AnandTech](https://www.anandtech.com/show/16335/asrock-deskmini-h470-review-a-nofrills-lga1200-minipc-platform/10) commented about the high VRM temperatures on the DeskMini H470. However, ASRock is known to produce motherboards with [fake sensors](https://www.reddit.com/r/ASRock/comments/fwfsl7/vrm_constantly_above_100_c/), so I'm not sure if this is related. I'm also not sure which of these (if any) are the VRM sensors.

```
nct6683-isa-0a20
Adapter: ISA adapter
VIN0:           +0.58 V  (min =  +0.00 V, max =  +0.00 V)
VIN1:           +1.01 V  (min =  +0.00 V, max =  +0.00 V)
VIN2:           +1.02 V  (min =  +0.00 V, max =  +0.00 V)
VIN3:           +1.01 V  (min =  +0.00 V, max =  +0.00 V)
VIN7:           +1.20 V  (min =  +0.00 V, max =  +0.00 V)
VIN16:          +1.07 V  (min =  +0.00 V, max =  +0.00 V)
VCC:            +3.33 V  (min =  +0.00 V, max =  +0.00 V)
fan1:          1498 RPM  (min =    0 RPM)
fan2:             0 RPM  (min =    0 RPM)
Thermistor 12:  +43.0°C  (low  =  +0.0°C)
                         (high =  +0.0°C, hyst =  +0.0°C)
                         (crit =  +0.0°C)  sensor = thermistor
Thermistor 13:  +37.0°C  (low  =  +0.0°C)
                         (high =  +0.0°C, hyst =  +0.0°C)
                         (crit =  +0.0°C)  sensor = thermistor
PECI 0.0:       +45.5°C  (low  =  +0.0°C)
                         (high =  +0.0°C, hyst =  +0.0°C)
                         (crit =  +0.0°C)  sensor = Intel PECI
intrusion0:    OK
beep_enable:   disabled

pch_cometlake-virtual-0
Adapter: Virtual device
temp1:        +63.0°C

coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +49.0°C  (high = +84.0°C, crit = +100.0°C)
Core 0:        +47.0°C  (high = +84.0°C, crit = +100.0°C)
Core 1:        +41.0°C  (high = +84.0°C, crit = +100.0°C)
Core 2:        +49.0°C  (high = +84.0°C, crit = +100.0°C)
Core 3:        +44.0°C  (high = +84.0°C, crit = +100.0°C)
Core 4:        +42.0°C  (high = +84.0°C, crit = +100.0°C)
Core 5:        +47.0°C  (high = +84.0°C, crit = +100.0°C)
```

## Linux e1000e driver

There is a known issue where the Intel NIC e1000e kernel driver can crash/hang when under heavy load. In my case, this happened when my VM for backups was pushing data up to the cloud. Below is what I saw in `dmesg` on the Proxmox host.

```
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] e1000e 0000:00:1f.6 eno1: Detected Hardware Unit Hang:
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   TDH                  <a5>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   TDT                  <40>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   next_to_use          <40>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   next_to_clean        <a4>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] buffer_info[next_to_clean]:
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   time_stamp           <1008e50da>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   next_to_watch        <a5>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   jiffies              <1008e5848>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931]   next_to_watch.status <0>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] MAC Status             <40080083>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] PHY Status             <796d>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] PHY 1000BASE-T Status  <3c00>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] PHY Extended Status    <3000>
Jun 22 21:40:32 proxmox02 kernel: [37615.515931] PCI Status             <10>
```

Below is the output from `lspci -v` on the Proxmox host. You can see I'm using the `e1000e` driver.

```
00:1f.6 Ethernet controller: Intel Corporation Device 0d4d
        Subsystem: ASRock Incorporation Device 0d4d
        Flags: bus master, fast devsel, latency 0, IRQ 137
        Memory at b1200000 (32-bit, non-prefetchable) [size=128K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Kernel driver in use: e1000e
        Kernel modules: e1000e
```

This crash/hang happens because the NIC has hardware offload capabilities, but it can't keep up with the amount of data being pushed through. The fix (as documented in [this](https://forum.proxmox.com/threads/e1000-driver-hang.58284/) large Proxmox-specific thread) is to disable offloading and let everything be handled by the CPU. In my case, I only disabled tcp-segmentation-offload, generic-segmentation-offload, and generic-receive-offload.

The following snippet is from my _/etc/network/interfaces_ file on the Proxmox host.

```
auto eno1
iface eno1 inet manual
    offload-tso off
    offload-gso off
    offload-gro off
```

After a reboot of the host, you can verify the settings using `ethtool -k eno1`. Again, this is not specific to ASRock or Proxmox, it seems to be any Linux distribution using the e1000e driver.



# Conclusion

So far, I'm only a few days into this new hypervisor, but it's already leaps and bounds better than the NUC, especially under any sort of load.

{{< img src="20210622_008.jpg" alt="mini-rack on shelf" >}}

-Logan

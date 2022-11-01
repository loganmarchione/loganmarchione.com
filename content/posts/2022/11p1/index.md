---
title: "Linux on the Lenovo ThinkPad T14 Gen2 (AMD)"
date: "2022-11-11"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_tux.svg"
    alt: "featured image"
    relative: false
---

# Introduction

My only PC is a desktop, where I dual boot Windows (for gaming only) and Linux (for everything else). My work provided me with Macbook (read more about that [here](/2022/04/impressions-from-a-first-time-mac-user/)), but I don't use it to manage my personal servers, write personal code, browse the internet, etc... But, it would be really nice to SSH to a server from my couch (on a device that's not my phone). I figured it was time to get a laptop. I was looking for:

- a CPU from within the last 5 years
- 16GB RAM
- SSD (not going to store anything critical on this device)
- full-size RJ-45 ethernet, HDMI, USB, etc...
- WiFi 6
- USB-C charging
- 1080p display (4k is too small on a laptop)
- $700 or under

Naturally, the internet suggested a ThinkPad T-series laptop. Seeing as this wouldn't be my main machine, I decided to purchase something refurbished from the [Lenovo Outlet](https://www.lenovo.com/us/outletus/en/) (their stuff is about 10% off new prices).

# Specs

I ended up purchasing a Lenovo ThinkPad T14 Gen2 (AMD) from the Lenovo Outlet. I've never purchased from the Lenovo Outlet before, but the model number I purchased online is not exactly the same as what showed up to my house. I'm not sure of the differences, but they're both part of the `20XK` family, so it might not matter. :man_shrugging:

- Model number on Lenovo Outlet and sticker on outside of laptop = 20XKX026US
- Model number in software and sticker on inside of laptop = 20XK005PUS

For all intents and purposes, it looked like a brand new machine, minus all the paperwork and foam.

{{< img src="20221028_002.jpeg" alt="thinkpad t14 gen2 amd" >}}

{{< img src="20221028_003.jpeg" alt="thinkpad t14 gen2 amd" >}}

{{< img src="20221028_004.jpeg" alt="thinkpad t14 gen2 amd" >}}

## Stock

Regardless of model number, [here](https://www.lenovo.com/us/outletus/en/p/laptops/thinkpad/thinkpadt/t14-g2-amd/20xkx026us) is the link to what I purchased. I paid $569.99, which I thought was a good deal. Below are the specs of the  model that showed up to my house.

| Part          | Spec                                                                                                                                       | Comments                                  |
|---------------|--------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| CPU           | AMD Ryzen 5 PRO 5650U                                                                                                                      | Zen3, 7nm, 6c/12t, up to 4.2GHz, 15W TDP  |
| Graphics      | AMD Radeon Vega 7 Graphics                                                                                                                 | 7 GPU cores, up to 1.8GHz                 |
| RAM           | 8GB DDR4 3200MHz (soldered to motherboard)                                                                                                 | one open SODIMM slot                      |
| Storage       | 256GB PCIe Gen3 x4 SSD                                                                                                                     | SKHynix_HFS256GDE9X081N                   |
| Display       | 14.0" FHD (1920x1080) IPS, anti-glare, 300 nits, non-touch                                                                                 |                                           |
| Camera        | 720P HD with Array Microphone & ThinkShutter                                                                                               |                                           |
| WLAN          | Qualcomm WCN685x WiFi 6E                                                                                                                   |                                           |
| LAN           | RealTek RTL8168/8111                                                                                                                       | 2x of these (I think one is USB-C)        |
| Battery       | Integrated Li-Polymer 50Wh battery                                                                                                         |                                           |
| Power Supply  | 65W                                                                                                                                        |                                           |

## Upgraded

Below are the parts I upgraded right out of the box.

| Part          | Spec                                                                                                                                                       | Comments                                          |  
|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| RAM           | [Crucial 8GB Laptop DDR4 3200 MHz SODIMM](https://www.bhphotovideo.com/c/product/1576454-REG/crucial_ct8g4sfra32a_8gb_ddr4_3200_mt_s.html) (CT8G4SFRA32A)  | 8GB soldered to motherboard plus 8GB DDR4 SODIMM  |
| WLAN          | [Intel AX200 WiFi 6](https://www.bhphotovideo.com/c/product/1591690-REG/intel_ax200_ngwg_dtk_wi_fi_6_gig_desktop.html) (AX200.NGWG.DTK)                    | Replaced stock Qualcomm WCN685x                   |

# Initial setup

I booted into the default Windows install just to make sure everything worked, then updated the BIOS.

Once that was done, I swapped out the WiFi card and added a stick of DDR4 SODIMM memory. For a large OEM, Lenovo has some really great [documentation](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-t-series-laptops/thinkpad-t14-gen-2-type-20xk-20xl/document-userguide) on their site for how to open the laptop up and access almost every part. Not as detailed as the [Framework laptop documentation](https://guides.frame.work/c/Framework_Laptop), but impressive nonetheless.

The screws on the case back were captive, which was a nice touch. There were about a dozen small clips that were almost impossible to open without a guitar pick or [opening set](https://www.ifixit.com/products/prying-and-opening-tool-assortment) from iFixit (I destroyed my credit card trying to use it as an opening tool). I would recommend opening the back **only once**, so make sure you have all the parts you need ahead of time.

{{< img src="20221028_001.png" alt="base cover removal" >}}

I tried to block out as many serial numbers as possible, but you can see the single SODIMM slot in the middle (under the black plastic), the SSD and WiFi modules in the top-right in an "L" shape, with the space for the WWAN module under the black plastic between them (there is a full-size image [here](/2022/11/linux-on-the-lenovo-thinkpad-t14-gen2-amd/20221028_005.jpeg)).

{{< img src="20221028_005.jpeg" alt="thinkpad t14 gen2 amd" >}}

I started it up one more time to make sure everything still worked, then tested the new memory stick. I always test my memory before I use it, and I always recommend [Memtest86](https://www.memtest86.com/download.htm) (not to be confused with [Memtest86+](https://www.memtest.org/)).

# Arch Linux

I had done my research before selecting this model and found an [ArchWiki page](https://wiki.archlinux.org/title/Lenovo_ThinkPad_T14_(AMD)_Gen_2) on it, so I knew Arch should work.

I always [install Arch](https://wiki.archlinux.org/title/installation_guide) manually from a wiki I keep in my homelab (on [DokuWiki](https://www.dokuwiki.org/dokuwiki)), but maybe one day I'll try [archinstall](https://wiki.archlinux.org/title/archinstall). I've done it manually enough times that the whole thing takes about 15 minutes now.

I'm a caveman, so I don't use swap, suspend, or sleep. I shutdown my PC every time I'm done with it, then re-enter my encryption passphrase at every boot. I generally do ESP+GPT+LUKS2+SystemD boot (example below).

```
+----------------------------+ +---------------------------------------------------------------------------+
|                            | |                                                                           |
| EFI System Partition (ESP) | | LUKS2 encrypted partition                                                 |
|                            | |                                                                           |
|                            | |                                                                           |
|                            | |                                                                           |
| FAT32                      | | XFS                                                                       |
| /boot                      | | /                                                                         |
|----------------------------| |---------------------------------------------------------------------------|
| /dev/nvme0n1p1             | | /dev/nvme0n1p2                                                            |
+----------------------------+ +---------------------------------------------------------------------------+
+----------------------------------------------------------------------------------------------------------+
|                                                                                                          |
|                                            /dev/nvme0n1                                                  |
|                                                                                                          |
+----------------------------------------------------------------------------------------------------------+
```

Once I get to the [post-installation](https://wiki.archlinux.org/title/installation_guide#Post-installation) section of the installation, I use an [Ansible playbook](https://github.com/loganmarchione/ansible-arch-linux) to setup my packages, desktop, settings, etc... This allows me to keep my desktop and laptop setup consistent.

I've been using it on and off for about a week.

# Conclusion

\-Logan
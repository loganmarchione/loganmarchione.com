---
title: "Asus PCE-AX3000 on Linux"
date: "2022-09-27"
author: "Logan Marchione"
categories: 
  - "oc"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_generic_wifi.svg"
    alt: "featured image"
    relative: false
---

# Introduction

This post serves no real purpose other than to match SEO keywords for people searching for PCIe WiFi cards for Linux.

My desktop is on the third floor of my house, unfortunately without wired internet. I've been using a PCIe 802.11n (WiFi 4) card since 2016 and realized it's time to upgrade. 

[TP-Link TL-WDN4800](https://www.tp-link.com/us/home-networking/pci-adapter/tl-wdn4800/)

* Qualcomm Atheros AR9380 chipset
* 802.11a - 54Mbps
* 802.11b - 11Mbps
* 802.11g - 54Mbps
* 802.11n - 450Mbps (WiFi 4)
* WPA/WPA2

{{< img src="20220927_001.jpg" alt="TP-Link TL-WDN4800" >}}

# Comparison

My access point is a [UniFi UAP-AC-PRO](https://store.ui.com/products/uap-ac-pro), so at the very least, I wanted 802.11ac (WiFi 5) on the PCIe card. I also knew I wanted to stick with Intel wireless cards, since their drivers are generally available in every Linux distribution (even if they're blobs).

I considered purchasing [this Silverstone PCIe-->M.2 adapter](https://silverstonetek.com/en/product/info/expansion-cards/ECWA2-LITE/) and the [Intel AX200 M.2 card](https://www.bhphotovideo.com/c/product/1591690-REG/intel_ax200_ngwg_dtk_wi_fi_6_gig_desktop.html), but was too lazy and wanted a complete product.

I considered the cards below, but they all had external antennas, which I didn't want.

* Gigabyte GC-WBAX210 (WiFi 6E using Intel AX210)
* Gigabyte GC-WBAX200 (WiFi 6 using Intel AX200)
* Asus PCE-AXE58BT (WiFi 6E using Intel AX210)
* Asus PCE-AX58BT (WiFi 6 using Intel AX200)

Ultimately, I went with the [Asus PCE-AX3000](https://www.asus.com/us/Networking-IoT-Servers/Adapters/All-series/PCE-AX3000/), which has built-in antennas. It has WiFi 6, so I could upgrade my AP later and take advantage of better speeds. It also has Bluetooth, which I didn't connect.

* Intel AX200 chipset
* 802.11a - 54Mbps
* 802.11b - 11Mbps
* 802.11g - 54Mbps
* 802.11n - 300Mbps (WiFi 4)
* 802.11ac - 1733Mbps (WiFi 5)
* 802.11ax - 2402Mbps (WiFi 6)
* WPA/WPA2/WPA3
* Bluetooth 5.0

{{< img src="20220927_002.jpg" alt="Asus PCE-AX3000" >}}

# Speed test

Keep in mind my connection to the internet is 400/400Mbps Verizon FiOS. I'm also on the third floor of my house, with the AP on the first floor.

Below is the TP-Link TL-WDN4800.

{{< img src="20220926_001.jpeg" alt="speed test before" >}}

Below is the Asus PCE-AX3000.

{{< img src="20220926_002.jpeg" alt="speed test after" >}}

# Conclusion

Needless to say, I'm very happy with the Asus card!

\-Logan
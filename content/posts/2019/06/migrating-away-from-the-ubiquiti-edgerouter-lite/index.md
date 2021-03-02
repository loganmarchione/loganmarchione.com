---
title: "Migrating away from the Ubiquiti EdgeRouter Lite"
date: "2019-06-28"
author: "Logan Marchione"
categories: 
  - "cloud-internet"
  - "linux"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_ubiquiti_edgemax.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_ubiquiti %}}

# Introduction

For years, I've been using and loving my [Ubiquiti EdgeRouter Lite](https://www.ui.com/edgemax/edgerouter-lite/). For about $100, you're not going to find a router with more features. In fact, most of Ubiquiti's offerings are a very good value for the money. However, in the past year or so, Ubiquiti has seemed to have some issues with what direction they want to take as a company:

- A (seemingly pointless) re-brand from Ubiquiti/UBNT to UI.com (I wonder how much that domain name cost them)
- A (seemingly pointless) re-work of their [forum software](https://community.ui.com/) (it's much more unorganized now)
- They (Ubiquiti) regularly ignored some of the most upvoted/requested ideas on their forums (which ironically, don't exist on the new forum) to pursue new products
    - They released the [FrontRow wearable camera](https://www.frontrow.com/) (not sure who asked for this product to exist)
    - They released a series of [network-connected LED lights and dimmer switches](https://unifi-led.ui.com/)
    - They released a series of [VoIP phones](https://www.ui.com/unifi-voip/overview/)
- They released the EdgeMax v2.0.0 firmware and almost immediately pulled it because of its [beta-level quality](https://www.reddit.com/r/Ubiquiti/comments/adiss6/edgemax_edgerouter_software_release_v200_ubiquiti/). All releases since v2.0.0 seem to have had issues as well.
- They deprecated UniFi Video in favor of UniFi Protect (which only runs on Ubiquiti hardware)
- They put [ads for UniFi Protect](https://community.ui.com/questions/How-to-remove-this-ridiculous-ad-for-Unifi-Protect-from-UFV-installations/b99f9c81-f0e1-4015-b5f3-122035f21811) inside existing UniFi Video installations
- They [removed SNMP](https://community.ui.com/questions/Why-was-SNMP-removed-from-v2-0-0-EdgeSwitch-FW/d06ea655-5042-4263-8603-39e04c6bf98e) from EdgeSwitch firmware
- They added [phone-home telemetry](https://community.ui.com/questions/UI-official-urgent-please-answer/14259289-e4c3-4c5e-aaa0-02a5baa6cbbe) to the UniFi Wireless firmware

It seems that Ubiquiti is throwing shit at a wall and seeing what sticks. Don't get me wrong, I'd still recommend the EdgeRouter line to anyone who is currently using a router from BestBuy. However, I was growing tired and nervous of Ubiquiti's decision making, so I resolved to replace my EdgeRouter with something slightly more stable and focused.

# Requirements

## Hardware

In terms of raw power, the EdgeRouter Lite is only a 500Mhz dual core MIPS CPU with 512MB of DDR2 RAM, so the bar was set pretty low. I knew I was going to be looking for a mini-PC form-factor, and only had a few requirements:

- Hardware that is small, low power, and fanless (this device is in my living room, not a server rack)
- Have Intel NICs (they generally have better compatibility with Linux/BSD than Realtek)
- Be around $250 or less, including RAM (but not storage)

With that said, below are the devices that I came up with in my search.

| Device | Link | Price | CPU | RAM | Storage | NICs | Price with 4GB RAM, no storage | BIOS updates | Comments |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Jetway JBC313U591W-3160-B | [Amazon](https://www.amazon.com/Jetway-JBC313U591W-3160-B-Braswell-Celeron-Barebone/dp/B01M25WO36) | $249 | Quad Core Intel Celeron N3160 @ 1.60GHz | Up to 8GB DDR3 | mSATA | 2x Intel i211-AT | $273 | [Infrequent](https://www.jetwaycomputer.com/JBC313U591.html) |  |
| APU2D4 | [PC Engines](https://www.pcengines.ch/newshop.php?c=4) | $134 | Quad Core AMD GX-412TC @ 1.00 GHz | 4GB DDR3 (included) | mSATA | 3x Intel i210-AT | $134 | [Very frequent](https://pcengines.github.io/) | Supports Coreboot |
| Fitlet 2 | [Fitlet](https://fit-iot.com/web/product/fitlet2-build-to-order/) | $193 | Quad Core Intel Celeron J3455 @ 1.50GHz | Up to 16GB DDR3 | M.2 | 2x Intel i211-AT | $222 | [Infrequent](http://www.fit-pc.com/wiki/index.php/Fitlet2:_BIOS_Files) |  |
| Protectli FW2B | [Protectli](https://protectli.com/product/fw2b/) | $179 | Dual Core Intel Celeron J3060 @ 1.60 GHz | Up to 8GB DDR3 | mSATA | 2x Intel i211-AT | $206 | [Infrequent](https://protectli.com/kb/bios-versions-for-the-vault/) | Supports Coreboot |
| Shuttle DS77U | [Amazon](https://www.amazon.com/SHUTTLE-DS77U-Celeron-1-8GHz-Barebone/dp/B06WXXD247) | $262 | Dual Core Intel Celeron 3865U @ 1.80 GHz | Up to 32GB DDR4 | 2.5" SATA and M.2 | 1x Intel i211 and 1x Intel i219-LM | $281 | [Frequent](http://global.shuttle.com/products/productsDownload?productId=2115) |  |
| Netgate SG-1100 | [Netgate](https://store.netgate.com/pfSense/SG-1100.aspx) | $159 | Dual Core ARM Cortex A53 @ 1.20 GHz | 1GB DDR4 (included) | 8GB eMMC | 3x NICs (assuming Intel?) | $159 | Unknown | A customized [ESPRESSObin](https://espressobin.net/) |

## Software

I have a relatively simple setup at home, so my requirements for a router OS were simple:

- DHCP
    - leases and static mapping
- DNS
    - Set internal domain name
    - DNS forwarder
    - Register DHCP leases and static mappings in DNS resolver
    - Host overrides (e.g., CNAME records)
    - Dynamic DNS updater
- Firewall
- 802.1Q VLANs
- Remote logging (to a remote server)

I considered [Untangle NG Firewall](https://www.untangle.com/get-untangle/), [Sophos UTM Home Edition](https://www.sophos.com/en-us/products/free-tools/sophos-utm-home-edition.aspx), [Sophos XG Firewall Home Edition](https://www.sophos.com/en-us/products/free-tools/sophos-xg-firewall-home-edition.aspx), [ZeroShell](https://zeroshell.org/download/), [IPFire](https://www.ipfire.org/download), [ClearOS Community Edition](https://www.clearos.com/clearfoundation/software/clearos-downloads), [Smoothwall Express](http://www.smoothwall.org/download/), and [Endian](https://www.endian.com/community/download-list/), but chose not to pursue them because they were either proprietary, had limited functionality, or were abandoned completely. In the end, I narrowed my search down to [pfSense](https://www.pfsense.org/download/), [OPNsense](https://opnsense.org/download/), and [VyOS](https://downloads.vyos.io/).

{{< procon/routers >}}

# pfSense on the Netgate SG-1100

At first, I considered using the Shuttle DS77U with VyOS. However, VyOS is really made for advanced routing, which is not what I needed. Then, I thought about still using the DS77U, but with pfSense. However, I really wanted to support the pfSense project by purchasing from Netgate, and in my price range, my only option was the SG-1100. Even though x86 hardware arguably has more raw power than ARM hardware, the SG-1100 is no slouch. The ARM hardware is very specialized and can route at full gigabit (as seen by [Lawrence Systems](https://www.youtube.com/watch?v=_bM3XqK5JzE)) and it has received some [really great Reddit reviews](https://www.google.com/search?hl=en&q=sg-1100+review+site%3Areddit.com).

{{< img src="20190626_001.jpg" alt="sg-1100" >}}

## The first ten minutes

Having never used pfSense before, I spent the first few minutes poking around in the web interface. The web GUI is snappy, and the device doesn't seem to run too hot.

{{< img src="20190626_002.png" alt="pfsense dashboard screenshot" >}}

## The first 24 hours

Before buying the SG-1100, I spent a good bit of time looking at my EdgeRouter configuration file and Googling how to duplicate it in pfSense. After going through the initial setup wizard,  I went through the following tasks to port my EdgeRouter configuration over to pfSense.

- Setup new user accounts
- Setup my DHCP server
- Setup DHCP static mappings
- Setup CNAME records (which pfSense calls "host overrides")
- Setup port forwarding rules
- Setup firewall rules
- Setup dynamic DNS
- Setup remote logging
- Setup configuration backup

I then shutdown all of my servers/devices, swapped out the routers, and powered up the SG-1100. To no one's surprise, the SG-1100 booted up flawlessly and started handing out IP addresses.

# pfSense vs EdgeOS

Obviously pfSense is going to be different than EdgeOS, but in the first day or two, a few things stuck out immediately.

- pfSense is based on FreeBSD, while EdgeOS is based on Debian Linux. I know nothing about how FreeBSD works under the hood, so my fear of the command-line is much greater on pfSense than on EdgeOS.
- That being said, pfSense has almost no command-line configuration. All of the configuration is done via the web interface, which has more options than I'll ever use. Comparatively, EdgeOS had a relatively mediocre web interface, with all the advanced configuration being done via the command-line.
- The firewall setup on pfSense is very different from EdgeOS. I was used to a [zone-based firewall](https://help.ubnt.com/hc/en-us/articles/204952154-EdgeRouter-Zone-Based-Firewall) with EdgeOS, but pfSense uses a more traditional interface-based firewall.
- pfSense has an implicit deny on the WAN inbound interface, and an implicit allow on the LAN outbound interface. EdgeOS only has this if you follow the setup wizard, whereas if you setup EdgeOS by hand, those rules are not there by default.

Both pfSense and EdgeOS can route gigabit, and both are able to utilize my 400/400Mbps FiOS internet connection. Running the command below to download 500Mb test file, I'm able to max out my connection with both routers, so I have no complaints there.

```
wget --report-speed=bits --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip
```

I'll spend the next few days tweaking all my pfSense settings, and then working on getting logging setup to push pfSense firewall logs to Graylog. Until then, I'm a happy SG-1100 and pfSense user!

\-Logan

# Comments

[Old comments from WordPress](/2019/06/migrating-away-from-the-ubiquiti-edgerouter-lite/comments.txt)
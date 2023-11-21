---
title: "Beryl travel router with OpenWrt"
date: "2024-01-01"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_openwrt.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_openwrt %}}

# Introduction

It's been over seven years since I last touched OpenWrt. :exploding_head:

I'm going on a couple of trips in the next few months and I need VPN access back to my homelab. I could setup WireGuard on each client device, but I thought it would be fun to setup WireGuard on a travel router (and to revisit OpenWrt to see what's changed).

# Design

## Network overview

## Hardware

The trick with OpenWrt is not to get something too old (because it will have bad specs and be slow), but also not get something too new (because it won't be supported yet).

I was looking for something that had the following features:

* physically small (it's for travel, after all)
* [good OpenWrt support](https://openwrt.org/toh/recommended_routers) (preferably with stable support, not snapshot images)
* dual-core CPU
* at least 128MB of RAM
* at least 16MB of flash storage (so I'm not having to expand storage onto an [extroot](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration) like I [used to do](https://loganmarchione.com/2015/02/openwrt-with-openvpn-client-on-tp-link-tl-mr3020/#configure-extroot))
* at least two ethernet ports (WAN and LAN)
* at least two radios (WAN and LAN)
* preferably had USB-C power input
* preferably had 802.11ac (WiFi 5)

It just so happens that [GL.iNet](https://www.gl-inet.com/) make a bunch of full-size and travel routers that all run a custom version of OpenWrt. This was a great starting place, and I started looking at the OpenWrt [Table of Hardware](https://openwrt.org/toh/start) (ToH). The GL.iNet hardware was perfectly suited to my use case, so it was just a matter of picking a model that had the specs I wanted and was easily available. I ended up choosing the [Beryl (GL-MT1300)](https://www.gl-inet.com/products/gl-mt1300/).

{{< figure src="20231121_001.jpg" width="100%" alt="beryl (GL-MT1300)" attr="Image from GL.iNet" attrlink="https://www.gl-inet.com/products/gl-mt1300/">}}

{{< figure src="20231121_002.jpg" width="100%" alt="beryl (GL-MT1300)" attr="Image from GL.iNet" attrlink="https://www.gl-inet.com/products/gl-mt1300/">}}

{{< figure src="20231121_003.jpg" width="100%" alt="beryl (GL-MT1300)" attr="Image from GL.iNet" attrlink="https://www.gl-inet.com/products/gl-mt1300/">}}

{{< figure src="20231121_004.jpg" width="100%" alt="beryl (GL-MT1300)" attr="Image from GL.iNet" attrlink="https://www.gl-inet.com/products/gl-mt1300/">}}

{{< figure src="20231121_005.jpg" width="100%" alt="beryl (GL-MT1300)" attr="Image from GL.iNet" attrlink="https://www.gl-inet.com/products/gl-mt1300/">}}

I also considered these models:

* [MikroTik mAP](https://mikrotik.com/product/RBmAP2nD)
* [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) (like [NetworkChuck](https://www.youtube.com/watch?v=jlHWnKVpygw) used)
* [TP-Link TL-WR902AC](https://www.tp-link.com/us/home-networking/wifi-router/tl-wr902ac/) (this appears to be an upgraded version of the TL-MR3020 that I used to have)
* One of the various [FriendlyElec NanoPi boards](https://www.friendlyelec.com/index.php?route=product/category&path=69)
* the newer [Beryl AX (GL-MT3000)](https://www.gl-inet.com/products/gl-mt3000/) (isn't yet supported by OpenWrt)
* the [Slate Plus (GL-A1300)](https://www.gl-inet.com/products/gl-a1300/)

## Software

GL.iNet's routers all run a custom version of OpenWrt. I'm unsure if the core OpenWrt code is stock, but at the very least, they run a proprietary (i.e., closed-source) UI on top of OpenWrt (although they do still let you [access LuCI](https://docs.gl-inet.com/router/en/4/faq/what_is_luci/)). Their UI looks great and exposes a bunch of one-click options that simplify setup.

PICTURES GO HERE

This is the part where I mention that GL.iNet is a Chinese company, if that kind of thing bothers you. Regardless of that, I'd never run anything proprietary for something that's handing out VPN access to my network, so my plan was always to immediately replace GL.iNet's version of OpenWrt with the stock version.

# Setup

## Install OpenWrt

OpenWrt has two kinds of installations:



## Configure OpenWrt



# Conclusion


\-Logan
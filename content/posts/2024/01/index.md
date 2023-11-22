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

GL.iNet's routers all run a custom version of OpenWrt. I'm unsure if the core OpenWrt code is stock, but at the very least, they run a proprietary (i.e., closed-source) UI on top of OpenWrt (although they do still let you [access LuCI](https://docs.gl-inet.com/router/en/4/faq/what_is_luci/)). Their UI looks great and exposes a [bunch of one-click options](https://docs.gl-inet.com/router/en/3/setup/gl-mt1300/first_time_setup/) that simplify setup.

* OpenVPN client/server
* WireGuard client/server
* Repeater
* 3G/4G modem
* Tethering
* Captive portal
* Dynamic DNS (DDNS)
* Hardware button settings

This is the `3.x` version of the UI.

{{< img src="20231121_006.png" alt="gl.inet default user interface" >}}

This is the `4.x` version of the UI.

{{< img src="20231121_007.png" alt="gl.inet default user interface" >}}

Unfortunately, this is the part where I mention that GL.iNet is a Chinese company, if that kind of thing bothers you. Regardless of that, I'd never run anything proprietary for something that's handing out VPN access to my network, so my plan was always to immediately replace GL.iNet's version of OpenWrt with the stock version.

# Setup

## Install OpenWrt

OpenWrt has two kinds of installations:

* installing from vendor firmware (called a [factory installation](https://openwrt.org/docs/guide-quick-start/factory_installation))
* upgrading OpenWrt (called a [sysupgrade](https://openwrt.org/docs/guide-quick-start/sysupgrade.luci))

Because the Beryl already ran a version of OpenWrt from GL.iNet, I needed to do a sysupgrade. The installation process was pretty simple, and I've summarized the steps from the [wiki page for the Beryl](https://openwrt.org/toh/gl.inet/gl-mt1300_v1):

1. On my laptop, I went to the [OpenWrt Firmware Selector](https://firmware-selector.openwrt.org/) (this was much easier than navigating the [firmware directories](https://downloads.openwrt.org/releases/)), found my [model](https://firmware-selector.openwrt.org/?version=23.05.2&target=ramips%2Fmt7621&id=glinet_gl-mt1300), downloaded the `sysupgrade` file, and verified the `sha256` hash of the file
1. Connected to the Beryl's LAN port (which after booting, gave me an IP in the `192.168.8.x` range)
1. Browsed to [http://192.168.8.1/](http://192.168.8.1/), went through the setup wizard, then browsed to [http://192.168.8.1/#/upgrade](http://192.168.8.1/#/upgrade) and uploaded the `sysupgrade` file
1. Hit an error that read `
failed! ERROR: Incorrect firmware format!`
1. Upgraded the factory firmware from `3.211` to `3.216` to `4.3.7` from [this page](https://dl.gl-inet.com/?model=mt1300)
1. Repeated step 3, waited 5 mins, and rebooted into OpenWrt at [https://192.168.1.1/](https://192.168.1.1/)!

## Configure OpenWrt

OpenWrt has a really great configuration system. It stores its configuration files in `/etc/config` in a system known as the [Unified Configuration Interface](https://openwrt.org/docs/guide-user/base-system/uci) (UCI). The UCI is basically a collection of easy-to-read configuration files that are all centrally located, making OpenWrt much easier to configure. You can edit these files manually with `vi` or `nano`, but there is also a [command line tool](https://openwrt.org/docs/guide-user/base-system/uci) called `uci` that you can use to edit the files (great for scripting).

The web interface for OpenWrt is called [LuCI](https://openwrt.org/docs/guide-user/luci/start) (I'm guessing it's short for Lua UCI, because it's written in Lua).   What's nice about LuCI is that it reads/writes from/to the UCI files. Any changes you make in LuCI are reflected in the UCI files, and vice versa, meaning you can configure OpenWrt from the web interface, or from the command line.

### Initial login

Navigate to [https://192.168.1.1/](https://192.168.1.1/) in your browser and you'll be greeted by an SSL error. This is because the web interface uses a [self-signed certificate](https://openwrt.org/docs/guide-user/luci/luci.secure) out of the box. It's safe to click through this, since your traffic is encrypted and you know the certificate is from the router (or you can browse to [http://192.168.1.1/](http://192.168.1.1/) without HTTPS).

Moving on. Leave the username as "root" and the password field empty.

{{< img src="20231121_008.png" alt="openwrt login page" >}}

Click on _Login_ to continue and you'll see the status page.

{{< img src="20231121_009.png" alt="openwrt status page" >}}

### Set a password

From the main status page, we're going to set a root password by using the link in the yellow box at the top of the page. Here, you can (and should) set a root password. Click on _Save_ to continue.

{{< img src="20231121_010.png" alt="openwrt password change page" >}}

Also, you can now SSH into the router with those credentials.

```
> ssh root@192.168.1.1 
root@192.168.1.1's password: 


BusyBox v1.36.1 (2023-11-14 13:38:11 UTC) built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 23.05.2, r23630-842932a63d
 -----------------------------------------------------
root@OpenWrt:~#
```

### Set hostname

First, set a hostname for the device and reboot.

```
uci set system.@system[0].hostname='OpenWrt_TR'
uci commit system
reboot
```

### Secure SSH

SSH is listening on all interfaces (LAN and WAN). I like to only be able to SSH via the LAN interface. Use the commands below to change that.

```
uci set dropbear.@dropbear[0].Interface='lan'
uci commit dropbear
service dropbear restart
```

### LAN settings

Next, we're going to change the default IP of the router from `192.168.1.1` to `10.70.74.1` (or whatever scheme you want). Most devices ship with `192.168.1.1` as the default, and since we're going to be double-NATed, we can't have two identical IPs on the same network. We'll also set DNS here.

```
uci set network.lan.ipaddr='10.70.74.1'
uci set network.lan.force_link='1'
uci set network.lan.dns='8.8.8.8 1.1.1.1'
uci commit network
service network restart
```

Login again at the new address (not `192.168.1.1`).

### Devices vs interfaces

Now we need to clarify some terms. In OpenWrt, a "device" is a Linux kernel network device, like `eth0`, but also includes virtual devices like the default bridge called `br-lan`. You can see devices by typing `ip link show` on the command line (they're the entries without the `@` symbol).

An "interface" is a logical configuration associated with a specific device that allows you to define and manage network settings (e.g., IP addresses, subnet masks, security settings...). Confusingly, the devices and interfaces can (and do) sometimes have the same name by default (e.g., the `wan` interface is bound to the `wan` device).

In terms of wireless, a "radio" is a device (e.g., `radio0`), but it also has an interface (e.g., `default_radio0`) where you can setup your wireless networks.

### Setup wireless WAN

First, we're going to create a wireless WAN interface called `wwan`.

```
uci set network.wwan='interface'
uci set network.wwan.proto='dhcp'
uci set network.wwan.peerdns='0'
uci set network.wwan.dns='8.8.8.8 1.1.1.1'
uci commit network
service network restart
```

Next, we need to enable both wireless radios and change the country code (adjust as needed).

```
uci set wireless.radio0.disabled='0'
uci set wireless.radio1.disabled='0'
uci set wireless.radio0.country='US'
uci set wireless.radio1.country='US'
uci commit wireless
service network restart
```

This next part is easier to do in the web interface. In LuCI, go to _Network_, then _Wireless_. You can see here that the Beryl has two radios (`radio0` and `radio1`) each with an interface broadcasting a WiFi network called `OpenWrt`. You'll need to decide which radio will be the WAN and which will be the LAN, but keep in mind that one is 2.4GHz and one 5GHz.

{{< img src="20231121_011.png" alt="openwrt wireless page" >}}

I've never seen a hotel with great WiFi, so I'm going to make the 2.4GHz radio (`radio0`) my wireless WAN, and have the 5GHz radio (`radio1`) as my wireless LAN. This also works for me because all of my devices that will be on the wireless LAN support 5GHz. To set this up, go to `radio0` and click on _Scan_ (if you're using the opposite radio, you'll need to adjust the rest of this tutorial as needed).

{{< img src="20231121_012.png" alt="openwrt wireless page" >}}

Here, you'll see all of the WiFi networks around you. I'm going to pick my home network for the setup, but at the hotel, **you'll do this same process again to select their WiFi**.

{{< img src="20231121_013.png" alt="selecting a wifi network" >}}

Make sure you check the box that says _Replace wireless configuration_, then enter your network's WiFi password, click on _Submit_.

{{< img src="20231121_014.png" alt="joining a wifi network" >}}

You can change the channel info here if you want. Past that, scroll down and make sure the _Network_ is set to `wwan` (the interface we created earlier), and click on _Save_.

{{< img src="20231121_015.png" alt="wifi network settings" >}}

Back on the wireless page, click on _Save & Apply_.

{{< img src="20231121_016.png" alt="openwrt wireless page" >}}

At this point, the Beryl should be online and able to reach the internet.

```
ping google.com
```

### Setup wireless LAN

Now we need to setup the WiFi on the wireless LAN. Start by going back to wireless page in LuCI and click on _Edit_ on the WiFi network of `radio1`.

{{< img src="20231121_017.png" alt="openwrt wireless page" >}}

You can change the channel info here if you want. Past that, scroll down, and on the _General Setup_ tab, change the _ESSID_ to whatever you want to broadcast (I'm calling mine `OpenWrt_Travel_Router`) and make sure the _Network_ is set to `lan`.

{{< img src="20231121_018.png" alt="wifi network settings" >}}

Then, on the _Wireless Security_ tab, change the _Encryption_ type to whatever you want. I'm going with `WPA3-SAE`, but if you have legacy devices that don't support WPA3, you might want to go with `WPA2-PSK` (or choose one of the `mixed` modes). Once you're done, click on _Save_.

{{< img src="20231121_019.png" alt="wifi network settings" >}}

Back on the wireless page, click on _Save & Apply_.

{{< img src="20231121_020.png" alt="openwrt wireless page" >}}

## Checkpoint

Time for a break. Disconnect the ethernet cable from the router and connect to the new SSID (mine was called `OpenWrt_Travel_Router`). You should get an IP in the same range as the wired connection (mine was `10.70.74.x`).

Let's take stock of where we're at now. We have a travel router that has three basic interfaces:

* wired WAN (the port labeled WAN)
* wireless WAN (the `radio0` device)
* a LAN bridge (both LAN ports and `radio1`)

Visually, that looks like this:

{{< img src="20231121_021.jpg" alt="topology" >}}

# Conclusion


\-Logan
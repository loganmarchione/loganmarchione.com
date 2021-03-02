---
title: "Use your own router with Verizon FiOS"
date: "2015-07-11"
author: "Logan Marchione"
categories: 
  - "oc"
  - "router"
  - "external"
cover:
    image: "/assets/featured/featured_generic_router.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_fios %}}

# Introduction

At the new house, we have [Verizon FiOS](https://www.verizon.com/home/fios/). If you're not familiar, FiOS is a FTTP (Fiber-to-the-Premises) multimedia service that offers phone service, internet, and TV. If fiber is strung in your area, Verizon taps into the fiber line on the telephone pole and runs it to your house. Verizon will then install a box on your property called the Optical Network Terminal (ONT), that converts the fiber signal into a copper signal.

Each ONT has multiple outputs and is capable of delivering multiple phone lines, internet data, and TV data. For the internet signal, typically the Verizon technician configures the ONT to have coaxial output, because most homes are already wired for coaxial from the [demarc](https://en.wikipedia.org/wiki/Demarcation_point) to various rooms in the house.

{{< img src="20150626_001.jpg" alt="ont" >}}

Verizon also provides an internet router that connects to the ONT. The FiOS router (typically an ActionTec MI424WR [100Mbps](http://www.actiontec.com/products/prod_archive.php?pid=189) or [1Gbps](http://www.actiontec.com/41.html)) has a coaxial/ethernet inputs and acts as an all-in-one MoCA bridge, router, switch, and wireless access-point.

{{< img src="20160822_001.jpg" alt="router" >}}

In the typical setup (shown below) the coaxial cable coming from the ONT is split in two: one run for the FiOS router, and one run for the TV set-top boxes. The FiOS router takes input from coaxial and converts it to internet signal via the [MoCA](https://en.wikipedia.org/wiki/Multimedia_over_Coax_Alliance) (Multimedia over Coax Alliance) bridge. If you have FiOS TV, you must have the FiOS router on your network (for functions like video-on-demand, the guide, etc...).

{{< img src="20150626_002.png" alt="screenshot" >}}

I'm not using FiOS for TV or phone service (I'm internet-only). My current setup (with the FiOS router) is shown below.

{{< img src="20150626_003.png" alt="screenshot" >}}

However, if you're an internet-only FiOS customer (like me), you don't need to use the FiOS router, since the set-top boxes aren't being used. I'd rather replace it with my own [OpenWrt](https://openwrt.org/) router that is more nerd-oriented and packs more features. Ideally, what I'd like to have is below.

{{< img src="20150626_004.png" alt="screenshot" >}}

This setup has the following benefits:

- I don't have to use Verizon's router.
- I wouldn't have to put my router behind the FiOS router, resulting in a double-NAT (as I used to have).
- In some older FiOS routers, there is a hardware limit of 100Mbps.
- You can supposedly still receive TV service by turning the FiOS router into a MoCA bridge, as described [here](https://www.dslreports.com/forum/r17679150-How-to-make-ActionTec-MI424-WR-a-network-bridge), and by a commenter, Danny.

## Router recommendations

Almost any standard router will work here, as long as it acts as a router (i.e., it routes packets between networks) and a firewall (i.e., it inspects packets based on rules). If you're an average user, most devices off the shelf from BestBuy or Amazon will get the job done just fine.

Personally, I recommend any router manufacturer that provides consistent updates. Asus is the real star here. All of their routers run the same basic OS, so when they create an update, it typically gets built for each model, since they're based on the same platform. Because of this, Asus provides updates to their routers once every couple weeks. In addition, the excellent [Merlin firmware](https://asuswrt.lostrealm.ca/) is based on the standard Asus firmware. TP-Link and Netgear aren't bad either, but only expect the newest devices to receive consistent updates.

## Routers to avoid

I'd recommend avoiding a router by a manufacturer that has a poor history of providing updates. Unfortunately, this list is probably too exhaustive to list every manufacturer.

Also, you do not want a router that is advertised as a "DOCSIS modem" or a router that comes with a coaxial port instead of an ethernet WAN port. An example of what you don't want is the Netgear C7000, because it is a modem, and lacks a WAN port.

{{< img src="20180129_001.png" alt="modem" >}}

# How-to

Do this at your own risk, I'm not responsible for anything you break :)

## Run ethernet cable

In my case, this was a relatively short run. The ONT is in the unfinished basement and the router sits directly above it on the TV stand. There was already a hole drilled in the floor from a previous coaxial run, so I chose to cut the connectors off a Cat6 patch cable, run the cable through the floor, and re-crimp new connectors. If you're curious, below are the parts/tools I used.

- [Cable stripper](http://amzn.com/B005OQNM3M)
- [Cable crimper](http://amzn.com/B002D3B97U)
- [Wire snips](http://amzn.com/B00FZPDG1K)
- [Cat6 connectors](http://amzn.com/B0036TWE2E)
- [Cat6 patch cable](http://amzn.com/B00G9BMX7C)
- [Cable tester](http://amzn.com/B003ZUQSUI)
- [Cable clips](http://www.homedepot.com/p/GE-Nail-In-Video-Cable-Clips-20-Pack-73502/202698897)

I used the [T568B](https://en.wikipedia.org/wiki/TIA/EIA-568) standard (shown below) to terminate the cable.

{{< img src="20150710_006.jpg" alt="T568B" >}}

If you don't know how to make Cat6 cables, [this](https://www.youtube.com/watch?t=6m2s&v=lullzS740wI) video below is incredibly helpful.

I tested my cable with a cable tester (to verify all four pairs were punched down correctly) and then tested it between my laptop and the FiOS router.

{{< img src="20150710_005.png" alt="screenshot" >}}

## Connect ethernet to ONT

The ONT has two sides: one panel accessible by the customer and another accessible by Verizon.

Disclaimer - Do not open the Verizon side of the ONT, as it's their property. While you're at it, don't relocate or alter the ONT in any way, shape, or form. [IANAL](https://en.wikipedia.org/wiki/IANAL), but you will most definitely void any warranty or service agreement you had.

{{< img src="20150710_001.jpg" alt="ont" >}}

{{< img src="20150710_002.jpg" alt="ont" >}}

On the side accessible by the customer, you should see a standard [RJ-45](https://en.wikipedia.org/wiki/Modular_connector#8P8C) jack (hard to see, but it's on the right).

{{< img src="20150710_003.jpg" alt="ont" >}}

Plug your newly-made ethernet cable into the ONT.

{{< img src="20150710_004.jpg" alt="ont" >}}

## Setup new router

In this step, you want to go through and setup your new router before you plug it into the network. Setup your username/password, WiFi settings, DHCP ranges, etc... so that you can cutover to the new router quickly.

In my case, I'm going to be using [OpenWrt](https://openwrt.org/) on a [TP-Link Archer C7](http://www.newegg.com/Product/Product.aspx?Item=N82E16833704177). I've used OpenWrt in the past on a [TP-Link MR-3020](http://amzn.com/B006DEBXD0) and wanted to try it on a proper router. The Archer C7 has 802.11a/b/g/n/ac and is dual-band capable at 2.4GHz and 5GHz. It has [OpenWrt support](http://wiki.openwrt.org/toh/tp-link/tl-wdr7500), as well as [DD-WRT support](https://www.dd-wrt.com/wiki/index.php/TP_Link_Archer_C7). I plan on using the router to host an OpenVPN server, as well as a dynamic DNS updater. If you'd like, you can read more on that setup, [here](/2015/08/openwrt-with-openvpn-server-on-tp-link-archer-c7/).

## Break DHCP lease

We need to start by breaking the DHCP lease on the FiOS router. To do this, login to the FiOS router via the web interface (most likely, the address will be 192.168.1.1 and the username/password will be on a sticker on the router). Click on the _My Network_ option at the top of the screen, on the left side click on _Network Connections_, click on _Broadband Connection (Ethernet/Coax)_, then click on _Settings_ at the bottom of the page. Look for the _DHCP Lease_ option in the list, click the _Release_ button next to it, then scroll down to the bottom and click _Apply_. As soon as the settings are applied, immediately unplug the power from the FiOS router so it doesn't request a new DHCP lease.

## Call Verizon

Call FiOS support at 1-888-553-1555. Remember what your mother taught you: use your manners! The Verizon technician doesn't have to do this for you and will be doing you a favor. Ask customer support to switch the ONT from coaxial output to ethernet output. If they give you a hard time about doing it remotely, tell them that you want to use your own router, an ethernet cable is already run, and you don't need a technician to come out. You may even need to ask for a supervisor or level-two support technician. Expect to spend about 30-45 minutes on the phone.

## Connect new router

After Verizon sets up the ethernet output, connect the ethernet cable from the ONT to the WAN port on the new router. Connect a client (e.g., laptop, phone, etc...) to a LAN port (or wireless) on the new router. Log into the router's admin page and verify you're receiving an IP address from the ONT. Once you are, verify your client can get online.

## Thank the technician profusely

The support technician just did you a huge favor. Take their survey after the call and give them 5-stars.

## Wrap-up

Disconnect the coaxial cable from the FiOS router and move any remaining ethernet connections over to the new router. With the FiOS router down and your new router up, verify internet connectivity once more. This is to double-check that the FiOS router isn't routing any traffic at all.

# Extras

## Alternate ONT models

There are [various models](https://www.dslreports.com/faq/16637) of ONTs out there.

A commenter was nice enough to send me a picture of his ONT (below) to show you the differences (thanks, Larry!).

{{< img src="20160117_001.jpg" alt="ont" >}}

Another commenter submitted a picture of his ONT (thanks, Brian!).

{{< img src="20180105_001.jpg" alt="ont" >}}

## Clone MAC address

I used to recommend cloning the MAC address of your FiOS router onto your new router. However, one commenter, Jeremy, had a pretty terrible time with this, and actually had his service cancelled. Instead, I recommend using your router with it's true MAC address. This will most likey involve a call to Verizon, but it's worth a few minutes on the phone.

~~When I spoke with Verizon, they were able to switch the ONT over to ethernet without issue. The technician was able to see the MAC address of my C7, and I was able to verify a few packets were being sent/received, but I still wasn't pulling an IP from the ONT. When I switched my connection back to the FiOS router (this time, on ethernet), I was able to get online without issue. I assumed it was something specific to my C7, and decided to clone the MAC address of the FiOS router to the WAN interface of the C7. After I rebooted, I was able to get an IP and get online.~~

~~Strangely enough, after a few weeks, I removed the cloned MAC, rebooted, and still had service.~~

Did you switch the FiOS router out for your own? If so, let me know how it went!

\-Logan

# Comments

[Old comments from WordPress](/2015/07/use-your-own-router-with-verizon-fios/comments.txt)
---
title: "pfSense on the PC Engines APU2"
date: "2019-08-25"
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

{{< series/pfsense >}}

# Introduction

In the past few weeks, I [replaced my EdgeRouter Lite with a Netgate SG-1100](/2019/06/migrating-away-from-the-ubiquiti-edgerouter-lite/). Two weeks later, [my SG-1100 died,](/2019/07/my-sg-1100-died/) and I had to put the EdgeRouter Lite back. However, I still wanted to replace the ERL with a pfSense device (albeit, not Netgate hardware).

# PC Engines APU2

Again, my requirements for hardware were as follows:

- Hardware that is small, low power, and fanless (this device is in my living room, not a server rack)
- Have Intel NICs (they generally have better compatibility with Linux/BSD than Realtek)
- Be around $250 or less, including RAM (but not storage)

Going back to my [hardware chart](/2019/06/migrating-away-from-the-ubiquiti-edgerouter-lite/#hardware), I further narrowed it down to the PC Engines APU2 and the Shuttle DS77U (in fact, the DS10U was just released, which is a DS77U with an 8th Gen Intel processor). While the Shuttle DS77U/DS10U would have better hardware (newer CPU, DDR4 instead of DDR3, etc...), I chose to go with the APU2. The APU2 comes highly recommended on [reddit](https://www.reddit.com/r/PFSENSE/) and the [pfSense forums](https://forum.netgate.com/topic/95148/pc-engines-apu2-experiences), and it receives [frequent BIOS updates](https://pcengines.github.io/) (including Coreboot support, and most recently AMD Core Performance Boost).

There are four main differentiators of the APU2 lineup (thanks to commenter Cee Jay for clearing this up):

- the APU platform generation (e.g., 2, 3, 4, etc...) - this is where you get APU2, APU3, APU4, etc...
- the board revision (e.g., a, b, c, d, etc...) - this is where you get APU2A, APU2B, APU2C, etc...
- the amount of RAM (2GB or 4GB) - this is where you get APU2D2, APU2D4, etc...
- the type of NIC (Intel i210AT vs i211AT)

When purchasing an APU model, do not assume that a bigger model number is better. For example, **the APU4 is not "better" than the APU2** because the model number is larger. You should always do your research to determine what model you need for your application.

For networking applications, it's generally known that the i210AT is considered "better" than the i211AT because it has four transmit and four receive queues per port, while the i211AT only has two transmit and two receive queues per port. So when purchasing an APU, I made sure to look for one with an i210AT.

I ended up purchasing the following items directly from [PC Engines](https://pcengines.ch/order.htm) directly. Shipping took a total of 10 days from Switzerland to Pennsylvania. It arrived via USPS and required a signature, since it originated outside the United States.

- [apu2d4](https://pcengines.ch/apu2d4.htm) - $120 (this has the i210AT)
- [case1d2blku](https://pcengines.ch/case1d2blku.htm) - $10
- [ac12vus2](https://pcengines.ch/ac12vus2.htm) - $4.40
- [Samsung 860 EVO 250GB mSATA SSD](https://www.amazon.com/dp/B07864YNTZ/) - $67.90
- [usbcom1a](https://www.pcengines.ch/usbcom1a.htm) - $8.00 (optional - the drivers for Windows 10 are [here](https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers))
- [apufix1a](https://www.pcengines.ch/apufix1a.htm) - $5.00 (optional - this makes positioning the thermal pad much easier)
- [hexbit](https://www.pcengines.ch/hexbit.htm) - $3.50 (optional)

# Pre-install

## Assembly

I chose to assemble my APU2 myself, but there is an option to pay to have it assembled. If you choose to assemble it yourself, there is a really good video [here](https://www.youtube.com/watch?v=ft_Ic2ZdLHw). Pro-tip, make sure you remove the screws on the serial connection before you try to assemble anything.

{{< img src="20190823_001.jpg" alt="apu2" >}}

{{< img src="20190823_002.jpg" alt="apu2" >}}

## Connect to serial

Connect the serial cable using the settings from the [manual](https://pcengines.ch/pdf/apu2.pdf). These are the same settings that pfSense uses as well.

- Speed: 115200
- Data Bits: 8
- Parity Bits: None
- Stop Bits: 1

These are the PuTTY settings I used (your COM port may be different).

{{< img src="20190823_003.png" alt="putty settings" >}}

Press _F10_ at boot when connected via the console cable and you will see the boot menu.

{{< img src="20190823_004.png" alt="boot menu" >}}

## Memtest86

I always test my memory before I use it, and I always recommend [Memtest86](https://www.memtest86.com/download.htm) (not to be confused with [Memtest86+](https://www.memtest.org/), which is no longer maintained). There is a build of Memtest86 built-in to the APU2 BIOS, just press _F10_ at boot when connected via the console cable and you can run a memory test with option _3_.

{{< img src="20190823_005.png" alt="memtest" >}}

# Setup

## Install

Installing pfSense was easy enough, especially if you're using the [amazing install guide](https://docs.netgate.com/pfsense/en/latest/install/index.html#installing) (seriously, use it). For my install, I chose the options below from the [download page](https://www.pfsense.org/download/). The APU2 does not have a VGA port, so you don't have any option other than to do an install over serial.

{{< img src="20190823_006.png" alt="pfsense download options" >}}

## Configuration

The initial configuration was easy. The middle port is the LAN port, which will give you a 192.168.1.1/24 address. From a browser, follow the prompts to do your initial setup. I won't detail exactly what I did to my setup, since everyone's install will be different.

I recommend getting a cheap label maker and labeling the interfaces, since they are not marked on the case anywhere. I also make a label for the boot menu shortcut key and the serial settings.

## BIOS update

This is personal preference, but I always try to update the BIOS on my devices. With the recent [Meltdown and Spectre](https://meltdownattack.com/) vulnerabilities, it is crucial to keep your BIOS updated (since these vulnerabilities can only be mitigated with firmware updates). For the APU2, the BIOS updates are located [here](https://pcengines.github.io/).

PC Engines recommends you flash the firmware from a separate Linux-based USB drive, but you can do it from inside pfSense, _after_ pfSense is installed, as shown [here](https://forum.netgate.com/topic/95148/pc-engines-apu2-experiences/214).

# Speedtest

Here are the iPerf results when running a test with my ERL as the router. Keep in mind, my internet at home is only 400/400, so that's my current maximum speed.

```
Connecting to host loganmarchione.com, port 5201
[ 4] local 10.10.2.34 port 55818 connected to 68.183.148.132 port 5201
[ ID] Interval Transfer Bandwidth Retr Cwnd
[ 4] 0.00-1.00 sec 48.0 MBytes 402 Mbits/sec 28 1.62 MBytes 
[ 4] 1.00-2.00 sec 64.8 MBytes 543 Mbits/sec 23 1.35 MBytes 
[ 4] 2.00-3.00 sec 67.2 MBytes 564 Mbits/sec 0 1.42 MBytes 
[ 4] 3.00-4.00 sec 67.2 MBytes 564 Mbits/sec 0 1.47 MBytes 
[ 4] 4.00-5.00 sec 67.2 MBytes 564 Mbits/sec 0 1.50 MBytes 
[ 4] 5.00-6.00 sec 67.2 MBytes 564 Mbits/sec 0 1.52 MBytes 
[ 4] 6.00-7.00 sec 66.4 MBytes 557 Mbits/sec 0 1.53 MBytes 
[ 4] 7.00-8.00 sec 66.6 MBytes 559 Mbits/sec 0 1.54 MBytes 
[ 4] 8.00-9.00 sec 67.2 MBytes 564 Mbits/sec 0 1.54 MBytes 
[ 4] 9.00-10.00 sec 67.2 MBytes 564 Mbits/sec 0 1.56 MBytes 
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval Transfer Bandwidth Retr
[ 4] 0.00-10.00 sec 649 MBytes 544 Mbits/sec 51 sender
[ 4] 0.00-10.00 sec 647 MBytes 542 Mbits/sec receiver
```

And here are the results of same test, but with the APU2 acting as the router. As you can see, it's able to max out my connection without breaking a sweat.

```
Connecting to host loganmarchione.com, port 5201
[ 4] local 10.10.2.34 port 51548 connected to 68.183.148.132 port 5201
[ ID] Interval Transfer Bandwidth Retr Cwnd
[ 4] 0.00-1.00 sec 53.7 MBytes 450 Mbits/sec 9 2.21 MBytes
[ 4] 1.00-2.00 sec 67.2 MBytes 563 Mbits/sec 1 2.23 MBytes
[ 4] 2.00-3.00 sec 67.2 MBytes 564 Mbits/sec 0 2.25 MBytes
[ 4] 3.00-4.00 sec 67.2 MBytes 564 Mbits/sec 0 2.27 MBytes
[ 4] 4.00-5.00 sec 67.2 MBytes 563 Mbits/sec 0 2.29 MBytes
[ 4] 5.00-6.00 sec 67.2 MBytes 564 Mbits/sec 0 2.32 MBytes
[ 4] 6.00-7.00 sec 67.2 MBytes 563 Mbits/sec 0 2.34 MBytes
[ 4] 7.00-8.00 sec 67.2 MBytes 564 Mbits/sec 0 2.38 MBytes
[ 4] 8.00-9.00 sec 67.1 MBytes 563 Mbits/sec 0 2.47 MBytes
[ 4] 9.00-10.00 sec 67.2 MBytes 564 Mbits/sec 1 2.51 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval Transfer Bandwidth Retr
[ 4] 0.00-10.00 sec 658 MBytes 552 Mbits/sec 11 sender
[ 4] 0.00-10.00 sec 657 MBytes 551 Mbits/sec receiver
```

I have heard nothing but good things about the APU2, and am so far impressed!

\-Logan

# Comments

[Old comments from WordPress](/2019/08/pfsense-on-the-pc-engines-apu2/comments.txt)
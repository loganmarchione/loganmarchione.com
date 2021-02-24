---
title: "Ubiquiti EdgeRouter serial console settings"
date: "2017-01-08"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_ubiquiti_edgemax.svg"
    alt: "featured image"
    relative: false
---

{{< series/ubiquiti >}}

# Introduction

I'm planning on upgrading my EdgeRouter Lite (ERL) to the newly-released [v1.9.1](https://community.ubnt.com/t5/EdgeMAX-Updates-Blog/EdgeMAX-EdgeRouter-software-release-v1-9-1/ba-p/1766160) (I'm following my [upgrade guide](/2016/06/edgerouter-lite-software-upgrade/)). This time, I'm using a serial cable to connect to my ERL. This is the first time I've used serial, so I'm going to document the process.

# Why serial?

Serial connectors (standard [RS-232](https://en.wikipedia.org/wiki/RS-232)) are often included on networking and enterprise equipment. Serial comes in a number of different physical connectors, called D-subminiature, including DB25 and DB9.

{{< img src="20170108_004.png" alt="serial connectors" >}}

Serial is a very old technology, so why is it still around? Serial is slow, doesn't transmit power, and isn't good for runs longer than a few meters. However, serial is a very basic connection, which means is it reliable, simple, and is almost universal. In the case of the ERL, it is easy to break the configuration in a way that locks you out. You can assign the wrong firewall rule to the wrong port, disable password authentication and then delete your SSH keys, etc... Serial is an always-on, dead-simple, reliable connection to your ERL. The only downside is that you need to physically be connected to the ERL.

# Serial connection

The ERL uses a standard ethernet serial port, so you'll need a RJ45 (ethernet) to DB9 (serial) adapter. If your computer doesn't have a DB9 serial port, you'll also need a DB9 to USB adapter. If you only want to use one cable, you can use an all-in-one serial-to-usb cable, like [this one](http://a.co/6BcjjLi) from Amazon. If you've ever used Cisco products, any teal Cisco serial cable will work (Ubiquiti did that on purpose).

The serial settings for Ubiquiti products are listed on the [Ubiquiti website](https://help.ubnt.com/hc/en-us/articles/205202630-EdgeMAX-Connect-to-serial-console-port-default-settings), and shown below.

- Baud rate: 115200
- Data bits: 8
- Parity: NONE
- Stop bits: 1
- Flow control: NONE

Those same settings are sometimes abbreviated in the format shown below.

```
115200 8N1 OFF
```

## Windows

First, check Device Manager for your COM port. In my case, it was _COM3_.

{{< img src="20170108_001.png" alt="screenshot" >}}

Next, connect to the ERL with the serial console of your choice. I'm using [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) on Windows. The settings you need are under _Connection_ --> _Serial_, shown below.

{{< img src="20170108_002.png" alt="screenshot" >}}

If you get a blank screen (shown below), just press _Enter_ once to get the prompt to login.

{{< img src="20170108_003.png" alt="screenshot" >}}

## Linux

Typically, you'll need to add your user to a group to use the serial console. In Arch Linux, the group is _uucp_, but it may be different depending on your distribution.


```
sudo gpasswd -a username uucp
```

Start by plugging in your serial cable to identify which port it is connected to. My device was at _/dev/ttyUSB0_.

```
dmesg | grep -iE 'serial|tty'
```

Next, you'll need to install a program to use the serial console. I'm using _picocom_, but you can also use _minicom_, _screen_, etc...

```
sudo picocom -b 115200 -d 8 -f n -p 1 -y n /dev/ttyUSB0
```

Again, if you get a blank screen, just press _Enter_ once to get the prompt to login.

Hope this helps!

\-Logan
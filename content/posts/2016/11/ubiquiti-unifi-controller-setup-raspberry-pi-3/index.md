---
title: "Ubiquiti UniFi controller setup on Raspberry Pi 3"
date: "2016-11-29"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_ubiquiti_unifi.svg"
    alt: "featured image"
    relative: false
aliases:
    - /2016/11/ubiquiti-unifi-controller-setup-raspberry-pi-3
---

{{% series/s_ubiquiti %}}

# Introduction

As you know, I love my [Ubiquiti EdgeRouter Lite](/2016/04/ubiquiti-edgerouter-lite-setup/). Since I bought it, I've been wanting to purchase one of the [UniFi wireless APs](https://www.ubnt.com/unifi/unifi-ap/) ever since I saw the [Ars Technica](http://arstechnica.com/gadgets/2015/10/review-ubiquiti-unifi-made-me-realize-how-terrible-consumer-wi-fi-gear-is/) review of them. I ended up picking up the UniFi AC Pro on a Black Friday deal on Jet.com.

The UniFi AP itself does not have a web interface (however, you can SSH to it). To manage the APs, you need to use the [UniFi controller software](https://www.ubnt.com/enterprise/software/). The software is only needed for the initial setup, and can then be turned off afterwards (which means you can do the setup on your laptop, then disable the software after the initial setup). However, if you want to enable statistic gathering or guest portal, the controller software needs to be [running at all times](https://help.ubnt.com/hc/en-us/articles/204959394-UniFi-Does-the-controller-need-to-be-running-at-all-times-). The controller software is available for [Windows, Mac, Linux](https://www.ubnt.com/download/unifi/), which means it's perfect to run on a small Linux server (like a Raspberry Pi 3).

# Controller setup

## Installation

I'm going to assume you're running this on a Raspberry Pi 3, running Raspbian. However, any Debian-based distribution should follow the same instructions.

First, we need to add the [repository](https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu) to apt.

```
echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" | sudo tee /etc/apt/sources.list.d/100-ubnt.list
```

Note - You can also specify the version of UniFi to use, as commenter battlechop did, since the stable repository is still on v4. Thanks for submitting this!

Then, add the GPG key.

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50
```

Next, update your repositories and install Unifi.

```
sudo apt-get update && sudo apt-get install unifi
```

Now, start Unifi.

```
sudo systemctl enable unifi
sudo systemctl start unifi
```

Finally, we need to disable MongoDB, since UniFi will run its own instance.

```
sudo systemctl stop mongodb
sudo systemctl disable mongodb
```

## Package hold

If you read around [r/Ubiquiti](https://www.reddit.com/r/Ubiquiti/) and the [UniFi forums](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwiBsM3t1MvQAhUK34MKHctmCK8QFggdMAA&url=http%3A%2F%2Fcommunity.ubnt.com%2Ft5%2FUniFi-Wireless%2Fbd-p%2FUniFi&usg=AFQjCNFNoLQ4ZY3Xo2fFte_NxlvRFtVMBg&sig2=uilnkCgAfoP-rMNyEaHh9g), you'll learn that the controller releases (and AP firmware) can be hit-or-miss. Because we've added the UniFi repository, every time we do a `sudo apt-get update && sudo apt-get upgrade`, we might update the UniFi controller software, even if we don't want it updated. To get around this, we'll hold back the _unifi_ package from being updated automatically.

```
sudo apt-mark hold unifi
```

To verify it is held back, use _dpkg_.

```
sudo dpkg -l | grep ^h
```

Here, you can see the results.

```
hi  unifi                                 4.8.20-8422                     all          Ubiquiti UniFi server
```

The _h_ as the first character means the package is held, and the _i_ as the second character means the package is currently installed.

If you ever need to remove the hold, use the command below.

```
sudo apt-mark unhold unifi
```

## Manually update

To check for a new release of the _unifi_ package in the repository, use the command below.

```
sudo apt-get update && sudo apt-cache policy unifi
```

If there is a newer version, update to it manually.

```
sudo apt-get install --only-upgrade unifi
```

## Oracle Java 8 (optional)

Oracle changed the Java licensing model (as-of January 2019) to start charging for Oracle Java. Instead, you should stick with [OpenJDK](https://openjdk.java.net/) as it is open-source.

~~OpenJDK has been known to have [performance issues](https://www.reddit.com/r/Ubiquiti/comments/5g338r/which_java_for_unifi_controller_509_on_rpi/) on the Pi, so I'm running Oracle's Java 8 instead. You can find your current Java packages with the command below.~~

```
sudo dpkg --get-selections |grep -e "java\|jdk\|jre"
```

~~If you try to find your Java version, you'll probably be using OpenJDK.~~

```
--> java -version
java version "1.7.0_111"
OpenJDK Runtime Environment (IcedTea 2.6.7) (7u111-2.6.7-2~deb8u1+rpi1)
OpenJDK Zero VM (build 24.111-b01, interpreted mode)
```

~~Start by installing Oracle Java 8.~~

```
sudo apt-get install oracle-java8-jdk -y
```

~~Next, update your environment to use the new Java.~~

```
sudo update-alternatives --config java
```

~~Check your Java version again to make sure you're on Java 8.~~

```
--> java -version
java version "1.8.0_65"
Java(TM) SE Runtime Environment (build 1.8.0_65-b17)
Java HotSpot(TM) Client VM (build 25.65-b01, mixed mode)
```

~~Now, copy the systemd service file so we can edit it, then update it to point at the new Java location.~~

```
sudo cp -p /lib/systemd/system/unifi.service /etc/systemd/system
sudo sed -i '/^\[Service\]$/a Environment=JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt' /etc/systemd/system/unifi.service
```

~~Now, restart systemd and UniFi.~~

```
sudo systemctl daemon-reload
sudo systemctl restart unifi.service
```

## Log rotation (optional)

Because I'm running the controller on a Raspberry Pi 3, I have limited space on the SD card. To make sure the log files don't fill the card, I'm going to rotate them using _logrotate_. Credit to [Kevin Burdett](https://github.com/kburdett) for [this idea](https://gist.githubusercontent.com/kburdett/006a16316afa62148b16/raw/unifi_logrotate.d.sh).

First, install _logrotate_.

```
sudo apt-get update && sudo apt-get install logrotate
```

Then, create the configuration file to rotate your UniFi and MongoDB logs.

```
sudo bash -c 'cat >> /etc/logrotate.d/unifi << EOF
/var/log/unifi/*.log {
    rotate 5
    daily
    missingok
    notifempty
    compress
    delaycompress
    copytruncate
}
EOF'
```

The logrotate [options](https://linux.die.net/man/8/logrotate) are explained below:

- Rotate any files ending in _/var/log/unifi_ ending in _.log_
- Save 5 log files before deleting older files
- Rotate the log files daily
- If the log is missing, go onto the next one without error
- Do not rotate the log if it is empty
- Compress the log files (into gzip format)
- Delay compression until the log file is rotated (so processes won't be trying to log to a compressed file)
- Truncate the original log file in place after creating a copy, instead of moving the old log file and optionally creating a new one

# Access controller

You can now access the controller by going to the IP of your device, over port 8443.

```
https://<device_IP_here>:8443
```

If everything is working, you should see the setup wizard. Since there are many different ways to do the setup, I won't be covering that here.

{{< img src="20161128_001.png" alt="screenshot" >}}

# Controller alternatives

There are a few alternatives to running the controller software on the Raspberry Pi on your local network:

1. As mentioned earlier, run the controller software on your PC ([Windows/Mac/Linux](https://www.ubnt.com/download/unifi/)) for initial setup. You can either turn it off after the setup, or leave it running to gather statistics.
2. Download the UniFi app ([iOS](https://itunes.apple.com/ca/app/unifi/id1057750338) or [Android](https://play.google.com/store/apps/details?id=com.ubnt.easyunifi)) to setup the AP. The app provides limited setup functionality, with more advanced options requiring the controller.
3. Purchase the [Unifi Cloud Key](https://www.ubnt.com/unifi/unifi-cloud-key/) ($80). This device sits on your network and runs the controller software locally, but is accessible from anywhere at [https://unifi.ubnt.com](https://unifi.ubnt.com/). Instructions are [here](https://help.ubnt.com/hc/en-us/articles/219051528-UniFi-How-to-Setup-your-Cloud-Key-and-UniFi-Access-Point-for-beginners-).
4. Run the controller in a VPS or AWS instance. See instructions here for [installation](https://help.ubnt.com/hc/en-us/articles/209376117-UniFi-Install-a-UniFi-Cloud-Controller-on-Amazon-Web-Services) and [adoption](https://help.ubnt.com/hc/en-us/articles/204909754-UniFi-Layer-3-methods-for-UAP-adoption-and-management).

# Comparison

Here, you can see my signal strength on the old access point (TP-Link Archer C7 running OpenWrt Chaos Calmer) on the 2.4GHz and 5GHz networks, respectively.

{{< img src="20161128_002.png" alt="screenshot" >}}

{{< img src="20161128_003.png" alt="screenshot" >}}

Then, the same measurements with the new UniFi access point. Again, on the 2.4GHz and 5GHz networks, respectively.

{{< img src="20161128_004.png" alt="screenshot" >}}

{{< img src="20161128_005.png" alt="screenshot" >}}

Hope this helps!

\-Logan

# Comments

[Old comments from WordPress](/2016/11/ubiquiti-unifi-controller-setup-on-raspberry-pi-3/comments.txt)
---
title: "EdgeRouter CNAME records"
date: "2019-02-03"
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

{{< series/ubiquiti >}}

# Introduction

## What is a CNAME record?

A canonical name ([CNAME](https://en.wikipedia.org/wiki/CNAME_record)) record is a special type of DNS record that points one domain name to another.

It's easier to explain with an example. Let's say you own the website _example.com_, and you want to setup both _www.example.com_ and _example.com_ to go to the same place application (e.g., WordPress). You could maintain two separate A records, like this:

```
www.example.com --> 11.22.33.44
example.com     --> 11.22.33.44
```

However, with a CNAME record, you can do this:

```
www.example.com --> example.com           <-- This is the CNAME record
example.com     --> 11.22.33.44
```

With this setup, if your server address changes, you only need to update one record (the record for _example.com_).

## CNAMEs as "shortcuts"

The really cool part about CNAME records is that you can create DNS "shortcuts" with them.

Time for another example. Let's say you want to setup a backup server (with the hostname _backup01_) at your house and connect all your devices to it. This way, every device can backup to one central location.

```
device01 --\
device02 ---|--> backup01.localdomain
device03 --/
```

However, eventually, the server named _backup01_ will need to be replaced with _backup02_, and when that happens, you'll need to reconfigure every device in your house to point to the new server. But, what if you could setup a DNS name between each device and the backup server? This record is the CNAME record.

```
device01 --\
device02 ---|--> storage.localdomain --> backup01.localdomain
device03 --/
```

With this setup, you can point every device to _storage_. Then, when _backup01_ eventually needs to be replaced with _backup02_, you can just update the CNAME record of _storage_. This is exactly what I'm using CNAME records for at home.

# Setting up CNAME records

First, you'll need to be using dnsmasq on your EdgeRouter instead of the default DHCP server (written by the ISC). If you don't have dnsmasq running, I have a quick guide for that [here](/2016/08/edgerouter-lite-dnsmasq-setup/#enable-dnsmasq), and Ubiquiti's official guide is [here](https://help.ubnt.com/hc/en-us/articles/115002673188-EdgeRouter-Using-dnsmasq-for-DHCP-Server#2).

Next, you simply set your CNAME records with the command below. In this case, _storage_ is the CNAME record, while _backup01_ is the actual server name.

```
configure
set service dns forwarding options cname=storage.localdomain,backup01.localdomain
commit
save
```

Now, you can use the name _storage_ on all your devices, and then update the CNAME record when you replace the server that's behind the record.

Hope this helps!

\-Logan

# Comments

[Old comments from WordPress](/2019/02/edgerouter-cname-records/comments.txt)
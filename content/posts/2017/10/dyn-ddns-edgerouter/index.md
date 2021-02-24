---
title: "Dyn DDNS on EdgeRouter"
date: "2017-10-03"
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
aliases:
    - /2017/10/dyn-ddns-edgerouter/
---

{{< series/ubiquiti >}}

# Introduction

In the past, I've posted about my [DuckDNS dynamic DNS settings](/2017/04/duckdns-on-edgerouter/), and mentioned I use Dyn as well. My Dyn setup is documented below.

I should mention, however, that Dyn no longer offers free dynamic DNS (it was [discontinued](https://dyn.com/blog/why-we-decided-to-stop-offering-free-accounts/) in 2014). They now charge $40/year for 30 hostnames.

# Dyn setup

## Web setup

Head over to the [Dyn](https://dyn.com) website and setup an account. Create a new hostname, choosing the TLD from the available options. For this setup, just click _Your current location's IP address_ to continue through to this process.

Go to your _Account Settings_ page and make note of the _Updater Client Key_. If you don't have one, generate one.

## Router setup

EdgeOS only supports a handful of pre-configured DNS service providers by default (shown below).

```
ubnt@erl# set service dns dynamic interface eth0 service
afraid       dslreports   easydns      noip         zoneedit
dnspark      dyndns       namecheap    sitelutions
```

Luckily, Dyn is one of the providers.

```
set service dns dynamic interface eth0 service dyndns
set service dns dynamic interface eth0 service dyndns host-name loganmarchione.dyndns.org
set service dns dynamic interface eth0 service dyndns login username
set service dns dynamic interface eth0 service dyndns password updater-client-key
set service dns dynamic interface eth0 service dyndns protocol dyndns2
set service dns dynamic interface eth0 service dyndns server members.dyndns.org
commit
save
exit
```

A couple notes on the options:

- the hostname is the entire domain (e.g., loganmarchione.dyndns.org)
- the username is your account name
- the password is your updater client key (that long string of numbers/letters)

## Verify setup

Trigger a manual update. EdgeOS will only update the dynamic DNS provider when your IP address actually changes.

```
update dns dynamic interface eth0
```

You can show the status with the command below.

```
show dns dynamic status
```

Here, you can see the successful update.

```
interface    : eth0
ip address   : XX.XX.XX.XX
host-name    : loganmarchione.dyndns.org
last update  : Tue Apr 25 22:13:09 2017
update-status: good
```

# SSL settings

Also, just so you know, EdgeOS uses _ddclient_ for the dynamic DNS updates. The configuration file is located at _/etc/ddclient.conf_, but there is a directory at _/etc/ddclient_ with a configuration file for each interface. By default, _ddclient_ is setup to use SSL, as shown below.

```
root@erl:~# grep ssl /etc/ddclient/ddclient_eth*.conf
ssl=yes
```

Hope this helps!

\-Logan

# Comments

[Old comments from WordPress](/2017/10/dyn-ddns-on-edgerouter/comments.txt)
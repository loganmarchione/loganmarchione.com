---
title: "DuckDNS on EdgeRouter"
date: "2017-04-25"
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

I've been using [Dyn](https://dyn.com/) for my dynamic DNS for years. However, after the [2016 Dyn DDoS](https://en.wikipedia.org/wiki/2016_Dyn_cyberattack), I've decided to add a second dynamic DNS service provider, in case Dyn goes down again.

# Choosing a provider

Some dynamic DNS service providers might offer more update methods or tutorials, but that's where the differences end. Unless you're a large client or have a very custom setup, the largest factor between providers is price. Dyn starts at $7/month, but I'm grandfathered into a $40/year plan.

For my second provider, I've chosen [DuckDNS](https://www.duckdns.org/). DuckDNS was [started by a redditor](https://www.reddit.com/r/raspberry_pi/comments/1mqb9f/duckdns_a_free_ddns_just_got_better_bring_on_the/), they are pretty transparent, and best of all, the service is free. I'd still donate to them because I'd prefer to pay a couple of guys running a good service, rather than a corporation.

# DuckDNS setup

## Web setup

Head over to the [DuckDNS](https://www.duckdns.org/) website and setup an account. Interestingly, DuckDNS only offers oAuth logins (e.g., through Google, Facebook, Reddit, etc...). This is so they don't have to worry about storing usernames/passwords themselves and can leave it to the professionals.

Next, enter your domain in the box and click _Add domain_. If the domain is available, it will be registered to your account. While you're on this same screen, make note of your account token.

## Router setup

EdgeOS only supports a handful of pre-configured DNS service providers by default (shown below).

```
ubnt@erl# set service dns dynamic interface eth0 service
afraid       dslreports   easydns      noip         zoneedit
dnspark      dyndns       namecheap    sitelutions
```

To use DuckDNS, we need to setup a custom service provider. Substitute your interface, hostname, and password as needed.

```
set service dns dynamic interface eth0 service custom-duckdns
set service dns dynamic interface eth0 service custom-duckdns host-name loganmarchione
set service dns dynamic interface eth0 service custom-duckdns login nouser
set service dns dynamic interface eth0 service custom-duckdns password your-token-here
set service dns dynamic interface eth0 service custom-duckdns protocol dyndns2
set service dns dynamic interface eth0 service custom-duckdns server www.duckdns.org
commit
save
exit
```

A couple notes on the options:

- the hostname is the prefix to your domain (e.g., loganmarchione.duckdns.org)
- the username is _nouser_ (don't use your account name)
- the password is your account token (that long string of numbers/letters)

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
interface    : eth0
ip address   : XX.XX.XX.XX
host-name    : loganmarchione
last update  : Tue Apr 25 22:13:09 2017
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

[Old comments from WordPress](/2017/04/duckdns-on-edgerouter/comments.txt)
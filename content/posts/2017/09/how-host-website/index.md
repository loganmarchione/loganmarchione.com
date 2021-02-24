---
title: "How to host a website"
date: "2017-09-28"
author: "Logan Marchione"
categories: 
  - "cloud-internet"
  - "oc"
cover:
    image: "/assets/featured/featured_generic_website.svg"
    alt: "featured image"
    relative: false
aliases:
    - /2017/09/how-host-website
---

# Introduction

While creating [CAA records](/2017/09/creating-caa-records/), I found myself needing a new DNS provider. During that process, I thought it would be a good idea to document what it take to host a website and how the internet works (in a very limited sense). To host a website on the public internet, you need three things:

- domain name
- DNS record(s)
- web host

Typically, most domain registrars offer basic DNS support. In addition, most web hosts also offer basic DNS support. However, you can (and probably should) have these three services hosted at three separate companies (you don't want all your eggs in one basket).

# Domain name

A domain name is a a string of characters that represents a specific space on the internet. It consists of a [top-level domain](https://www.iana.org/domains/root/db) (TLD), as well as a domain name. Optionally, it can contain one or more subdomains (e.g., www, ftp, etc...).

{{< img src="20170928_001.png" alt="screenshot" >}}

All TLDs are maintained by [The Internet Assigned Numbers Authority](https://www.iana.org/) (IANA), a private nonprofit organization that oversees global IP address allocation. The IANA, is in turn, overseen by [The Internet Corporation for Assigned Names and Numbers](https://www.icann.org/) (ICANN), another private nonprofit organization.

{{< img src="20170928_002.png" alt="screenshot" >}}

The IANA delegates IP address assignment to five major [Regional Internet Registries](https://www.nro.net/about-the-nro/regional-internet-registries/) (RIRs), who in turn, allocate IP addresses to companies/individuals/organizations in their specific region.

- AFRINIC - African Network Information Center (Africa)
- ARIN - American Registry for Internet Numbers (North America and Antarctica)
- APNIC - Asia-Pacific Network Information Center (Asia, Australia, and New Zealand)
- LACNIC - Latin America and Caribbean Network Information Centre (South America and the Caribbean)
- RIPE NCC - The Reseaux IP Europeens Network Coordination Centre (Europe, Russia, the Middle East, and Central Asia)

{{< img src="20170928_003.png" alt="screenshot" >}}

In fact, because of the limits of IPv4, ARIN has already [used all of its allocated IP addresses](https://en.wikipedia.org/wiki/IPv4_address_exhaustion). The transition to IPv6 will solve this problem, but the change is expected to take a very long time.

When you purchase a domain name (e.g., loganmarchione.com), you are purchasing it through a registrar approved by the ICANN (e.g., Namecheap, GoDaddy, [Hover](https://hover.com/qs57M9Ha), etc...). For a small fee, the registrar registers your domain with the ICANN so that no one else can have that same domain.

There are other less-centralized domain registration projects, such as the [.bit TLD](https://bit.namecoin.org/), but they have yet to see widespread adoption.

# DNS record(s)

The Domain Name System (DNS) is the "phonebook" for the internet. When you type _loganmarchione.com_ into your browser, your computer requests the IP address associated with _loganmarchione.com_ from special servers, called nameservers. Once your computer has this IP address from the nameserver, it can load the page in your browser. This is a simplified explanation. In reality, your computer may have to query multiple nameservers, each of which may have to query other nameservers.

{{< img src="20170928_004.png" alt="screenshot" >}}

The first query your computer sends is to one of the [13 root nameservers](https://www.iana.org/domains/root/servers) managed by the IANA.

- a.root-servers.net
- b.root-servers.net
- c.root-servers.net
- d.root-servers.net
- e.root-servers.net
- f.root-servers.net
- g.root-servers.net
- h.root-servers.net
- i.root-servers.net
- j.root-servers.net
- k.root-servers.net
- l.root-servers.net
- m.root-servers.net

These 13 servers are used by every other nameserver on the planet to start the DNS lookup process. As such, they are very important to the function of the internet and are sometimes the [target of attacks](https://en.wikipedia.org/wiki/Distributed_denial-of-service_attacks_on_root_nameservers).

It's important to note that [many types](https://en.wikipedia.org/wiki/List_of_DNS_record_types) of DNS records exist, but below are some of the most common:

- A record - Returns an IPv4 address (like the example above)
- AAAA record - Returns an IPv6 address
- CAA record - Returns a [Certificate Authority Authorization](/2017/09/creating-caa-records/)
- CNAME record - Returns an alias of one name to another
- MX record - Returns of list of mailservers
- NS record - Returns a nameserver
- TXT record - Returns a text record

When you create a DNS record (through your registrar or a dedicated DNS provider like [Hurricane Electric](https://he.net/)), you are putting an entry into one of these root nameservers, which then propagates out to every other nameserver on the planet.

# Web host

At the most basic level, a web host consists of a computer running a webserver (e.g., Nginx, Apache, etc...) that sends HTML documents to computers that request them (like the example above). Obviously, there are many more configurations that can take place and the setup can become much more complicated.

One of the biggest decisions you can make about a web host it whether to host your pages locally (at home or work) or in the cloud (at someone else's home or work). However, I would recommend hosting data that isn't private (e.g., this website) in the cloud. I'm a big fan of [DigitalOcean](https://www.digitalocean.com/?refcode=131830154986) for this task.

Hope this was a good introduction to get you started!

\-Logan
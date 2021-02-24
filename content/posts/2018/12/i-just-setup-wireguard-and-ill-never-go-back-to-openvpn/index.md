---
title: "I just setup WireGuard, and I'll never go back to OpenVPN"
date: "2018-12-20"
author: "Logan Marchione"
categories: 
  - "encryption-privacy"
  - "oc"
cover:
    image: "/assets/featured/featured_wireguard.svg"
    alt: "featured image"
    relative: false
---

# Introduction

[WireGuard](https://www.wireguard.com/) released their official iOS app [today](https://lists.zx2c4.com/pipermail/wireguard/2018-December/003694.html), and I wasted no time jumping on setting up a WireGuard server at home (based mostly on [this guide](https://grh.am/2018/wireguard-setup-guide-for-ios/)). This is not going to be a tutorial, but instead, I'm going to talk about why WireGuard is a game-changer.

## OpenVPN drawbacks

For years, I've used [OpenVPN](https://openvpn.net/) to connect back to my home network. Don't get me wrong, OpenVPN is great, especially compared to dated, insecure alternatives like PPTP or L2TP/IPSec. But, for all its merits, OpenVPN has some drawbacks:

1. OpenVPN is difficult to setup and maintain, especially considering configuration typically happens via command line scripts (however, there are web interfaces like [OpenVPN Access Server](https://openvpn.net/vpn-server-resources/openvpn-access-server-features-overview/) and [Pritunl](https://pritunl.com/)).
2. OpenVPN software isn't built-in to devices (unlike PPTP and L2TP/IPSec).
3. Clients are identified and authenticated via certificates, which expire at regular intervals, and need to be renewed.
4. Certificates and client configuration files need to be distributed in a secure manner (e.g., probably not over email).
5. OpenVPN is highly secure, but typically slow, because it uses AES encryption and offers many cipher options.
6. OpenVPN is sensitive to changing networks (e.g., roaming from WiFi to cellular data).
7. OpenVPN has a huge codebase, at over 600k lines of code, making it difficult to audit effectively (though, it has been [audited](https://ostif.org/the-openvpn-2-4-0-audit-by-ostif-and-quarkslab-results/)).

# What is WireGuard?

WireGuard is a next-generation VPN that promises to be almost everything that OpenVPN isn't. It uses modern ideas and modern cryptography to solve modern problems.

## Why you should use WireGuard

Compared one-to-one with the drawbacks above, you can see where WireGuard succeeds.

1. WireGuard is dead simple to setup, with configuration files being only a [few lines long](https://wiki.archlinux.org/index.php/WireGuard#Server_config). WireGuard purposely does not have dozens of encryption and cipher options (think about choosing a cipher suite in OpenVPN). It's designed to lack cryptographic agility, so you don't waste time choosing poor ciphers or improperly configure encryption. [Keep It Simple, Stupid](https://en.wikipedia.org/wiki/KISS_principle).
2. WireGuard is proposed to be included directly into the Linux kernel, with Linus himself calling the code a "[work of art](http://lkml.iu.edu/hypermail/linux/kernel/1808.0/02472.html)". This makes WireGuard extremely fast (in most cases, near line-rate). This also greatly increases its possible user-base, as anything using Linux will have WireGuard available to it by default.
3. Clients are authenticated with public/private keypairs, like SSH. No more expiring certificates, and no worrying about the [key exchange problem](https://en.wikipedia.org/wiki/Key_exchange#The_key_exchange_problem).
4. Configuration files are very small, and can be distributed as a flat file, or as a QR code (super convenient for mobile devices).
5. WireGuard uses [modern](https://www.wireguard.com/protocol/) cryptography and ciphers that perform well on a wide range of devices (e.g., mobile devices), not just x86 and x64 hardware.
6. WireGuard is designed to be available when moving networks
7. WireGuard is only about 4k lines, making it easy to audit (though, it has not been audited yet)

Some other advantages to WireGuard that didn't fit into the categories above:

- WireGuard creates interfaces (e.g., _wg0_), which can be operated on like normal interfaces with tools like _ip_ and _ifconfig_. It can also be managed by any network manager (e.g., systemd-networkd or NetworkManager).
- WireGuard is not a "chatty" protocol in that fact that it only transmits data when it needs to. When there is nothing to send, nothing is sent. This saves CPU, battery, data, etc...
- If WireGuard is misconfigured, it will generally not work, rather than working insecurely.
- Wireguard doesn't respond to unauthenticated packets, so there's no way to "scan" for a WireGuard server, making it stealthy.
- WireGuard has built-in quantum cryptography resistance, with the ability to use a pre-shared key as well.

## Why you shouldn't use WireGuard

- WireGuard is not a finished product, and should not be used in production yet. It also has not been formally audited.
- WireGuard is available for a variety of [platforms](https://www.wireguard.com/install/) (e.g., Linux, Mac, Android, iOS, BSDs), but not Windows (yet). Any other Windows clients are unofficial (as-of this writing).

Give WireGuard a try!

\-Logan
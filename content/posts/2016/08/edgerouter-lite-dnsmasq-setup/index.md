---
title: "EdgeRouter Lite Dnsmasq setup"
date: "2016-08-30"
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

{{% series/s_ubiquiti %}}

# Introduction

One of my only complaints about the EdgeRouter Lite is the usage of the [Internet Systems Consortium (ISC) DHCP](https://en.wikipedia.org/wiki/DHCPD) server. My main issue is that the DHCP server does not integrate with the DNS server. Because of this, DHCP names/leases are not automatically added to DNS. This topic has been addressed a few times before ([here](https://www.reddit.com/r/Ubiquiti/comments/4jtli1/i_would_like_to_access_my_lan_devices_by_name), [here](https://www.reddit.com/r/Ubiquiti/comments/2cm0f1/local_dns_host_resolution/), [here](https://community.ubnt.com/t5/EdgeMAX/etc-hosts-and-resolving-names/td-p/461725), [here](https://community.ubnt.com/t5/EdgeMAX/Automatic-DNS-resolution-of-DHCP-client-names/td-p/651311), and [here](https://community.ubnt.com/t5/EdgeMAX/Setting-up-Local-DNS/td-p/449259)).

However, with the release of the [v1.9.0 EdgeMax software](http://community.ubnt.com/t5/EdgeMAX-Updates-Blog/EdgeMAX-EdgeRouter-software-release-v1-9-0/bc-p/1643335) (you can use my [software upgrade guide](/2016/06/edgerouter-lite-software-upgrade/)), Ubiquiti offers the use of [dnsmasq](https://en.wikipedia.org/wiki/Dnsmasq). Based on a script by the forum user _final_, the [dnsmasq script](http://community.ubnt.com/t5/EdgeMAX/DNS-resolution-of-local-hosts/m-p/1481650#M97797) has been incorporated into v.1.9.0, but only at the command-line, no GUI usage is setup yet. With dnsmasq, when you give a specific host a static lease, the host will be added to DNS, by name, automatically.

## ISC vs dnsmasq

With both ISC and dnsmasq, you would need to specify a static lease for each device.

```
set service dhcp-server shared-network-name LAN subnet 10.10.2.1/24 static-mapping device1 ip-address 10.10.2.32
set service dhcp-server shared-network-name LAN subnet 10.10.2.1/24 static-mapping device1 mac-address 'XX:XX:XX:XX:XX:XX'
```

However, ISC does not add the above entries to DNS (which dnsmasq does). Because of this, you'll need to add each device to DNS (if you're using ISC).

```
set system static-host-mapping host-name device1.<yourdomain> inet 10.10.2.32
set system static-host-mapping host-name device1.<yourdomain> alias device1
```

If you want to use ISC, but don't want to set the static-host-mapping entry for each device, you can set the _/etc/hosts_ file to automatically update with DNS entries. However, that's a lot of adding/subtracting from the hosts file, and there have been reports that [expired leases aren't deleted](https://community.ubnt.com/t5/EdgeMAX/hostfile-update-enable-doesn-t-clear-expired-leases/td-p/969389) from the hosts file.

```
set service dhcp-server hostfile-update enable
```

Instead, I'm going to switch to dnsmasq. I've used it on OpenWrt, DD-WRT, and Linux, so I prefer it. The caveats of dnsmasq (in Ubiquiti's current implementation) are outlined below.

- One of the advantages of using dnsmasq is that, if DNS forwarding is also configured, the "name resolution for local hosts" function is integrated, and the "hostfile-update" setting for the ISC DHCP implementation is not needed (it is ignored when use-dnsmasq is enabled).
- When use-dnsmasq is enabled, DHCP server will serve the "listen-on" interfaces configured under "service dns forwarding", or all interfaces if that is not configured.
- Since some of the existing DHCP server config settings are specific to the ISC DHCP implementation (e.g., the failover settings, the "free-form" parameters settings), those will be ignored when use-dnsmasq is enabled.
- If "free-form" parameters for dnsmasq are needed, they can be entered under DNS forwarding config, e.g., "set service dns forwarding options ...".
- When use-dnsmasq is enabled, the "authoritative" setting is not "per-shared-network", i.e., "authoritative" will be enabled if it is set under any shared-network.
- When use-dnsmasq is enabled, the entries configured under "static-mapping" will be translated to statically assigned A records in dnsmasq (using the dnsmasq host-record directive). If a client with a static-mapping entry sends a DHCP request with a different client-name, that client-name will be ignored.
- Currently use-dnsmasq only handles "configuration", and status reporting (including show commands in the CLI and the leases display in the Web UI for example) is not supported yet.

# Enable dnsmasq

For dnsmasq to be setup properly, you need to have DNS setup to listen on certain interfaces, otherwise it will listen on all interfaces. You should also set the nameserver to the localhost (so dnsmasq is used first), then forward queries to external DNS servers. This setup is described in my [initial setup](/2016/04/ubiquiti-edgerouter-lite-setup/), and also shown below.

```
configure
set service dhcp-server shared-network-name LAN subnet 10.10.2.1/24 dns-server 10.10.2.1
set service dns forwarding listen-on eth1
set service dns forwarding cache-size 400
set system name-server 127.0.0.1
set service dns forwarding name-server 50.116.40.226
set service dns forwarding name-server 107.170.95.180
```

Next, you need to set a local domain name, as shown below.

```
set system domain-name home.lan
```

Then, enable dnsmasq.

```
set service dhcp-server use-dnsmasq enable
commit
save
```

# Test

At this point (you may need a reboot), you should be able to ping your devices by hostname (as configured in the static-mapping section, above).

```
/home/ubnt
ubnt@erl
--> ping rpi01_lan
PING rpi01_lan.home.lan (10.10.2.32) 56(84) bytes of data.
64 bytes from rpi01 (10.10.2.32): icmp_req=1 ttl=64 time=0.404 ms
64 bytes from rpi01 (10.10.2.32): icmp_req=2 ttl=64 time=0.373 ms
64 bytes from rpi01 (10.10.2.32): icmp_req=3 ttl=64 time=0.310 ms
```

You should also be able to access any device via its name, instead of IP.

{{< img src="20160830_001.png" alt="screenshot" >}}

Hope this helps!

\-Logan

# Comments

[Old comments from WordPress](/2016/08/edgerouter-lite-dnsmasq-setup/comments.txt)
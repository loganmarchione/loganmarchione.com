---
title: "Let's Encrypt wildcard certificates with Certbot on Nginx"
date: "2018-09-27"
author: "Logan Marchione"
categories: 
  - "cloud-internet"
  - "encryption-privacy"
  - "oc"
cover:
    image: "/assets/featured/featured_lets_encrypt.svg"
    alt: "featured image"
    relative: false
---

# Introduction

In March of 2018, [Let's Encrypt](https://letsencrypt.org/) (the free Certificate Authority) [announced](https://community.letsencrypt.org/t/acme-v2-and-wildcard-certificate-support-is-live/55579) they added support for [wildcard certificates](https://en.wikipedia.org/wiki/Wildcard_certificate) through the upgraded [ACMEv2](https://datatracker.ietf.org/wg/acme/about/) protocol. I've been hosting most of my services on subdirectories (e.g., `loganmarchione.com/rss`) but have been wanting to move them to subdomains (e.g., `rss.loganmarchione.com`), and thought this was the perfect chance to do just that.

## What are wildcard certificates?

Wildcard certificates cover any subdomain of a specific domain. For example, I own `loganmarchione.com`. Because of this, I can create services as subdomains of that domain. For example:

```
www.loganmarchione.com
rss.loganmarchione.com
mail.loganmarchione.com
```

Using traditional certificates, I would need to request a certificate with one subject name and three [subject alternative names](https://en.wikipedia.org/wiki/Subject_Alternative_Name). However, if I ever added another subdomain, I would need to re-request my certificate with the added domain.

By contrast, using wildcard certificates, I can request one certificate that is valid for `loganmarchione.com` and `*.loganmarchione.com`. Then, I can add any subdomain (e.g., `testweb.loganmarchione.com` or `files.loganmarchione.com`), and my single certificate will cover it.

## How are wildcard certificates requested?

This is going to very quickly go down a rabbit-hole, since there are a lot of moving parts to keep track of.

### ACME

First, we need to understand what ACME is and why it is important. The [Automated Certificate Management Environment](https://en.wikipedia.org/wiki/Automated_Certificate_Management_Environment) (ACME) protocol was created by the [Internet Security Research Group](https://en.wikipedia.org/wiki/Internet_Security_Research_Group) (ISRG) back in 2016. In the past, when you wanted to create a SSL certificate for you website, you had to perform a long list of manual steps:

- on the server, create a public/private keypair
- on the server, create a [certificate signing request](https://en.wikipedia.org/wiki/Certificate_signing_request) (CSR), including information like the domain name, business name, country/city/state, etc...
- on the server, sign the CSR with your keys
- submit the CSR to the [Certificate Authority](https://en.wikipedia.org/wiki/Certificate_authority) (CA)
- the CA will sign the CSR and return a certificate (you typically paid at least $99 for this)
- move the certificate to the server
- on the server, update your webserver config file to point to the new certificate

ACME automates almost 100% of this process. You simply need to download a client that is ACME-compatible, and run one command that will perform all of the functions above.

### Let's Encrypt

An automated protocol is pretty useless without a CA willing to provide certificates via that protocol. To parallel the launch of ACME, the ISRG, the [Electronic Frontier Foundation](https://www.eff.org/) (EFF), [Mozilla](https://www.mozilla.org), and other, created [Let's Encrypt](https://letsencrypt.org/). Let's Encrypt is CA that issues free certificates using the ACME protocol. Not only are the certificates free, but Let's Encrypt is a very transparent organization, and they try to use open source software wherever possible.

At the time of this writing, Let's Encrypt has [issued](https://letsencrypt.org/stats/) 50+ million active certificates, which means almost 75% of internet page loads are over HTTPS now (according to Firefox telemetry).

### ACME clients

Because ACME is an open protocol, anyone can write a client for ACME. The most popular, by far, is [Certbot](https://certbot.eff.org/), which was created by the EFF. Certbot runs on the most platforms, and has the most features, including ACMEv2 support. Most guides will recommend using Certbot, which I do as well.

### DNS providers

At the time of this writing, Certbot only supports a handful of DNS providers, listed [here](https://certbot.eff.org/docs/using.html#dns-plugins). I chose to use [NS1.com](https://ns1.com/). They offer a free tier with reasonably priced paid tiers, as well as a variety of [record types](https://ns1.com/knowledgebase/record-types). In the past, I've [talked](/2017/09/creating-caa-records/) about Hurricane Electric and how much I like their service, but unfortunately, they don't yet offer an API that Certbot can use.

# DNS setup

## Create DNS entries

You can't create a wildcard certificate if you don't have a wildcard subdomain. I created the wildcard subdomain `*.loganmarchione.com` in NS1's portal.

{{< img src="20180927_001.png" alt="screenshot" >}}

## Create API key

Next, I created an API key for NS1. This will allow Certbot to add/remove DNS entries without needing my NS1 username/password. I won't cover that here, but it's very simple if you follow [their guide](https://ns1.com/knowledgebase/creating-and-managing-api-keys) and give permissions to the API as shown below.

{{< img src="20180927_002.png" alt="screenshot" >}}

# Install Certbot on Nginx

I'm using Nginx, Certbot, and NS1.com, so I should be using the Certbot plugin called [certbot-dns-nsone](https://certbot-dns-nsone.readthedocs.io/en/latest/). However, that plugin isn't available on my distribution (Ubuntu 16.04) yet. Because of this, I need to install [pip](https://pypi.org/project/pip/), which is Python's package manager, as well as Certbot for Nginx.

```
sudo apt-get install python3-pip python-certbot-nginx
```

Then, using pip, I can install the certbot-dns-nsone plugin.

```
pip install certbot_dns_nsone
```

Finally, I need to create a file containing my NS1 API key.

```
# NS1 API credentials used by Certbot
dns_nsone_api_key = MDAwMDAwMDAwMDAwMDAw
```

# Requesting a certificate

## ACMEv1 (non-wildcard)

ACMEv1 was the first implementation of ACME. It required you to create a directory called `.well-known` on your webserver (e.g., `loganmarchione.com/well-known`) where the ACME client would write temporary information. When running the ACMEv1 client to request a certificate, the following things would happen:

- the ACME client would reach out to the Let's Encrypt servers
- the Let's Encrypt servers would give the ACME client a secret code to place in the `.well-known` directory
- the ACME client would place the code in the directory
- the Let's Encrypt servers would check for the code
- if the codes matched, this proved the person running the command owned the domain name, and the certificate would be issued

The only downside to this system was the fact that a directory needed to be opened up to the public internet, which was ok for internet-facing sites, but bad for internal networks (e.g., your home network).

With ACMEv1, I would need to request a certificate with one subject name and three [subject alternative names](https://en.wikipedia.org/wiki/Subject_Alternative_Name), using the command below.

```
certbot certonly --webroot -w /var/www/wordpress/loganmarchione -d loganmarchione.com -d www.loganmarchione.com -d rss.loganmarchione.com -d mail.loganmarchione.com
```

While there is nothing wrong with this, if I added a subdomain (e.g., `analytics.loganmarchione.com`), I would need to request a new certificate with the added subdomain.

## ACMEv2 (wildcard)

ACMEv2 still allows you to use the `.well-known` method, but added the ability to verify domains by allowing [TXT records](https://en.wikipedia.org/wiki/TXT_record) to be inserted into DNS. Now, when requesting a certificate, the following happens:

- the ACME client would reach out to the Let's Encrypt servers
- the Let's Encrypt servers would give the ACME client a secret code to place into DNS
- the ACME client would place the code into DNS (using the API key to login)
- the Let's Encrypt servers would check for the code
- if the codes matched, this proved the person running the command owned the domain name, and the certificate would be issued and the code removed from DNS

This has the limitation of only supporting a small handful of DNS providers that offer an automated API, but it allows you to request certificates without needing to open your service to the public-facing internet (great for homelab use!).

Using ACMEv2 and wildcard certificates, I can request one certificate that is valid for `loganmarchione.com` and `*.loganmarchione.com`.

```
certbot certonly --dns-nsone --dns-nsone-credentials /path/to/credentials --agree-tos --non-interactive -m email@domain.com -d loganmarchione.com -d *.loganmarchione.com
```

With wildcard, certificates, I can add any subdomain (e.g., `testweb.loganmarchione.com`, `files.loganmarchione.com`), and my single certificate will cover it.

# Nginx config

While Certbot can manage your Nginx config, I prefer to do it manually. To use the wildcard certificate, simply add the `*.domain.com` entry to your _server\_name_ declaration.

```
server {
  listen 80;
  listen [::]:80;
  server_name loganmarchione.com *.loganmarchione.com;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name loganmarchione.com *.loganmarchione.com;

  #SSL/TLS settings
  ssl_certificate /etc/letsencrypt/live/loganmarchione.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/loganmarchione.com/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/loganmarchione.com/chain.pem;

  root /var/www/wordpress/loganmarchione;
  autoindex off;
  index index.php index.html;
  ...
  ...
}
```

Anyways, I hope that helps!

\-Logan
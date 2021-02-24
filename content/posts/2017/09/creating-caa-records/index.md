---
title: "Creating CAA records"
date: "2017-09-21"
author: "Logan Marchione"
categories: 
  - "cloud-internet"
  - "oc"
cover:
    image: "/assets/featured/featured_generic_lock.svg"
    alt: "featured image"
    relative: false
---

# Introduction

Certification Authority Authorization (CAA) is a new DNS record specifying which Certificate Authorities (CAs) are allowed to issue certificates for a domain. Introduced by [RFC 6844](https://tools.ietf.org/html/rfc6844), CAA protects websites by only allowing certificates to be issued by specific CAs. If an attacker were to take over a website, they would only be able to obtain a certificate from a CA specified in DNS CAA records, limiting the damage they could do. While CAA records aren't going to completely stop certificate misuse, they are easy to implement and are part of a larger security plan.

It's important to note that creating CAA records for your domain is optional. However, as of [September 8, 2017](https://www.bleepingcomputer.com/news/security/https-certificate-issuance-becomes-more-secure-thanks-to-new-caa-standard/), all CAs will be required to check CAA records and comply with them, but only if they exist. If a CAA record is in place, only the specified CA can issue a certificate to the domain. If no CAA record is in place, any CA can issue a certificate to the domain.

In addition, Qualys SSL Labs is now testing for the presence of CAA records.

{{< img src="20170921_001.jpg" alt="screenshot" >}}

# CAA format

A CAA record is made up of the following elements:

- flag - a number between 0-255, but right now only 0 (non-critical) and 1 (critical) are used
- tag - a string consisting of one of the three elements below:
    - issue - allows a CA to issue regular certificates
    - issuewild - allows a CA to issue wildcard certificates
    - iodef - the URL where the CA can report issues or violations
- value - a string to represent the value of the tag

In DNS, the CAA format will look like this:

```
example.com CAA <flags> <tag> <value>
```

For example, my CAA records only allow Let's Encrypt to issue regular certificates, denies any CA from issuing wildcard certificates, and also lists a contact address in case of any violation.

```
loganmarchione.com. CAA 0 issue "letsencrypt.org"
loganmarchione.com. CAA 0 issuewild ";"
loganmarchione.com. CAA 0 iodef "mailto:email@domain.com"
```

# CAA generation

You don't need to be an expert to create CAA records. [SSLMate](https://sslmate.com/) has created an [open source tool](https://sslmate.com/caa/) to generate CAA records for you. All you need to do is copy/paste them into your DNS page.

# DNS provider migration

It seems that because CAA is a relatively new standard, not all DNS providers support it yet. In that case, you might need to switch DNS providers. For example, my DNS provider, [Hover](https://hover.com/qs57M9Ha), does not support CAA records. I also have a Dyn account, but I would need to pay $60/year for each domain.

## Hurricane Electric

While looking for a dedicated DNS host, I kept seeing [Hurricane Electric](https://he.net/) (HE) popup on various subreddits and forums. They are a global ISP that offers carrier-level services, as well as free services such a DNS and dynamic DNS. While their website is lacking in the visual and documentation departments, they more than make up for it in the services they offer. However, there is a bit of a learning curve and you need to know a little about DNS in order to make changes.

First, create an account at [dns.he.net](https://dns.he.net/). I'd also recommend enabling two-factor authentication. Once you're set, login to [dns.he.net](https://dns.he.net/) again.

Then, from the menu on the left, click _Add a new domain_. In the prompt, enter your domain name (even if you didn't purchase the name from HE).

{{< img src="20170924_001.png" alt="screenshot" >}}

Then, click the pencil icon to edit the domain.

{{< img src="20170924_002.png" alt="screenshot" >}}

Here, you'll see a scary looking message saying that your domain is not delegated to HE's nameservers. That's because you need to go into your registrar's page (in my case, [Hover](https://hover.com/qs57M9Ha)) and edit the nameservers to point to HE's servers.

{{< img src="20170924_003.png" alt="screenshot" >}}

Update your nameservers to use HE's nameservers. I had to remove the _Transfer Lock_ on my domain in order for the delegation to take place. That setting shouldn't affect DNS servers, but the changes wouldn't take effect while the domain was locked.

{{< img src="20170924_004.png" alt="screenshot" >}}

While that's processing, add your DNS records in HE's control panel. In my case, I first had to duplicate all the records that were already in Hover's DNS (A, AAAA, MX, etc...). Once they're added in HE's control panel, delete them from Hover's control panel.

{{< img src="20170924_005.png" alt="screenshot" >}}

Next, I added the new CAA records.

{{< img src="20170924_006.png" alt="screenshot" >}}

{{< img src="20170924_007.png" alt="screenshot" >}}

{{< img src="20170924_008.png" alt="screenshot" >}}

Keep in mind, it may take up to 24 hours for DNS changes to propagate throughout the internet. In my case, it took about 3-4 hours, during which time, my website and email were inaccessible. Verify the changes are in place by doing a [WHOIS lookup](https://bgp.he.net/) and looking for HE's nameservers. If the nameservers are listed, click _Check Delegation_ in HE's control panel to verify HE has delegation over your domain.

{{< img src="20170924_009.png" alt="screenshot" >}}

You can see SSL Labs is now testing OK for CAA records.

{{< img src="20170924_010.png" alt="screenshot" >}}

Hope this helps!

\-Logan

# Comments

[Old comments from WordPress](/2017/09/creating-caa-records/comments.txt)
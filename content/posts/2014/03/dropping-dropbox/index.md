---
title: "Dropping Dropbox"
date: "2014-03-26"
author: "Logan Marchione"
categories: 
  - "cloud-internet"
  - "storage"
cover:
    image: "/assets/featured/featured_generic_cloud_no_blue.svg"
    alt: "featured image"
    relative: false
---

I dropped Dropbox! Well, not entirely.

I've been a Dropbox user since Day 1. I remember when their service was first introduced. Cloud storage was just coming out and it was so convenient to be able to access your data anywhere.

I quickly outgrew the 2GB free limit, earned a few extra GB through DropQuest, and then decided to start [paying](https://www.dropbox.com/help/73/en) for their storage. For the past few years, I've been paying $99/yr for 100GB of space. Honestly, I have never had a single problem with Dropbox since I first started using it and I would recommend it to anyone in a second.

However, in light of recent events, I've been worried about my data in the cloud. Dropbox encrypts data in transit and stores it in [Amazon's S3 storage](http://www.datacenterknowledge.com/archives/2013/10/23/how-dropbox-stores-stuff-for-200-million-users/). While your data is stored encrypted, Dropbox holds the keys. According to a Dropbox [Help Center article](https://www.dropbox.com/help/27/en):

- Dropbox users can't view your files (unless you share them)
- Dropbox employees are prohibited from viewing your files

To me, the devil is in the details. While a regular Dropbox user can't view my files, any Dropbox employee can, they're just not allowed to. Because I'm not encrypting my files before transit (I'm letting the Dropbox app do it), they can be decrypted by Dropbox employees. Dropbox says they do this to comply with any legal requests, which is completely understandable. However, with the NSA looking to [add Dropbox](http://www.theguardian.com/world/2013/jun/06/us-tech-giants-nsa-data) to the list of PRISM providers, I'm not too excited about my data being decrypted whenever the government demands it.

Before my year-long contract renewed, I made the decision to downgrade to a free account until I can figure out how I want to use cloud storage. I considered using TrueCrypt containers inside Dropbox, but I was concerned about whether or not the entire container would need synced every time I changed a single file within. I also considered a service like SpiderOak that claims to have a [zero-knowledge](https://spideroak.com/zero-knowledge/) policy. Wuala also offers zero-knowledge, but with [data centers in Switzerland](https://www.wuala.com/en/learn/technology).

Until then, I'm not worried about storing my non-sensitive data in the cloud. So far, I've managed to accumulate 41GB worth of free storage:

- 2GB with Dropbox
- 2GB with SpiderOak
- 5GB with Wuala
- 7GB with OneDrive
- 10GB with Tresorit
- 15GB with Google Drive

\-Logan
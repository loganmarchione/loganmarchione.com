---
title: "TrueCrypt may not be secure"
date: "2014-05-28"
author: "Logan Marchione"
categories: 
  - "encryption-privacy"
  - "linux"
cover:
    image: "/assets/featured/featured_generic_lock_no_white.svg"
    alt: "featured image"
    relative: false
aliases:
    - /2014/05/truecrypt-may-not-be-secure/
---

Recently, I posted three articles of a four-part series showing how to encrypt an external drive with TrueCrypt on Fedora 20. As-of today, May 28th, TrueCrypt may not be secure after-all.

The truecrypt.org website now redirects to [truecrypt.sourceforge.net](http://truecrypt.sourceforge.net/). A warning is displayed that reads, "**WARNING: Using TrueCrypt is not secure as it may contain unfixed security issues**" and it directs users to alternative encryption packages for Windows, Mac, and Linux.

{{< img src="20140528_001.png" alt="screenshot" >}}

[Ars Technica](http://arstechnica.com/security/2014/05/truecrypt-is-not-secure-official-sourceforge-page-abruptly-warns/), [Hacker News](https://news.ycombinator.com/item?id=7812133), and [The Register](http://www.theregister.co.uk/2014/05/28/truecrypt_hack/) have a good articles, so I won't repeat everything they're saying. Initially, it appeared that the TrueCrypt website was hacked. However, in addition to the website updates, [new binaries](https://github.com/warewolf/truecrypt/compare/master...7.2) were released that display warnings like **INSECURE_APP** when users try to encrypt data. The binaries, however, are signed with the developer's key. In addition, a Wikipedia user named [Truecrypt-end](https://en.wikipedia.org/wiki/Special:Contributions/Truecrypt-end) attempted to update the Wikipedia page with the same messages, but it was rejected by moderators. TrueCrypt was recently going through an [independent security audit](http://istruecryptauditedyet.com/), and it passed [Phase 1](https://opencryptoaudit.org/reports/iSec_Final_Open_Crypto_Audit_Project_TrueCrypt_Security_Assessment.pdf) in April. However, this doesn't seem to be related.

A thread on [r/crypto](http://www.reddit.com/r/crypto/comments/26px1i/truecrypt_shutting_down_development_of_truecrypt/) offers up a couple explanations:

1. The website was hacked, and the keys are presumed to be compromised. The last working version is 7.1a and version 7.2 is a hoax/malware/spam
2. Something bad happened to the developers ([Lava-bit style](http://www.theregister.co.uk/2013/08/08/lavabit_shuts_down/) extortion or major bug/flaw found in code) and this version is legitimate

We'll have to see how this one plays out.

\-Logan
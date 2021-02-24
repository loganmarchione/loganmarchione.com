---
title: "UPDATE: TrueCrypt may not be secure"
date: "2014-06-02"
author: "Logan Marchione"
categories: 
  - "encryption-privacy"
  - "linux"
cover:
    image: "/assets/featured/featured_generic_lock_no_white.svg"
    alt: "featured image"
    relative: false
aliases:
    - /2014/06/update-truecrypt-may-secure/
---

Ever since TrueCrypt [disappeared](/2014/05/truecrypt-may-not-be-secure/ "TrueCrypt may not be secure") a few days ago, there has been a lot of speculation as to what happened. There are plenty of theories on [r/netsec](http://www.reddit.com/r/netsec/comments/26pz9b/truecrypt_development_has_ended_052814/), [r/linx](http://www.reddit.com/r/linux/comments/26qe9f/truecrypt_is_not_secure_official_sourceforge_page/), and [r/crypto](http://www.reddit.com/r/crypto/comments/26px1i/truecrypt_shutting_down_development_of_truecrypt/). Even [Bruce Schneier](https://www.schneier.com/blog/archives/2014/05/truecrypt_wtf.html) doesn't know what's going on.

There is a theory that the developer [threw in the towel](http://krebsonsecurity.com/2014/05/true-goodbye-using-truecrypt-is-not-secure/comment-page-1/#comment-255908), however, the most popular theory going around is that the NSA/FBI/other-three-letter-organization was involved and this is TrueCrypt's [warrant canary](https://en.wikipedia.org/wiki/Warrant_canary). Because they would not legally be allowed to divulge the fact that they were being forced to backdoor their software, they decided to suggest alternatives known to be backdoored, knowing that users would understand the secret message.

Personally, I think a tinfoil-style comment on [Ars Technica](http://arstechnica.com/security/2014/05/truecrypt-is-not-secure-official-sourceforge-page-abruptly-warns/?comments=1) sums it up best:

> Consider the logic of it. The version with the warning is signed with the true private signing key. So it is authentic. The explanation about this being related to Windows XP support is ridiculous. The suggestion to use BitLocker is quite telling. Now suppose that the author received a secret order from a secret court that required the author keep secret the secrecy of the secret order from the secret court. Furthermore, the author was secretly required to turn over his secret signing key to a secret third party.
> 
> If you were the author, what would you do? Consider your options.
> 
> One is that you could issue an update with a warning that the program is no longer secure. Even though the program really is, at this moment, secure. The only source code changes are to insert the warnings. But what the warnings are warning you about, but cannot just come out and say, is that the program will not be secure in the future because a third party now has the keys to sign authentic new insecure versions.
> 
> This wouldn't be unlike Lavabit shutting down. The author is choosing to fall on his sword for the good of everyone.

Up until v7.2, TrueCrypt was the best at what it did. In theory, as long as there was no flaw in the code, you could still use older versions of TrueCrypt without issue. Good news for you, as plenty of sites are now hosting archives of those older versions:

- [TrueCrypt.ch](http://truecrypt.ch/) - Hosted in Switzerland
- [GitHub](https://github.com/AuditProject/truecrypt-verified-mirror) - Team behind TrueCrypt audit
- [GitHub](https://github.com/DrWhax/truecrypt-archive)
- [Gibson Research Corporation](https://www.grc.com/misc/truecrypt/truecrypt.htm)
- [GitHub](https://github.com/FreeApophis/TrueCrypt)

Get downloading.

\-Logan
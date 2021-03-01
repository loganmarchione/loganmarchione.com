---
title: "Analytics with Hugo"
date: "2021-03-01"
author: "Logan Marchione"
categories: 
  - "oc"
  - "cloud-internet"
cover:
    image: "/assets/featured/featured_generic_chart.svg"
    alt: "featured image"
    relative: false
---

# Introduction

When I was running WordPress, I was using Matomo (formerly Piwik) for analytics. This solution worked for me, but was more complicated than I needed, and I didn't make use of 99% of the features. It also required PHP and MySQL/MariaDB, which were not installed on the new server hosting my Hugo-based blog. Because of this, I wanted to switch to a simpler analytics solution.

# Self-hosted vs SaaS

For a long time, I've hosted a Matomo instance on my server and proudly stated in my privacy policy:

> I host my own Matomo instance. Your data never leaves my server.

I did this to protect my users and respect their privacy. Additionally, if a user didn't want to be tracked: I set Matomo to respect their browser's [Do Not Track ](https://en.wikipedia.org/wiki/Do_Not_Track) header, or they could install something like NoScript or uBlock Origin, or they could disable JavaScript completely.

I started to look for a self-hosted, privacy-respecting analytics solution. In the end, however, the technical cost of installing, maintaining, and securing a self-hosted solution wasn't worth it (not to mention the techincal debt of PHP plus MySQL), so I decided to switch to SaaS.

# Comparison

Hugo comes with [built-in support for Google Analytics](https://gohugo.io/templates/internal/#google-analytics), which I obviously didn't use. While I found quite a few quality analytics products, I only specifically looked at solutions that allowed self-hosting. My reasoning was: if they're confident enough in their product to open-source it and allow me to host it, I'm confident enough to pay them for it.

{{< comparison/analytics >}}

In the end, I decided on Plausible analytics because:

- they are privacy-respecting
- they are GDPR-compliant (e.g., no cookies, no individual user tracking, no PII, etc...) and don't require a pop-up for consent
- they are the most affordable SaaS solution (and offer a 30-day free trial)
- they have a lightweight (<1KB) JavaScript tag
- they offer simple dashboards
- they are independent developers

# Plausible setup

From Plausible's [Hugo documentation](https://plausible.io/docs/hugo-integration), installation was pretty easy and I chose to simply add the tracking code to my theme's `<head>` section.

```
<script async defer data-domain="loganmarchione.com" src="https://plausible.io/js/plausible.js"></script>
```

I'm still on the 30-day free trial, but I don't see myself switching to anything else. They offer a ton of useful features that I may take advantage of in the future:

- [Custom domains](https://plausible.io/docs/custom-domain) (to serve the script from `loganmarchione.com` instead of `plausible.io`)
- [Email reports](https://plausible.io/docs/email-reports/)
- [Traffic spike notification](https://plausible.io/docs/traffic-spikes)
- [Public website stats](https://plausible.io/docs/visibility)
- [Google Search console integration](https://plausible.io/docs/google-search-console-integration) (to see the Google search terms)
- [404 page tracking](https://plausible.io/docs/404-error-pages-tracking)

\-Logan
---
title: "Deploying Hugo with Netlify"
date: "2022-02-08"
author: "Logan Marchione"
categories: 
  - "oc"
  - "cloud-internet"
cover:
    image: "/assets/featured/featured_netlify.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_hugo %}}

# Introduction

In my [last post](/2021/10/deploying-hugo-with-cloudfront-and-s3/), I was testing the deployment of Hugo with [CloudFront and S3](https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-serve-static-website/). My main complaints came from the complicated Terraform setup and the lack of easy redirects. Since Amplify and CloudFront+S3 are the only AWS-based offerings, I decided to check out alternatives outside the AWS umbrella.

# Static site hosting

As I've mentioned before, this is a static site. This site doesn't _need_ to be hosted on a VPS (which I need to patch and maintain), it could be hosted in the cloud, or completely on a CDN. There are a ton of developer-focused static hosts out there. A few I considered are below:
* [Netlify](https://www.netlify.com/)
* [Surge](https://surge.sh/)
* [Render](https://render.com/)
* [Firebase](https://firebase.google.com/products/hosting)
* [Vercel](https://vercel.com/)
* [CloudFlare Pages](https://pages.cloudflare.com/)
* [GitHub Pages](https://pages.github.com/)

They generally all offer a git-based workflow where you make commits to a branch, the host builds your website from the latest commit, and then publishes it to their CDN. Each has their quirks, but Netlify seemed to have the most features and came the most recommended via Reddit. On a side note, check out [this excellent post](https://kevq.uk/comparing-static-site-hosts-best-host-for-a-static-site/) by Kev Quirk comparing static site host performance.

## What I liked

* Ease of setup - Like AWS Amplify, this took less than 5 minutes to setup. Within 10 minutes, I had the site running on my custom test domain. Couldn't have been easier.
* Git-aware by default - Like the other static site hosts, git is a first-class citizen here. Plenty of features around branches, pull requests, etc...
* HTTPS - Netlify offers free [SSL certificates](https://docs.netlify.com/domains-https/https-ssl/) (via Let's Encrypt) for all their sites. They also support HTTP/2 when HTTPS is enabled.
* IPv6 - Netlify doesn't enable IPv6 by default, but it's [available](https://docs.netlify.com/domains-https/https-ssl/) if you use their DNS manager.
* Redirects - No serverless functions here, just a simple config file to do [redirects and URL rewrites](https://docs.netlify.com/routing/redirects/).
* Custom headers - The same config file also supports [custom headers](https://docs.netlify.com/routing/headers/).

## What I didn't like

* IPv6 support _only_ when using their DNS manager - I'm very particular about my infrastructure and manage my DNS with Route53 using Terraform. This is probably a niche use case, but if you want to use Netlify with a custom domain, with external DNS, you can't have IPv6. Netlify offers an [IPv4 load balancer IP](https://docs.netlify.com/domains-https/custom-domains/configure-external-dns/#configure-an-apex-domain), but no equivalent for IPv6. I found at least a few forum posts requesting this feature ([one](https://answers.netlify.com/t/aaaa-ipv6-record-for-apex-domains/11872), [two](https://answers.netlify.com/t/ipv6-address-for-netlify-load-balancer/8768), [three](https://answers.netlify.com/t/ipv6-endpoint-for-main-load-balancer/667)), so I can't be the only one who wants this. I'd like to see Netlify add an IPv6 endpoint to their load balancer (apparently this is a limit of their DNS provider, NS1) or create a Terraform provider to allow programmatic management of DNS records.

# Conclusion

Ultimately, I choose the tear down my Netlify demo site in favor of my plain-old Nginx server. If you're keeping track, the score is:

| Product     | Score |
| ----------- | ----- |
| Nginx       | 3     |
| Serverless  | 0     |

If you host a Hugo site, tell me how! I'm open to any options!

\-Logan
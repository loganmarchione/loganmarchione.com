---
title: "Deploying Hugo with AWS Amplify"
date: "2021-09-21"
author: "Logan Marchione"
categories: 
  - "oc"
  - "cloud-internet"
cover:
    image: "/assets/featured/featured_aws_amplify.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_hugo %}}

# Introduction

Since I [migrated from WordPress to Hugo](/2021/02/migrating-from-wordpress-to-hugo), I've dropped the need to run PHP and MySQL on my server. This means my server is now only running Nginx, serving up static HTML/CSS/JS files. For a simple site like mine, even a VPS running Nginx is overkill. This site doesn't _need_ to be hosted on a VPS, it could be hosted in the cloud, or completely on a CDN.

This will be the first of a small series of posts about my future hosting options for this site.

# Hosting evolution of this site

I've changed hosts and methods of hosting over the years, so here is an abbreviated history of my past hosting adventures.

1. 2014-2015: Vendor-managed WordPress on Bluehost - Easy to get started, but not very flexible (couldn't change webserver or PHP settings). I migrated away after 6 months. Bluehost managed the OS and application updates.
1. 2015-2021: Self-managed WordPress on DigitalOcean VPS - I installed a LEMP stack on a DigitalOcean VPS, then installed WordPress on top of that. I managed the OS and application updates.
1. 2021: Self-managed Hugo on DigitalOcean VPS - I migrated to Hugo, which meant I could remove PHP and MySQL from my server. I setup GitHub Actions based on [this post](https://zartman.xyz/blog/gh-static-deploy/) to rebuild and push my site to the VPS whenever there was a commit. I managed the OS and application updates (just not PHP and MySQL anymore).

# Ways to host a static site on AWS

## Why AWS?

As much as I don't like to give Jeff Bezos more money, my new employer (post on that coming soon!) is heavily invested in AWS. Therefore, I thought this would be the perfect time to migrate my site. I could simplify my site's workflow, and learn AWS/Terraform at the same time. Plus, AWS has many ways to host a site, so I can explore multiple options under one vendor.

## Lightsail or EC2

[Lightsail and EC2](https://aws.amazon.com/free/compute/lightsail-vs-ec2/) are both classes of virtual machines in AWS (Lightsail being more simple, EC2 being more complex). Choosing either of these would basically be like what I'm doing now with DigitalOcean, but on AWS instead. There's nothing wrong with this, but also no compelling reason to switch.

## S3 + CloudFront

[S3](https://aws.amazon.com/s3/) is Amazon's object storage, while CloudFront is their [CDN](https://aws.amazon.com/cloudfront/). You can host a [site directly from S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html), but it won't have HTTPS. If you put [CloudFront in front of S3](https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-serve-static-website/), you get all the benefits of HTTPS and Amazon's CDN.

## Amplify

[AWS Amplify](https://aws.amazon.com/amplify/) was what I was most excited to try. Amplify has a ton of features that I won't make use of, but for the sake of a static site, think of Amplify as `S3 + CloudFront + Git + CI/CD`. In addition, Hugo has [official documentation](https://gohugo.io/hosting-and-deployment/hosting-on-aws-amplify/) for hosting a site on Amplify.


# Amplify

## Setup

The setup couldn't have been easier. Again, following Hugo's [official documentation](https://gohugo.io/hosting-and-deployment/hosting-on-aws-amplify/), you basically tell Amplify what GitHub repo you want to use, configure Amplify's own CI/CD language (like GitHub Actions), and it will rebuild your site any time there is a commit.

The site URL Amplify gives you is something like `https://branch-name.d1m7bkiki6tdw1.amplifyapp.com`, but you also have the option to use a [custom domain](https://docs.aws.amazon.com/amplify/latest/userguide/custom-domains.html) (like `loganmarchione.com`). If your DNS is through Route53 (like mine), Amplify will even setup your DNS records and generate a SSL/TLS certificate for you!

## What I liked

* Ease of setup - I can't explain to you how easy this was. I had the site running in 2 minutes, and had it hosted on my domain with SSL/TLS in 10 minutes.
* Git-aware by default - Amplify is super-intuitive to setup if you are used to CI/CD pipelines. Besides GitHub, it supports Bitbucket, GitLab, and AWS CodeCommit.
* Custom HTTP headers - Amplify allows you to set custom HTTP headers, including [security headers](https://docs.aws.amazon.com/amplify/latest/userguide/custom-headers.html#example-security-headers) to prevent XSS attacks and clickjacking.
* Separate TEST/PROD sites - Amplify can setup one URL for testing and one for production, based on the branches you specify.
* Password protection - You can setup HTTP basic authentication to protect development or test sites so that the public can't access them.

## What I didn't like

* Lack of IPv6 support - As far as I can find, Amplify does not support IPv6 (yet). There was a [GitHub issue](https://github.com/aws-amplify/amplify-js/issues/2769) that was closed as stale, and [another](https://github.com/aws-amplify/amplify-hosting/issues/2474) that's been sitting open, so I'm guessing it's not high on the AWS priority list. Even though I don't browse my own site over IPv6 (my ISP doesn't offer it), I want to offer IPv6 to my readers.
* The ability to arbitrarily host files on my VPS - I can't understate how nice it is to have a VPS in the cloud. I can uploads some random files and then quickly create an Nginx alias to access them. I could replace that with S3, but I'm already paying for the VPS, might as well use it.

# Conclusion

The lack of IPv6 support was the kicker for me, so I switched back to a DigitalOcean VPS for now. I'm considering the following things to try to get IPv6 working:

* Try to enable CloudFront in front of Amplify
* Test S3 + CloudFront

If you host a Hugo site, tell me how! I'm open to any options!

\-Logan

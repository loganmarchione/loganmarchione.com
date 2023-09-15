---
title: "Deploying Hugo with CloudFront and S3 (for real this time)"
date: "2023-10-13"
author: "Logan Marchione"
categories: 
  - "oc"
  - "cloud-internet"
cover:
    image: "/assets/featured/featured_aws_cloudfront_s3.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_hugo %}}

# Introduction

Two years ago, I [wrote](/2021/10/deploying-hugo-with-cloudfront-and-s3/) about deploying this site to CloudFront. I had a test version of the site running, but there were too many moving pieces, and to be honest, I wasn't that well-versed in Terraform or AWS.

In those two years, I tried a half-dozen times to move to a static-friendly host, but none of them had *all* of the features I wanted (free or paid).

* Ease of setup
* Git-aware by default
* Separate TEST/PROD sites
* IPv6 (using your own DNS)
* Custom HTTP headers
* HTTP redirects
* HTTPS

I've since stepped up my game and decided to jump back into hosting this site on CloudFront and S3.

# High-level overview

## Terraform code

## GitHub repo

https://major.io/p/cloudfront-migration/
https://robinvenables.com/posts/moving-away-from-aws-access-keys/
https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/



https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DefaultRootObject.html#DefaultRootObjectHow

https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-index.html

# Conclusion


\-Logan
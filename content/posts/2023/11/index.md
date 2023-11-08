---
title: "Deploying Hugo with CloudFront and S3 (for real this time)"
date: "2023-11-08"
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

# TL;DR

Good news everyone! If you're reading this (in late 2023), you're reading it via CloudFront instead of a VPS!

![meme](/assets/memes/good_news_everyone.jpg)

# Introduction

Two years ago, I [wrote](/2021/10/deploying-hugo-with-cloudfront-and-s3/) about deploying this site to CloudFront and S3. I had a test version of the site running, but there were too many moving pieces, and to be honest, I wasn't that well-versed in Terraform or AWS.

In those two years, I tried a half-dozen times to move to a static-friendly host, but none of them had *all* of the features I wanted (below). AWS Amplify came close, but didn't have IPv6 support.

* Ease of setup
* Git-aware by default
* Separate dev/prod sites
* IPv6 (using your own DNS)
* Custom HTTP headers
* HTTP redirects
* SSL/TLS

In that last post, I said:

> If I’m going to switch, it needs to be easier than Nginx.

Now, I'm eating those words. I've stepped up my game and decided to try again with hosting this site on CloudFront and S3.

# Design decisions

## Terraform

Not going to lie, this took me a solid week to come up with. I have multiple static sites and I wanted them to all have the same setup (without duplicating Terraform code), so I wrote a Terraform module, which I [published to GitHub](https://github.com/loganmarchione/terraform-aws-static-site). You can read the details and code on GitHub, but this module creates the S3 buckets, ACM certificate, Route53 entries, CloudFront distribution, and more.

```
################################################################################
### Module for static site
################################################################################

module "static_site_domain_com" {
  source = "github.com/loganmarchione/terraform-aws-static-site?ref=0.1.6"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  # The domain name of the site (**MUST** match the Route53 hosted zone name (e.g., `domain.com`)
  domain_name = "domain.com"

  # Since this is a static site, we probably don't need versioning, since our source files are stored in git
  bucket_versioning_logs = false
  bucket_versioning_site = false

  # CloudFront settings
  cloudfront_compress                     = true
  cloudfront_default_root_object          = "index.html"
  cloudfront_enabled                      = true
  cloudfront_function_create              = false
  cloudfront_function_filename            = "function.js"
  cloudfront_function_name                = "ReWrites"
  cloudfront_http_version                 = "http2and3"
  cloudfront_ipv6                         = true
  cloudfront_price_class                  = "PriceClass_100"
  cloudfront_ssl_minimum_protocol_version = "TLSv1.2_2021"
  cloudfront_ttl_min                      = 3600
  cloudfront_ttl_default                  = 86400
  cloudfront_ttl_max                      = 2592000
  cloudfront_viewer_protocol_policy       = "redirect-to-https"

  # IAM
  iam_policy_site_updating = false

  # Upload default files
  upload_index  = false
  upload_robots = false
  upload_404    = false
}
```

Yes, there were existing modules that created static sites ([one](https://github.com/infrable-io/terraform-aws-static-website), [two](https://github.com/joshuamkite/terraform-aws-static-website-s3-cloudfront-acm), [three](https://github.com/terraform-aws-modules/terraform-aws-cloudfront)), but none of them did *exactly* what I wanted, so I wrote my own. Therefore, it's pretty opinionated and you may not like some of the decisions I've made (but there are plenty of options to change).

## CloudFront

The main thing that kept me from moving away from my VPS was [Nginx](https://nginx.org/). I've been using it for years, it's easy to configure, it's a single server, it's simple, and it has *so many options*.

CloudFront, however, is a content delivery network (CDN), not a webserver. Because of that, it doesn't do all of the webserver-type things that I was used to with Nginx.

### Functions

[CloudFront Function](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html) are written in Javascript and do lightweight tasks like change headers, rewrite URLs, etc... To get some of my Nginx-like functionality into CloudFront, I had to use CloudFront Functions.

First, CloudFront has a concept of [default root objects](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DefaultRootObject.html#DefaultRootObjectHow). If you don't set a default root object, visiting `https://example.com` returns an error. However, you can manually type `https://example.com/index.html` to view the page (this is ugly). To fix this, set `index.html` as the default root object and visit `https://example.com`, it works!

But, if you visit any sub-page like `https://example.com/foo`, you get an error. Again, you can manually type `https://example.com/foo/index.html` to view the page (this is ugly). As you can see, default root objects don't work for sub-pages (because CloudFront isn't a webserver).


Second, I wanted to do URL rewrites/redirects (e.g., redirect `/feed` to `/index.xml`) like I did in Nginx (below).

```
  location /feed {
    rewrite ^/feed$ /index.xml;
  }
```

To fix both of these issues, I created a CloudFront Function that is optionally applied via my Terraform module.

```
function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Responses
    var response_feed = {
        statusCode: 301,
        statusDescription: "Moved Permanently",
        headers: {
            "location": { "value": "/index.xml" }
        }
    }

    // Returns
    if (uri === "/feed" || uri === "/feed/") {
        return response_feed;
    }

    // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-index.html
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    // If none of the above conditions are met, return the original request
    return request;
}
```

### Caching

Caching was (and still is) harder than I thought it would be. There are two kinds of caching:

* browser caching (this is done by the user's browser and is hard for me to control)
* CDN caching (this is done by CloudFront and is controlled by me)

When someone visits a website and their browser tries to download `https://example.com/foo.jpg`, it first checks its local cache. If the file is there, it doesn't need to download it again, which makes the rest of the site load faster.

With Nginx, I was able to request that the user's browser cache files for a set number of days, based on filetype.

```
  location / {
    try_files $uri $uri/ =404;
    #Cache these filetypes in the user's browser for a set number of days
    location ~* \.(atom|bmp|css|doc|gif|ico|jpeg|jpg|js|pdf|png|ppt|rss|svg|tiff|ttf|woff|woff2|xls|zip)$ {
      expires 10d;
      add_header 'Cache-Control' 'private, must-revalidate';
    }
  }
```

However, what if I pushed an update to my site and *wanted* the user to download an asset again? I couldn't control that (because it was set to expire after 10 days) and now the user is viewing a version of my site with a mix of old and new assets. Obviously, I could have (and probably should have) set the number of days lower than `10`, but setting it too low defeats the purpose of a cache in the first place.

{{< img src="20230921_001p1.png" alt="nginx caching" >}}

The same problem applies to CloudFront, except now there is a second cache in the mix. When I push updates to S3, how can I tell CloudFront to update its copy of my static assets? Below is a [recreation of Josh Barratt's diagram](https://serialized.net/2017/06/maximizing-performance-with-cloudfront-s3-and-hugo/) that I think does a really good job of visualizing this.

{{< img src="20230921_001p2.png" alt="cloudfront caching" >}}

To solve these issues, I did a couple things.

For browser cache, you can't actually set this in CloudFront (again, CloudFront is not a webserver). Instead, I set the `Cache-Control` header on specific files in my Hugo `config.yaml` file, which is read during the `hugo deploy` command (more on that later). This actually sets the [metadata](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingMetadata.html#SysMetadata) on the files in S3, then CloudFront just forwards that metadata to the user. Also, notice how I turned the expiration time down to `86400` (one day) instead of 10 days, and that `html`, `json`, and `xml` files are only cached for `3600` (one hour).

```
deployment:
  targets:
    ...
    ...
    ...
  matchers:
    # cached with gzip compression enabled
    - pattern: "^.+\\.(js|css|md|otf|svg|ttf|txt)$"
      cacheControl: "max-age=604800, no-transform, public"
      gzip: true
    # cached with gzip compression disabled
    - pattern: "^.+\\.(bmp|gif|ico|jpeg|jpg|mp3|mp4|pdf|png|rss|tiff|woff|woff2)$"
      cacheControl: "max-age=604800, no-transform, public"
      gzip: false
    # sitemap gets a special content-type header
    - pattern: "^sitemap\\.xml$"
      contentType: "application/xml"
      cacheControl: "max-age=3600, no-transform, public"
      gzip: true
    # cached with gzip compression enabled
    - pattern: "^.+\\.(html|json|xml)$"
      cacheControl: "max-age=3600, no-transform, public"
      gzip: true
```

For CloudFront cache, I've setup multiple time-to-live (TTL) values that control how long the files stay in CloudFront's cache. It's important to try to strike a balance between how long the files live in CloudFront, and how often they come from S3.

* [minimum TTL](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesMinTTL) = `3600` (one hour)
* [default TTL](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesDefaultTTL) = `86400` (one day)
* [maximum TTL](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesMaxTTL) = `2592000` (30 days)

To force CloudFront to refresh all files in its cache when I do a deploy, I've setup my deployment script to force invalidation (more on that below).

## GitHub Actions

With my VPS, I was using GitHub Actions to build my site, then using rsync to move the files from the GitHub Actions runner to my VPS.

```
    ...
    ...
    ...
    - name: Build
      run: hugo --gc --baseURL="https://${{ env.URL_PRD }}"

    - name: SSH setup
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.DEPLOY_KEY }}" > ~/.ssh/deploy_key
        ssh-keyscan -p ${{ secrets.DEPLOY_PORT }} ${{ env.URL_PRD }} > ~/.ssh/known_hosts
        chmod -R 700 ~/.ssh
        chmod 600 ~/.ssh/deploy_key

    - name: Rsync
      run: |
        rsync -rltvz --delete --omit-dir-times \
          -e "ssh -i ~/.ssh/deploy_key -p ${{ secrets.DEPLOY_PORT }}" public/ \
          ${{ secrets.DEPLOY_USER }}@${{ env.URL_PRD }}:/var/www/${{ env.URL_PRD }}
```

For the switchover, I would need some way to push the files to S3. Luckily, Hugo has a built-in [deploy command](https://gohugo.io/hosting-and-deployment/hugo-deploy/), which can upload files to S3 and invalidate CloudFront cache automatically.

However, then comes the problem of authentication. I was initially going to create a long-lived AWS access key to use in my GitHub Actions, but kept reading about how great [OpenID Connect](https://en.wikipedia.org/wiki/OpenID#OpenID_Connect_(OIDC)) (OIDC) is. It's still black magic to me, but basically, it allows GitHub Actions to send files to AWS S3 with no passwords or keys involved! :exploding_head:

Using some open source modules ([one](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-github-oidc-provider), [two](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-github-oidc-role)), I was able to setup GitHub as an OIDC provider in my AWS account, and create a role that GitHub Actions was able to assume.

```
################################################################################
### Module for OIDC provider
################################################################################

module "oidc_provider" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam?ref=v5.30.0//modules/iam-github-oidc-provider"
}

################################################################################
### Module for GitHub OIDC role
################################################################################

module "iam_github_oidc_role_loganmarchione_com" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam?ref=v5.30.0//modules/iam-github-oidc-role"

  name = "GitHubActionsOIDC-loganmarchione-com"
  policies = {
    SiteUpdating-loganmarchione-com = module.static_site_loganmarchione_com.site_updating_iam_policy_arn
  }
  subjects = ["loganmarchione/loganmarchione.com:*"]
}
```

My module has the option to create the IAM policy (called `SiteUpdating-loganmarchione-com`) needed to allow the GitHub OIDC role to update the files in S3 and create the cache invalidation.

```
{
  "Version" : "2012-10-17",
  "Id" : "SiteUpdating",
  "Statement" : [
    {
      "Sid" : "S3",
      "Effect" : "Allow",
      "Action" : [
        "s3:GetBucketPolicy",
        "s3:PutBucketPolicy",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
      ],
      "Resource" : [
        aws_s3_bucket.site.arn,
        "${aws_s3_bucket.site.arn}/*"
      ]
    },
    {
      "Sid" : "CloudFront",
      "Effect" : "Allow",
      "Action" : [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation",
        "cloudfront:ListInvalidations"
      ],
      "Resource" : aws_cloudfront_distribution.site.arn
    }
  ]
}
```

Then, I was able to use these GitHub Actions to get everything working. Magically, the files are uploaded to S3 without a password!

```
    ...
    ...
    ...
    permissions:
      id-token: write
      contents: read
    ...
    ...
    ...
    steps:
    ...
    ...
    ...
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: ${{ secrets.ROLE_TO_ASSUME_ARN_PRD }}
        role-duration-seconds: 900
        aws-region: us-east-2

    - name: Build
      run: hugo --gc -DEF --baseURL="https://${{ env.URL }}"
      env:
        URL: loganmarchione.com

    - name: Deploy to S3
      run: hugo deploy --maxDeletes -1 --invalidateCDN --target loganmarchione-com --logLevel info
```

Credit to these two blogs ([one](https://major.io/p/cloudfront-migration/), [two](https://robinvenables.com/posts/moving-away-from-aws-access-keys/)) for working examples. The docs for AWS and GitHub are also linked [here](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/) and [here](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services), respectively.

## Architecture

In the end, this is what I ended up with.

{{< img src="20211012_001.png" alt="architecture" >}}

# Things gained/lost

What did I gain and lose by switching from a VPS to CloudFront and S3?

## Gained

First is speed. Hosting on a single VPS with a local disk is fast (if you happen to be physically close to the VPS), but CloudFront puts me on every continent (if I want to pay for it).

Second is capacity. Not that my site is popular, but CloudFront has almost infinite capacity for traffic. Once CloudFront caches an object from S3 and distributes the object across its network, it's almost immune to any sort of traffic spike or DDoS.

Third is complexity (this is a negative). My site infrastructure is infinitely more complicated, and as AWS roles out new features, I'll have to update my Terraform to take advantage of them. I do this for a living, but I'll have to see what the maintenance overhead is over time. 

## Lost

First is simplicity. This was not easy to setup and took me weeks between writing the module, debugging the module, writing IAM policies, testing, etc...

Second is freedom. This basically locks me into AWS. Not saying that I can't go back to a VPS (because my static site is just a bunch of HTML/CSS/JavaScript), but I'm now dependent on AWS (which never goes down :zany_face:).

Third is maintenance (this is actually a positive). I no longer have to install/patch/maintain/backup a VPS, which is nice.

# Traffic and cost

My site isn't super busy, so it's very efficient to run via a CDN instead of a dedicated VPS. I cut over from my VPS to CloudFront on 2023-09-24, so the stats below are from 2023-10-01 to 2023-10-31.

I use [Plausible](https://plausible.io/) for analytics. Below you can see my traffic patterns for October 2023 (the first month on CloudFront).

{{< img src="20231108_001.png" alt="plausible" >}}

Below is data from the CloudFront dashboard. Here you can see the total HTTP requests (average is ~8500/day) and cache hit rate (~81%).

{{< img src="20231108_002.png" alt="cloudfront stats" >}}

{{< img src="20231108_003.png" alt="cloudfront stats" >}}

The next two graphs show the data transfer to viewers (~8GB for October 2023) and the HTTP status codes (~95% `2xx` and `3xx`).

{{< img src="20231108_004.png" alt="cloudfront stats" >}}

{{< img src="20231108_005.png" alt="cloudfront stats" >}}

This graph shows data transfer by destination.

{{< img src="20231108_006.png" alt="cloudfront stats" >}}

I was using a $6/month Digital Ocean droplet as my VPS. I already had my DNS in Route53, which was costing me $0.50/month for the hosted zone.

| Item                 | Cost  |
|----------------------|-------|
| Route53              | $0.50 |
| DigitalOcean         | $6    |

Using the [AWS Pricing Calculator](https://calculator.aws/), I guessed that the site would end up costing me around $2/month (including the $0.50 I was already paying for Route53). In reality, it ended up costing less than $1/month (note that I'm no longer in the [12-month AWS Free Tier](https://aws.amazon.com/free/)).

| Item                 | Cost                                |
|----------------------|-------------------------------------|
| Route53              | $0.50                               |
| S3 (less than 300MB) | $0.10                               |
| ACM                  | $0 (free for public SSL/TLS certs)  |
| CloudFront           | $0 (I'm under the Always Free Tier) |

As a safeguard, I always recommend creating an [AWS Budget in Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget). This budget below will alert me if my forcasted spend per month is over $10.

```
resource "aws_budgets_budget" "monthly_cost_forecast" {
  name              = "total-budget-monthly"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = formatdate("YYYY-MM-DD_hh:mm", timestamp())

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email_logan]
  }

  lifecycle {
    ignore_changes = [
      # Let's ignore `time_period_start` changes because we use `timestamp()` to populate
      # this attribute. We only want `time_period_start` to be set upon initial provisioning.
      time_period_start,
    ]
  }
}
```

# Conclusion

It's been over a month now and I have no complaints! AWS hasn't gone down yet (knock on wood), and I'm happy to retire another server and save some money while doing it!

\-Logan

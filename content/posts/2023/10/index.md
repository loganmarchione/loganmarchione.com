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

Two years ago, I [wrote](/2021/10/deploying-hugo-with-cloudfront-and-s3/) about deploying this site to CloudFront and S3. I had a test version of the site running, but there were too many moving pieces, and to be honest, I wasn't that well-versed in Terraform or AWS.

In those two years, I tried a half-dozen times to move to a static-friendly host, but none of them had *all* of the features I wanted (AWS Amplify came close, but didn't have IPv6 support).

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

## Terraform code

Not going to lie, this took me a solid week to come up with. Mostly because I have multiple static sites, and I wanted them all to be the same (without duplicating Terraform code), so I wrote a Terraform module, which I [published to GitHub](https://github.com/loganmarchione/terraform-aws-static-site). You can read the details and code on GitHub, but this module creates the S3 buckets, ACM certificates, Route53 entries, and CloudFront distribution.

```
################################################################################
### Module for static site
################################################################################

module "static_site_domain_com" {
  source = "github.com/loganmarchione/terraform-aws-static-site?ref=0.1.0"

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
  cloudfront_ttl_max                      = 31536000
  cloudfront_viewer_protocol_policy       = "redirect-to-https"

  # IAM
  iam_policy_site_updating = false

  # Upload default files
  upload_index  = true
  upload_robots = true
  upload_404    = true
}
```

Yes, there were existing modules that created static sites ([one](https://github.com/infrable-io/terraform-aws-static-website), [two](https://github.com/joshuamkite/terraform-aws-static-website-s3-cloudfront-acm), [three](https://github.com/terraform-aws-modules/terraform-aws-cloudfront)), but none of them did *exactly* what I wanted, so I wrote my own. Therefore, it's pretty opinionated and you may not like some of the decisions I've made (but there are plenty of options to change).

## CloudFront

The main thing that kept me from moving away from my VPS was [Nginx](https://nginx.org/). I've been using it for years, it's easy to configure, and it has *so many options*. CloudFront is a content delivery network (CDN), not a webserver (like Nginx). Because of that, you really need to be creative when trying to get CloudFront to do webserver-type things.

For example, CloudFront has a concept of [default root objects](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DefaultRootObject.html#DefaultRootObjectHow).

If you don't set a default root object, visiting `https://example.com` returns an error. However, you can manually type `https://example.com/index.html` and get the page back.

If you set `index.html` as the default root object and visit `https://example.com`, it works!

But, if you visit any sub-page like `https://example.com/foo`, you get an error. Again, you can manually type `https://example.com/foo/index.html` and get the page back.

To get around this, I had to use a [CloudFront Function](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html), which is lightweight JavaScript that runs on CloudFront's edge servers.

```
// https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-index.html
function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    return request;
}
```

You can use CloudFront Functions to do lightweight tasks like change headers, rewrite URLs, etc... However, I'm not sure if this adds any latency.

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

Using some open source modules, I was able to setup GitHub as an OIDC provider in my AWS account, and create a role that GitHub Actions was able to assume.

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

module "iam_github_oidc_role" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam?ref=v5.30.0//modules/iam-github-oidc-role"

  name = "GitHubActionsOIDC"
  policies = {
    SiteUpdating = module.static_site_loganmarchione_com.site_updating_iam_policy_arn
  }
  subjects = ["loganmarchione/loganmarchione.com:*"]
}
```

My module has the option to create the IAM policy (called `SiteUpdating`) needed to allow the role to update the files in S3 and create the cache invalidation.

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

Then, I was able to use these GitHub Actions to get everything working. Magically, the files are uploaded to S3!

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
        role-to-assume: ${{ secrets.ROLE_TO_ASSUME_DEV }}
        role-duration-seconds: 900
        aws-region: us-east-2

    - name: Build
      run: hugo --gc -DEF --baseURL="https://${{ env.URL }}"
      env:
        URL: loganmarchione.com

    - name: Deploy to S3
      run: hugo deploy --maxDeletes -1 --invalidateCDN --logLevel info
```

Credit to these two blogs ([one](https://major.io/p/cloudfront-migration/), [two](https://robinvenables.com/posts/moving-away-from-aws-access-keys/)) for working examples. The docs for AWS and GitHub are also linked [here](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/) and [here](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services), respectively.

# Things gained/lost

What did I gain and lose by switching from a VPS to CloudFront and S3?

## Gained

First is speed. Hosting on a single VPS with a local disk is fast (if you happen to be physically close to the VPS). But CloudFront puts me on every continent (if I want to pay for it).

Second is capacity. Not that my site is popular, but CloudFront has almost infinite capacity for traffic. Once CloudFront caches an object from S3 and distributes the object across its network, it's almost immune to any sort of traffic spike or DDoS.

Third is complexity (this is a negative). My site infrastructure is infinitely more complicated, and as AWS roles out new features, I'll have to update my Terraform to take advantage of them. I do this for a living, but I'll have to see what the maintenance overhead is over time. 

## Lost

First is simplicity. This was not easy to setup and took me weeks between writing the module, debugging the module, writing IAM policies, testing, etc...

Second is freedom. This basically locks me into AWS. Not saying that I can't go back to a VPS (because my static site is just a bunch of HTML/CSS/JavaScript), but I'm not dependent on AWS (which never goes down :squinting_face_with_tongue:).

Third is maintenance (this is actually a positive). I no longer have to install/patch/maintain/backup a VPS, which is nice.

## Cost

I was using a $6/month Digital Ocean droplet as my VPS. I already had my DNS in Route53, so that was costing me $0.50/month for the hosted zone, so the only cost I added was CloudFront and Route53.

# Conclusion


\-Logan
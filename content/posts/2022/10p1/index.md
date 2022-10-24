---
title: "The best DevOps project for a beginner"
date: "2022-10-20"
author: "Logan Marchione"
categories:
  - "oc"
  - "cloud-internet"
  - "linux"
cover:
    image: "/assets/featured/featured_generic_website.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I spend a lot of time on Reddit in [r/devops](https://reddit.com/r/devops/), [r/homelab](https://reddit.com/r/homelab), and [r/selfhosted](https://reddit.com/r/selfhosted), where I always see different versions of the same question:

> It's difficult to get hands-on experience in DevOps. What is a good beginner project?

I've posted this answer to Reddit multiple times before, but this post will have more detail.

# Static site

Build a static site. *That's the answer*.

![meme](/assets/memes/do_it_palpatine.gif)

## Why

A static site is a great beginner project because:
- This is a great chance to finally purchase `yourname.com`
- You can put whatever you want on a website (blog/resume/portfolio/business/etc...)
- You learn how websites works (e.g., domain names, DNS, web hosting, certificates)
- You learn how "the cloud" works (on a basic level)
- You learn [infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_code) (IaC) with [Terraform](https://www.terraform.io/)
- You learn [configuration management](https://en.wikipedia.org/wiki/Software_configuration_management) with [Ansible](https://www.ansible.com/)
- You learn how a [static site generator](https://en.wikipedia.org/wiki/Static_site_generator) works (you might even learn some HTML/CSS/JS)
- You learn how [Git](https://git-scm.com/) works
- You learn [continuous integration and continuous delivery](https://en.wikipedia.org/wiki/CI/CD) (CI/CD) with [GitHub Actions](https://github.com/features/actions)

## How

Below is my outline on the general steps to setup a static site. You don't need to follow it exactly, but it should be more than enough to get you started.

1. Purchase a domain
    - This can't be done via IaC
    - I like [Hover](https://www.hover.com/), but you can also use [Cloudflare](https://www.cloudflare.com/products/registrar/), [Namecheap](https://www.namecheap.com/), [AWS](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html), etc...
    - If this is a personal site, try to get a `.com` TLD, not `.net`, `.io`, `.ai`, etc...
1. Create a GitHub account and two repositories
    - One for your IaC code (Terraform and Ansible)
    - One for your static site's code
1. Provision a [virtual private server](https://en.wikipedia.org/wiki/Virtual_private_server) (VPS) in the cloud using Terraform
    - Use any VPS provider that has Terraform support ([DigitalOcean](https://registry.terraform.io/providers/digitalocean/digitalocean/) or [AWS](https://registry.terraform.io/providers/hashicorp/aws/) would be my recommendations, but you can also use [Linode](https://registry.terraform.io/providers/linode/linode/), [OVH](https://registry.terraform.io/providers/ovh/ovh/), [Oracle Cloud](https://registry.terraform.io/providers/oracle/oci/), [Scaleway](https://registry.terraform.io/providers/scaleway/scaleway/), etc...)
    - This code should be checked into Git on GitHub
    - Bonus: Don't hard-code your API keys anywhere in your Terraform code
    - Bonus: You can store your state locally (don't check it into Git), but consider storing it [remotely](https://www.terraform.io/language/state/remote) (HashiCorp offers free state storage in Terraform Cloud)
    - Bonus: Use [Atlantis](https://www.runatlantis.io/) with your GitHub account to run Terraform via pull requests to GitHub
1. Setup DNS using Terraform
    - After you get the IP of your VPS, you need DNS to link `yourname.com` to `1.2.3.4`
    - You can use a separate DNS provider (like [Cloudflare](https://registry.terraform.io/providers/cloudflare/cloudflare/), [NS1](https://registry.terraform.io/providers/ns1-terraform/ns1/), or [DNSimple](https://registry.terraform.io/providers/dnsimple/dnsimple/) ), but your VPS provider might also offer DNS (e.g., [DigitalOcean](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/record), [AWS Route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record), [Linode](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/domain_record), [Scaleway](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/domain_record), etc...)
    - This code should be checked into Git on GitHub
1. Configure the VPS using Ansible
    - After the VPS is online, you need to login, install updates, setup users, install packages, mess with configuration files, etc...
    - At the very least, you'll need a webserver installed (e.g., Nginx or Apache) and a few configuration files for your webserver put in the correct places
    - This code should be checked into Git on GitHub
    - Bonus: Get a TLS certificate for free from [Let's Encrypt](https://letsencrypt.org/) and configure your webserver to redirect from port 80 to 443
    - Bonus: Learn what idempotency means
    - Bonus: Instead of making one big playbook, try to use [roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
1. Create the static site locally on your PC
     - You'll have to choose a static site generator ([here](https://jamstack.org/generators/) is a good list of options)
     - I like [Hugo](https://github.com/gohugoio/hugo), but the choice is yours (consider things like speed, available themes, the language the templates are written in, plugins, if you're migrating from another data source, etc...)
     - Make sure the site builds locally on your PC and you can visit it on `localhost`
     - This code should be checked into Git on GitHub
1. Deploy the site to your VPS using Setup GitHub Actions
    - You need to automate deploying your static site's rendered code from GitHub to your VPS
    - This automation needs to happen on some sort of trigger (e.g., on each commit to Git, on a schedule, on a tag, etc...)
    - Bonus: Use GitHub Actions to lint your Terraform code with [tflint](https://github.com/terraform-linters/tflint) and Ansible code with [ansible-lint](https://github.com/ansible/ansible-lint)
    - Bonus: Setup a free [GitHub Pages](https://pages.github.com/) domain at `yourname.github.io` and push a dev/test version of your site to there

# Cost

In my setup, I'm spending $66/year on my site and the surrounding infrastructure.

| Product              | Cost (per year)     |
|----------------------|---------------------|
| Domain name (Hover)  | $12                 |
| DNS (Route53)        | $6                  |
| VPS (DigitalOcean)   | $48                 |

However, there are some cost-cutting measures that are possible:
- DNS: Use a free provider like Cloudflare or NS1
- Hosting: Use a static-site host like [GitHub Pages](https://pages.github.com/) or [Netlify](https://www.netlify.com/pricing/)

Keep in mind that moving to a dedicated static-site host would remove the VPS from the setup above, and thus remove all reason to use Ansible in your setup (less to manage, but also less to learn).

# Conclusion

The setup above is more than enough to put on a resume, but it definitely lacks a few things:
- Database
- API
- Load balancing
- Containers/K8s

However, in my mind, those things are not great for a beginner project, but for something more intermediate-level (for that kind of project, check out the [The Cloud Resume Challenge](https://cloudresumechallenge.dev/) or [roadmap.sh](https://roadmap.sh/devops)).

\-Logan
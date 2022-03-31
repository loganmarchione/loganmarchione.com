---
title: "The 'best' way to run DokuWiki in Docker"
date: "2022-03-31"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_dokuwiki.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I've been trying to get my homelab applications moved from running on VM/LXC to Docker. There's nothing wrong with VMs or LXC containers, but I'm trying to manage fewer servers and "snowflakes" (even though I do my installs with Ansible).

The application that started my homelab journey was [DokuWiki](https://www.dokuwiki.org/). It's a self-hosted wiki, written in PHP, that requires no database. You write in a [Markdown-like syntax](https://www.dokuwiki.org/wiki:syntax) (not Markdown) and your data is stored in plain TXT files on the filesystem. DokuWiki, however, is not 100% straightforward to Dockerize.

## The DokuWiki in Docker problem

DokuWiki is very simple: a bunch of PHP files sit in a directory to be served by a PHP-capable webserver (e.g., Nginx or Apache). It's so simple (and old, from 2004) that you'd think it would be easy to run in Docker in 2022, right?

If you search on Docker Hub, there are almost [400 DokuWiki images](https://hub.docker.com/search?q=dokuwiki&type=image), none of which are the official image (because there isn't one). An official image was requested via a GitHub [issue](https://github.com/splitbrain/dokuwiki/issues/1896) back in 2017. However, because DokuWiki is so simple and pre-dates Docker, it wasn't really designed to be run inside a container (see [this](https://github.com/splitbrain/dokuwiki/issues/791) for more details).

As [Andreas Gohr](https://www.splitbrain.org/) (the creator of DokuWiki) posted in his [Patreon](https://www.patreon.com/posts/running-dokuwiki-42961375), the best way to install DokuWiki in Docker is to setup a generic PHP+web server container with a volume, then install DokuWiki into that volume. This is approximately 0.1% more work than pulling a pre-baked, unofficial Docker image from Docker Hub, and it's what the creator of DokuWiki himself recommends.

## Other wikis

Before anyone asks, yes, I know there are other wikis out there, and they almost certainly have more features than DokuWiki, and are probably nicer looking. However, they all require a database to store content, whereas DokuWiki stores everything in plaintext files.

- [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki) (The wiki that Wikipedia uses)
- [Wiki.js](https://js.wiki/)
- [Bookstack](https://www.bookstackapp.com/)
- [Outline](https://www.getoutline.com/)

# Installation

We're basically going to run a PHP container with a webserver, then exec into the container and install DokuWiki.

## Docker container

This simple Docker Compose file will get you up and running. It's nothing more than the [official PHP image](https://hub.docker.com/_/php) with Apache.

```
version: '3'
services:
  dokuwiki:
    container_name: dokuwiki
    image: php:7-apache-bullseye
    restart: unless-stopped
    networks:
      - dokuwiki
    ports:
      - '8888:80'
    volumes:
      - 'dokuwiki_config:/var/www/html'

networks:
  dokuwiki:

volumes:
  dokuwiki_config:
    driver: local
```

Once this is completed, visit `http://your_docker_server_IP:8888` and you should see this error (since there is nothing for Apache to serve).

{{< img src="20220331_001.png" alt="apache error" >}}

## DokuWiki install

First, [exec](https://docs.docker.com/engine/reference/commandline/exec/) into the container.

```
docker exec -it dokuwiki /bin/bash
```

Next, download DokuWiki.
```
cd /var/www/html
curl --remote-name https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar -xzvf dokuwiki-stable.tgz --strip-components=1
rm dokuwiki-stable.tgz
chown -R www-data:www-data /var/www/
```

Now, visit `http://your_docker_server_IP:8888/install.php` and you will see the DokuWiki install page. Done!

{{< img src="20220331_002.png" alt="dokuwiki installer" >}}

# Conclusion

The only caveats I can think of running this way are:

1. Upgrades - Normally you [upgrade](https://www.dokuwiki.org/install:upgrade) DokuWiki by downloading a newer `tgz` file and overwriting your current setup. However, this kind of a pain in Docker. It's much easier to install the [Upgrade plugin](https://www.dokuwiki.org/plugin:upgrade) and use that from the web interface.
1. Plugins - I don't have a ton of plugins (I don't use LDAP, databases, galleries, etc..). Because of this, the default PHP modules are more than enough for me. However, if you needed more, PHP offers [instructions](https://github.com/docker-library/docs/blob/master/php/README.md#how-to-install-more-php-extensions) on how to build your own PHP image.

\-Logan
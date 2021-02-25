---
title: "Linting Ansible playbooks using Drone"
date: "2020-04-20"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
cover:
    image: "/assets/featured/featured_ansible_drone.svg"
    alt: "featured image"
    relative: false
---

# Introduction

In my [last post](/2020/04/how-and-why-you-should-lint-your-ansible-playbooks/), I went over linting Ansible playbooks manually. In this post, I'm going to give you a brief introduction on how to lint playbooks automatically, using [Drone](https://drone.io/).

I was inspired to post this after watching Jeff Geerling's ([geerlingguy](https://github.com/geerlingguy) on Github) _Ansible 101_ [YouTube series](https://www.youtube.com/watch?v=SLW4LX7lbvE&list=PL2_OBreMn7FplshFCWYlaN2uS8et9RjNG). In it, he mentions using automated testing/linting of his playbooks. If you haven't seen it, give it a [watch](https://www.youtube.com/watch?v=SLW4LX7lbvE&list=PL2_OBreMn7FplshFCWYlaN2uS8et9RjNG).

As with before, I'm not a developer or professional DevOps person. I know _just enough_ to be dangerous, but this should be enough to get you going.

## What is Drone?

[Drone](https://drone.io/) is continuous integration and continuous delivery/deployment (often written as CI/CD) software. It allows you to take automated actions when code is pushed to a repository (e.g., test the code, push to a Docker registry, push to production, alert if failed, etc...).

There are many popular CI/CD solutions, including, but not limited to:

- [Jenkins](https://jenkins.io/)
- [GitLab CI/CD](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)
- [Concourse](https://concourse-ci.org/)
- [CircleCI](https://circleci.com/)
- [TeamCity](https://www.jetbrains.com/teamcity/)
- [Bamboo](https://www.atlassian.com/software/bamboo)
- [Travis CI](https://travis-ci.com/)

However, most of these solutions were overkill for my workload. Considering I'm a noob at this, I was looking for something lightweight, minimal, and most importantly, easy to setup. [Drone](https://drone.io/) fit my requirements perfectly.

## Why automate linting?

As I said in my last post, I lint my playbooks because I’d like to have some confidence that updates to my playbooks will work, without having to run them after every update. However, I currently have to manually lint any playbooks after updates are made.

Since my Ansible playbooks are all checked into git, I can setup this workflow.

- My self-hosted [Gitea](https://gitea.io) instance notifies Drone of changes via a webhook
- Drone spins up a Docker container of a pre-built Ubuntu image with Ansible installed
- Drone runs a command to lint my playbooks using that container's Ansible installation

# Installation

## Version Control System

You need some sort of [version control system](https://en.wikipedia.org/wiki/Version_control) (VCS) that supports webhooks. I'm using [Gitea](https://gitea.io) at home, running on Docker. Drone supports providers other than Gitea, including GitHub, GitLab, Gogs, and Bitbucket.

Note - Drone needs to be notified by your VCS via a webhook. For me, both Gitea and Drone are self-hosted at home. If you're using GitHub (or other public VCS), you need to either:

1. expose your self-hosted Drone instance to the world (e.g., put your Drone instance in your network's DMZ)
2. host Drone yourself in the cloud (e.g., on a VPS)
3. use [the hosted instance of Drone](https://cloud.drone.io/)

## OAuth key

Once you select a VCS provider, you'll need to create an OAuth key. This will allow you to login to Drone using your VCS provider of choice.

The instructions will be different for each provider, so I'll just link the top-level installation page [here](https://docs.drone.io/server/overview/).

## Drone

Everything in Drone is Docker-first. As such, Drone is designed to be installed in a Docker container. Below is a sanitized version of my _docker-compose.yml_ file to run Drone and the Docker runner (the runner is the application that actually executes the CI/CD pipeline steps). By Default, Drone uses a SQLite database, but also [supports](https://docs.drone.io/server/storage/database/) PostgreSQL and MySQL as well. I didn't post my PostgreSQL configuration here to keep things simple.

```
version: '3'
services:
  drone:
    container_name: drone
    image: drone/drone:1
    restart: unless-stopped
    environment:
      - DRONE_SERVER_HOST=drone.internal.mydomain.com
      - DRONE_SERVER_PROTO=https
      - DRONE_GITEA_SERVER=https://git.internal.mydomain.com
      - DRONE_GITEA_CLIENT_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      - DRONE_GITEA_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	                              
      - DRONE_RPC_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    networks:
      - drone
    ports:
      - '80:80'
    volumes:
      - 'drone_data:/data'
  drone-runner-docker:
    container_name: drone-runner-docker
    image: drone/drone-runner-docker:1
    restart: unless-stopped
    environment:
      - DRONE_RPC_HOST=drone.internal.mydomain.com
      - DRONE_RPC_PROTO=https
      - DRONE_RUNNER_NAME=runner1
      - DRONE_UI_DISABLE=true
      - DRONE_RPC_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    networks:
      - drone
    ports:
      - '3000:3000'
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'

networks:
  drone:

volumes:
  drone_data:
    driver: local
```

Once you startup your containers and try to login to Drone (my instance is behind a reverse proxy), you should be greeted with your VCS provider's login page. Once you login, you should be able to click _Sync_ to sync your repositories to Drone.

{{< img src="20200420_001.png" alt="drone screenshot" >}}

I'm going to assume you already have an _ansible_ repository, so click on it, and click _Activate_.

{{< img src="20200420_002.png" alt="drone screenshot" >}}

# Configuration

Next, we need to create a configuration file for Drone. This file is usually called _.drone.yml_, and it's right in the root of your git repository.

This configuration file needs to point to a Docker image that already has `ansible` and `ansible-lint` pre-installed. Luckily, Jeff Geerling already hosts an image on [Docker Hub](https://hub.docker.com/r/geerlingguy/docker-ubuntu1804-ansible) for this exact purpose (specifically, we need the image with the _testing_ tag).

```
---
kind: pipeline
type: docker
name: default

steps:
  - name: test
    image: geerlingguy/docker-ubuntu1804-ansible:testing
    commands:
      - "find . -maxdepth 1 -name '*.yml' | sort | grep -v '.drone.yml' | xargs ansible-playbook --syntax-check --list-tasks"
      - "find . -maxdepth 1 -name '*.yml' | sort | grep -v '.drone.yml' | xargs ansible-lint"
```

The configuration file above basically says:

- Use a Docker pipeline (so all these steps happen in Docker containers that go away after the run is completed)
- Run a step named _test_
- Download an image called _geerlingguy/docker-ubuntu1804-ansible:testing_
- Run the two commands for syntax checking and linting inside that container
    - If there are any errors (non-zero exit codes), throw an error
- Based on the output (pass/fail), you'll see a symbol in your VCS provider's web interface (usually a ☑ or ❌ symbol)

Now, every time I commit anything to my Ansible repository, it is automatically checked for syntax and linted. The only remaining step (which I have yet to setup) is alerting. Drone has plugins to notify you via [email](http://plugins.drone.io/drillster/drone-email/), [Slack](http://plugins.drone.io/drone-plugins/drone-slack/), [Telegram](http://plugins.drone.io/appleboy/drone-telegram/), etc...

# Bonus: Run you own Ansible test images

Since I already run a Docker registry at home and have a Gitea server, I build my own Ubuntu images to test against. In fact, the image for Ubuntu is built with Drone as well!

```
FROM ubuntu:bionic

ARG BUILD_DATE

LABEL \
  maintainer="Logan Marchione" \
  org.opencontainers.image.authors="Logan Marchione" \
  org.opencontainers.image.title="docker-ubuntu1804-ansible" \
  org.opencontainers.image.description="Installs Ansible for testing playbooks" \
  org.opencontainers.image.created=$BUILD_DATE

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    python3-pip \
    python3-setuptools \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install ansible ansible-lint
```

In my case, I'm able to reference my local internal registry instead of Docker Hub. I can also test against more than one version of Linux, or in my case, Ubuntu.

```
---
kind: pipeline
type: docker
name: default

steps:
  - name: test-ubuntu1804
    image: registry.internal.mydomain.com/loganmarchione/docker-ansible-ubuntu1804:1.0
    commands: 
      - "find . -maxdepth 1 -name '*.yml' | sort | grep -v '.drone.yml' | xargs ansible-playbook --syntax-check --list-tasks"
      - "find . -maxdepth 1 -name '*.yml' | sort | grep -v '.drone.yml' | xargs ansible-lint"

  - name: test-ubuntu2004
    image: registry.internal.mydomain.com/loganmarchione/docker-ansible-ubuntu2004:1.0
    commands: 
      - "find . -maxdepth 1 -name '*.yml' | sort | grep -v '.drone.yml' | xargs ansible-playbook --syntax-check --list-tasks"
      - "find . -maxdepth 1 -name '*.yml' | sort | grep -v '.drone.yml' | xargs ansible-lint"
```

# Conclusion

I hope this was a good introduction to Ansible linting and Drone. As a mentioned, I'm not an expert, so if you spot anything wrong or see anything I could improve, I'm open to criticism.

Thanks for reading!

\-Logan
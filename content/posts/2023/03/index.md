---
title: "Continuous Delivery with Docker Compose"
date: "2023-03-26"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_steam_deck.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I'm slowly [transitioning](/2022/12/k3s-cluster-updates/) all of my applications from a Docker Compose-based setup to running on Kubernetes (specifically, [K3s](https://k3s.io/)). Part of the reason I love Kubernetes is the tooling around it.

I (try to) practice GitOps, so all of my Kubernetes configuration is in a [public GitHub repo](https://github.com/loganmarchione/k8s_homelab). I'm happily using [GitHub Actions](https://github.com/features/actions) and [Renovatebot](https://github.com/renovatebot/renovate) for Continuous Integration (CI). For example, each PR has tests run on it, then if specific conditions are met, the PR is merged. For Continuous Delivery (CD) I'm using [Flux](https://fluxcd.io/flux/), which runs in my K3s cluster and constantly tries to synchronize the current state to the "golden" state of the cluster on GitHub. This way, every change made to the `master` branch will be rolled out via Flux automatically.

However, I still have some apps running on Docker Compose, and they might never make the transition to K3s (for one reason or another). I can still use tools for CI, but there are no real tools for CD when it comes to Docker Compose. When I merge PRs into `master`, I need to manually SSH into my Docker server, run `git pull`, then run `docker compose up -d` on each updated compose file. This is a common complaint when searching online, and I found a whole article [here](https://www.augmentedmind.de/2022/03/20/continuous-deployment-with-docker/) about different solutions.

This post is my attempt at CD for Docker Compose.

# Pull vs push

As mentioned in [this](https://www.augmentedmind.de/2022/03/20/continuous-deployment-with-docker/) article, there are generally two ways to tackle this problem:

- Pull-based approach
  - An agent runs as a container and constantly tries to synchronize the current state to the "golden" state in git
  - This is how Argo and Flux work
- Push-based approach 
  - On each change to master, some process runs via CI pipeline that pushes the changes to the server
  - This is what I'm doing

## What about Harbormaster or Watchtower?

Both [Harbormaster](https://gitlab.com/stavros/harbormaster) and [Watchtower](https://github.com/containrrr/watchtower) already do basically what I need. However, there were a couple reasons I didn't want to use them:

- I would have to setup/maintain another application
- Both of these applications need access to the Docker socket (which I don't like to give out)
- How would I be notified of a failure to deploy new applications? (i.e., who watches the watchers?)
- What kind of logs would these tools keep? How long would they keep them for?
- Why use a preexisting solution when I can spend days over-engineering something? :man_shrugging:

# Push-based approach

My K3s stack runs at home, but the code is public, so I'm using GitHub as my git repository and GitHub Actions as my CI service.

My Docker Compose stack also runs at home, but the Compose files aren't public (yet), so they're hosted on my [Gitea](https://gitea.io/) instance where my CI platform is [Drone](https://www.drone.io/).

The basic idea is this:

**THIS IS WHERE THE CI STARTS**

1. A PR is opened on Gitea (e.g., by Renovatebot to bump a Docker tag from `2.42.0` to `2.43.0`)
2. Drone runs a pipeline to automatically check specific things (e.g, linting, compatability, etc...)
3. Assuming the pipeline passed:
  - `major` and `minor` changes are manually merged by me in Gitea's web interface
  - `patch` changes are automatically merged

**THIS IS WHERE THE CD STARTS**

4. When `master` is updated, another Drone pipeline runs that SSHs from Drone into my Docker host and runs a shell script
5. That shell script pulls the latest compose files from git (e.g., `git pull`) then runs a `for` loop to run `docker compose up -d` on each compose file
  - The shell script logs to standard out, which means that logs are stored in Drone
  - If the exit code isn't `0`, the Drone pipeline fails, which emails me

# Details

Steps 1-3 above were already in place, but steps 4-5 were the new steps I needed.

First, I had to create a `drone` user on my Docker host, give it [permissions](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) to run docker commands, then setup a SSH keypair. The public key would live on the server, while the private key would live in Drone as a [secret](https://docs.drone.io/secret/).

Next, I needed to create a Drone pipeline to SSH into my Docker host. Drone already has a [SSH runner](https://github.com/drone-runners/drone-runner-ssh), but that's another thing to install (in addition to the Docker runner), so I figured I could just use a small Docker container (e.g., Alpine) as my SSH client. In the pipeline below, I am doing the following on each `push` to `master`:

- running Alpine
- installing SSH
- echoing the SSH private key from a Drone secret into a file
- SSHing from Alpine into my Docker host, then running a shell script


```
---
kind: pipeline
type: docker
name: Deploy

trigger:
  branch:
    - master
  event:
    - push

steps:
  - name: Deploy
    image: alpine:3.17
    environment:
      drone_ssh_priv_key:
        from_secret: drone_ssh_priv_key
    commands:
      - apk add --no-cache --update openssh-client
      - mkdir -p ~/.ssh
      - echo "$drone_ssh_priv_key" > ~/.ssh/deploy_key
      - ssh-keyscan docker.internal.mydomain.com > ~/.ssh/known_hosts
      - chmod -R 700 ~/.ssh
      - chmod 600 ~/.ssh/deploy_key
      - ssh -i ~/.ssh/deploy_key drone@docker.internal.mydomain.com -- "/path/to/compose_files/script.sh"

  - name: notify on failure
    image: drillster/drone-email
    settings:
      host: smtp.internal.mydomain.com
      port: 25
      from: donotreply@my_email.com
      from.name: "[Alert from Drone CI/CD]"
    when:
      status:
        - failure
```

Then, the actual contents of `script.sh` from the example above. It basically does the following:

- change directory to the git repo containing all of the Docker Compose files
- run `git pull`
- for each `docker-compose.yml` file, run `docker compose pull` and then `docker compose up -d`

```
#!/bin/bash

# Be safe out there
set -e
set -u
set -o pipefail
IFS=$'\n\t'

# Set generic variables
hostname=$(uname -n)
datetime=$(date +%Y%m%d_%H%M)
dir="/path/to/compose_files"

# Update from git repo
printf "STATE: Updating the git repo...\n"
cd "$dir"
git pull

# Pull images
for D in "$dir"/*/docker-compose.yml
do
  printf "STATE: Pulling images for: $D\n"
  docker compose -f "$D" pull
done

# Redeploy
for D in "$dir"/*/docker-compose.yml
do
  printf "STATE: Redploying the compose file for: $D\n"
  docker compose -f "$D" up -d
done

exit 0
```

The only catch with this script is to be sure that the user running it (e.g., `drone`) has permissions to execute it.

# Conclusion

I've been using this setup for a week or so and haven't had any issues (so far). It's definitely a little hacked together, but it requires no additional tools that I'm not already using.

\-Logan
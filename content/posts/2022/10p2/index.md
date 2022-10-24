---
title: "How to run Renovate on a self-hosted Gitea and Drone instance"
date: "2022-10-24"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_renovate.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I recently started using Mend's [Renovate](https://github.com/renovatebot/renovate) bot to keep my dependencies up-to-date on my GitHub projects. GitHub already has tool for this called [Dependabot](https://github.com/dependabot), but it only works with GitHub. Renovate is much more flexible, and it's also open-source, so it can run on other Git platforms, like my self-hosted Gitea and Drone instance at home.

However, self-hosting Renovate is more difficult because the hosted version takes care of a lot of the "magic" for you, so it "just works". These are my notes on getting Renovate working with a self-hosted instance of Gitea and Drone.

# Self-hosting Renovate

As a user, there are [two ways of running Renovate](https://docs.renovatebot.com/getting-started/running/):
1. someone else hosts Renovate and you install it for the repositories you choose (e.g., as a [GitHub app](https://github.com/apps/renovate))
    - you extend off the global configuration provided my Renovate
    - you add a per-repository configuration file (called `renovate.json`)
    - Renovate runs continuously in the background
1. you host Renovate
    - you provide some infrastructure for Renovate to run on (e.g., by running a Docker image, using a GitHub Action, running a npm package, etc...)
    - you need to provide a global configuration file (called `config.js`)
    - you add a per-repository configuration file (called `renovate.json`)
    - Renovate needs to run on a schedule (e.g., on a cronjob)

In my case, I'm running Gitea and Drone at home, so I'm going to self-host Renovate and run a Docker image as a Drone step.

It's important to note that there are two configuration files, and it's recommended to keep as much configuration as possible in the per-repository files, so that end users have the most flexibility and transparency.
- [global configuration](https://docs.renovatebot.com/self-hosted-configuration/) (called `config.js`)
- [per-repository configuration](https://docs.renovatebot.com/configuration-options/) (called `renovate.json`)

# Setup

## GitHub steps

1. Create a GitHub [personal access token](https://github.com/settings/tokens/new) (PAT)
    - You need a GitHub PAT for [getting release notes](https://docs.renovatebot.com/getting-started/running/#githubcom-token-for-release-notes) from GitHub.com to increase the hourly API limit
    - It can be for any account (e.g., your personal account)
    - It needs the `public_repo` permission, nothing else
    - Save this token somewhere

## Gitea steps

### Renovate user

1. Create `renovate` user
    - Login as the Gitea admin user and create a user for Renovate, called `renovate`

1. Create a personal access token (PAT) for the `renovate` user
    - Logout of the admin user
    - Login as the `renovate` user, go to `Settings-->Applications-->Manage Access Tokens` and click on `Generate Token`
    - Save this token somewhere

1. Create repository for `renovate`
    - Create a new repository under the `renovate` user called `renovate-config`
    - Create a file called `config.js` (this contains [global settings](https://docs.renovatebot.com/self-hosted-configuration/) for your instance of Renovate)
    - Below is my `config.js` file (you'll have to update the `endpoint`, `gitAuthor`, and the `repositories` section with the list of all Gitea repositories you want Renovate to run against)
    ```
    module.exports = {
      platform: 'gitea',
      endpoint: 'https://git.internal.yourdomain.com/api/v1/',
      gitAuthor: 'Renovate Bot <renovate@yourdomain.com>',
      username: 'renovate',
      autodiscover: true,
      onboardingConfig: {
        $schema: 'https://docs.renovatebot.com/renovate-schema.json',
        extends: ['config:base']
      },
      optimizeForDisabled: true,
      persistRepoData: true,
      repositories: [
        "logan/docker"
      ]
    }
    ```
    - Create a file called `.drone.yml` (this is the file that will run on a schedule to actually run Renovate)
    - Below is my `.drone.yml` file
    ```
    ---
    kind: pipeline
    type: docker
    name: renovate

    trigger:
      event:
        - cron
        - push
        - custom

    environment:
      LOG_LEVEL: debug

    steps:
      - name: renovate - validate config
        image: renovate/renovate:33.2.0
        # https://github.com/renovatebot/renovate/discussions/15049
        commands:
          - unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
          - renovate-config-validator

      - name: renovate
        image: renovate/renovate:33.2.0
        # https://github.com/renovatebot/renovate/discussions/15049
        commands:
          - unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
          - renovate

        environment:
          RENOVATE_TOKEN:
            from_secret: RENOVATE_TOKEN
          GITHUB_COM_TOKEN:
            from_secret: GITHUB_COM_TOKEN
    ```

## Drone steps

1. Login to Drone as the `renovate` user (you'll have to authorize the application)

1. Go to `renovate-config-->Settings-->Secrets` and click on `New Secret`
    - Add a secret called `GITHUB_COM_TOKEN` with the value of the GitHub PAT
    - Add a secret called `RENOVATE_TOKEN` with the value of the `renovate` user's Gitea PAT

1. Go to `renovate-config-->Settings-->Cron Jobs` and click on `New Cron Job`
    - Add an `hourly` cron job using `@hourly`
    - This is how to specify how often to run Renovate

## More Gitea steps

Renovate comes with a built-in [Docker Compose manager](https://docs.renovatebot.com/modules/manager/docker-compose/), so it can automatically find any compose files using the regex below.

```
(^|/)(?:docker-)?compose[^/]*\.ya?ml$
```

Now we need a target repository we want to run Renovate against. This is the example repository I'm using, called `logan/docker`. It contains the following:
- a directory for docker apps that I don't use anymore (`apps_old`)
- a directory for docker apps that I currently use (`docker_app_host`)
- a `.drone.yml` file (used for linting my `docker-compose.yml` files)
- a `renovate.json` file

```
.
├── apps_old
│   ├── app1
│   │   └── docker-compose.yml
│   ├── app2
│   │   └── docker-compose.yml
│   └── app3
│       └── docker-compose.yml
├── docker_app_host
│   ├── app1
│   │   └── docker-compose.yml
│   ├── app2
│   │   └── docker-compose.yml
│   └── app3
│       └── docker-compose.yml
├── .drone.yml
└── renovate.json
```

Just need to change a few settings:

1. Add `renovate` collaborator to repository
    - In the target repository, go to `Settings-->Collaborators` and add the `renovate` user (this will allow `renovate` to open pull requests)

1. Add `renovate.json`
    - Upon first run, Renovate will open a pull request with a basic `renovate.json` file, but I've provided an example below of mine (notice how I'm ignoring the path `apps_old`, you can leave that off if you don't need it)
    ```
    {
      "$schema": "https://docs.renovatebot.com/renovate-schema.json",
      "extends": [
        "config:base"
      ],
      "dependencyDashboard": true,
      "dependencyDashboardTitle": "Renovate Dashboard",
      "labels": ["renovatebot"],
      "docker-compose": {
        "ignorePaths": ["apps_old"]
      },
      "hostRules": [
        {
          "matchHost": "docker.io",
          "concurrentRequestLimit": 2
        }
      ]
    }
    ```

## First run

Up until now, Renovate has probably been running as you've been making changes, but it has probably failed a few times due to missing keys or permissions.

Login to Drone as the `renovate` user and click on `New Build` in the top-right, and you should see Renovate run and (hopefully) succeed.

If not, the `.drone.yml` file I've provided above has `LOG_LEVEL: debug` set, which means you should be able to search in Drone's run logs to find errors.

With the cronjob setup, Renovate will run on your schedule and open pull requests as it finds outdated dependencies.

# Caveats of self-hosting

## Continuous runs

As I mentioned at the beginning, when running Renovate as a GitHub app, it runs continuously in the background. Any time you make a change, Renovate sees it and runs automatically. However, when you self-host Renovate, you need to run Renovate on a schedule (which is why we setup a Drone cronjob).

Some features of Renovate, like the [check boxes on the Dependency Dashboard](https://docs.renovatebot.com/getting-started/use-cases/#on-demand-updates-via-dependency-dashboard), only apply when Renovate runs. For example, if you're using the hosted Renovate GitHub app and click a checkbox on the Dependency Dashboard, Renovate will pickup that change almost immediately. However, if you're self-hosting Renovate, the checkbox won't do anything until Renovate runs (whether you run it manually in Drone or it runs via cron).

## Rate-limiting

When self-hosting, you don't want to run Renovate too often, as you'll probably hit a rate limit from some service (GitHub, Docker Hub, etc...). In my case, I hit the Docker Hub rate limit pretty quickly by running builds every hour.

In November 2020, Docker introduced [rate limiting](https://www.docker.com/increase-rate-limits/) to Docker Hub. It limits (by IP address) anonymous pulls to 100 per six hours, and authenticated pulls to 200 per six hours. I had 20+ `docker-compose.yml` files (each with multiple container images) in my initial Renovate pull request, and I kept hitting the error below.

```
"response": {
  "statusCode": 429,
  "statusMessage": "Too Many Requests",
  "body": "{\n  \"errors\": [\n    {\n      \"code\": \"TOOMANYREQUESTS\",\n      \"message\": \"You have reached your pull rate limit. You may increase the limit by authenticating and upgrading: https://www.docker.com/increase-rate-limit\"\n    }\n  ]\n}\n",
  "headers": {
    "cache-control": "no-cache",
    "content-type": "application/json",
    "connection": "close"
  },
  "httpVersion": "1.1",
  "retryCount": 2
}
```

If you hit the Docker Hub rate limit, these are your options:
- Try to use some images from an alternative container registry (e.g., GHCR or Quay.io)
- Create a Docker account and [login](https://docs.renovatebot.com/docker/#dockerhub) (example `config.js` below)
  - A free Docker account will get you 200 pulls per six hours
  - A paid Docker account at $5/month will get you 5000 pulls per day
```
module.exports = {
  hostRules: [
    {
      hostType: 'docker',
      username: '<your-username>',
      password: process.env.DOCKER_HUB_PASSWORD,
    },
  ],
};
```
- Run your Drone cronjob less-often or create a [custom cronjob](https://docs.drone.io/cron/)
- Setup a [proxy registry](https://container-registry.com/posts/overcome-docker-hub-rate-limit/#3-proxy-to-docker-hub) and pull your images from there
- Add a [concurrent request limit](https://docs.renovatebot.com/configuration-options/#concurrentrequestlimit) to `docker.io` (example `renovate.json` snippet below)
```
  "hostRules": [
    {
      "matchHost": "docker.io",
      "concurrentRequestLimit": 2
    }
  ]
```

## Docker image size

The `renovate/renovate` [Docker image](https://docs.renovatebot.com/getting-started/running/#docker-image) is about 1.5GB in size. If you don't pin to a specific tag (like `33.2.0`), you'll waste a lot of space downloading the `latest` tag over and over again.

There is a `slim` tag, but it only contains Node.js, so if you need anything else (Docker, Python, Java, etc...), it won't work.

## Use Renovate to update Renovate

Obviously, since we pinned the Renovate image to `33.2.0`, we'll need to also put a `renovate.json` file in our `renovate/renovate-config` Gitea repository to use Renovate to keep Renovate updated.

![meme](/assets/memes/inception_we_need_to_go_deeper.jpg)

# Conclusion

I've been using Renovate for about a week now and really like it. It's obviously a much smoother experience running on GitHub than self-hosted, but it's enough really make a difference in my workflow already.

Also, I highly recommend checking out these article for more tips on getting Renovate setup:

- Jerry Ng: [12 Tips to Self-host Renovate Bot](https://jerrynsh.com/12-tips-to-self-host-renovate-bot/)
- Marius Shekow: [Renovate bot cheat sheet – the 11 most useful customizations](https://www.augmentedmind.de/2021/07/25/renovate-bot-cheat-sheet/)

\-Logan
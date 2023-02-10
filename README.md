# loganmarchione.com

[![CI/CD (loganmarchione.com)](https://github.com/loganmarchione/loganmarchione.com/actions/workflows/production.yml/badge.svg)](https://github.com/loganmarchione/loganmarchione.com/actions/workflows/production.yml)
[![](https://img.shields.io/website?down_color=red&down_message=offline&label=loganmarchione.com&up_color=green&up_message=online&url=https%3A%2F%2Floganmarchione.com)](https://loganmarchione.com)
[![](https://img.shields.io/website?down_color=red&down_message=offline&label=loganmarchione.github.io&up_color=green&up_message=online&url=https%3A%2F%2Floganmarchione.github.io)](https://loganmarchione.github.io)

## Overview

This repo contains the source for https://loganmarchione.com, built via [Hugo](https://gohugo.io/).

This repo also builds https://loganmarchione.github.io on every PR and update to every PR.

## Usage

```
# get a copy of the code
git clone https://github.com/loganmarchione/loganmarchione.com.git
cd loganmarchione.com

# update hugo modules (optional)
hugo mod get
go mod tidy

# make changes to the site (optional)

# test changes locally
hugo server -DEF --ignoreCache

# test in browser http://localhost:1313

# add, commit, push to kick off GitHub Actions
git add .
git commit -m "Update some stuff"
git push
```

## GitHub Actions

Below is a visual representation of the GitHub Actions workflows.

```mermaid
  graph TD
    A((Start)) --> B[Create branch] & C[Commit to master]
    B --> D[Commits to branch]
    C --> AA["Deploy to production site (loganmarchione.com)"] & BB["Deploy to development site (loganmarchione.github.io)"]
    D --> E[Pull request to master]
    G --> C
    E --> BB
    H{Dev site looks good?} -- No --> D
    BB --> H
    H -- Yes --> G[Merge PR]
```

# loganmarchione.com

![CI/CD](https://github.com/loganmarchione/loganmarchione.com/actions/workflows/main.yml/badge.svg)

## Overview

This repo contains the source for https://loganmarchione.com, built via [Hugo](https://gohugo.io/).

## Usage

```
# get a copy of the code
git clone https://github.com/loganmarchione/loganmarchione.com.git
cd loganmarchione.com
git submodule update --init --recursive

# make changes to the site

# test changes locally
hugo server -D --ignoreCache

# test in browser http://localhost:1313

# add, commit, push to kick off GitHub Actions
git add .
git commit -m "Update some stuff"
git push
```

# loganmarchione.com

[![CI/CD (loganmarchione.com)](https://github.com/loganmarchione/loganmarchione.com/actions/workflows/main.yml/badge.svg)](https://github.com/loganmarchione/loganmarchione.com/actions/workflows/main.yml)
[![](https://img.shields.io/website?down_color=red&down_message=offline&label=loganmarchione.com&up_color=green&up_message=online&url=https%3A%2F%2Floganmarchione.com)](https://loganmarchione.com)
[![](https://img.shields.io/website?down_color=red&down_message=offline&label=loganmarchione.github.io&up_color=green&up_message=online&url=https%3A%2F%2Floganmarchione.github.io)](https://loganmarchione.github.io)



## Overview

This repo contains the source for https://loganmarchione.com, built via [Hugo](https://gohugo.io/).

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

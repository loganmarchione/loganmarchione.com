FROM debian:12-slim

ARG BUILD_DATE
ENV HUGO_VERSION 0.124.1

LABEL \
  maintainer="Logan Marchione <logan@loganmarchione.com>" \
  org.opencontainers.image.authors="Logan Marchione <logan@loganmarchione.com>" \
  org.opencontainers.image.title="loganmarchione.com" \
  org.opencontainers.image.description="Hugo build environment for loganmarchione.com" \
  org.opencontainers.image.created=$BUILD_DATE

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install --no-install-recommends \
    apt-transport-https \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    golang \
    jq \
    rsync \
    software-properties-common \
    unzip \
    vim \
    wget \
    zip && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb && \
    dpkg -i hugo_extended_${HUGO_VERSION}_linux-amd64.deb && \
    rm hugo_extended_${HUGO_VERSION}_linux-amd64.deb

EXPOSE 1313

WORKDIR /src
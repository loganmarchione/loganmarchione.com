---
title: "Kubernetes GUIs"
date: "2022-03-29"
author: "Logan Marchione"
categories:
  - "oc"
  - "cloud-internet"
  - "linux"
  - "kubernetes"
cover:
    image: "/assets/featured/featured_k8s.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_k3s %}}

# Introduction

In my [last post](/2022/03/k3s-single-node-cluster-for-noobs/), I setup a [K3s](https://k3s.io/) single-node cluster and an example application. While everything was done through the command-line, as a noob, it's nice to have a [graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface) (GUI) of some kind. I'm not a fan of [ClickOps](https://www.lastweekinaws.com/blog/clickops/), but it's convenient to have a GUI to be able to quickly view status, instead of hunting for the right `kubectl` command.

:warning: WARNING :warning:

- I am not a Kubernetes expert!
- This is solely for my own learning. If you get something useful out of my ramblings, that's great, but it's not my primary goal.
- Nothing I setup here should be considered production-ready or secure.

# Comparison

There are a ton of k8s GUIs, but I'm going to be covering what I've found to be the easiest to setup and use.

| Product               | Language       | Type | Source model  | Comments        |
| --------------------- | -------------- | ---- | ------------- | --------------- |
| Kubernetes Dashboard  | Go/Typescript  | GUI  | Open source   | Browser-based   |
| Lens                  | Typescript     | GUI  | Open source   |                 |
| Octant                | Go/Typescript  | GUI  | Open source   | Browser-based   |
| Infra App             | ???            | GUI  | Closed source |                 |
| Kubenav               | Go/Typescript  | GUI  | Open source   | Has mobile apps |
| K9s                   | Go             | TUI  | Open source   |                 |

## Kubernetes Dashboard

Because K3s _is_ upstream k8s (with some bits stripped out), we can setup the [official k8s web dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

First, we need to apply the dashboard manifest to the cluster by running the command below on our personal machine (again, kubectl on our personal machine connects to the cluster).

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.1/aio/deploy/recommended.yaml
```

Next, we need to create a user and role to login to the dashboard. I recommend storing all of your manifests in a directory for easy management and version control. You can copy/paste the commands below to create the directory and the manifest.

```
mkdir -p ~/k8s/dashboard
cat << EOF > ~/k8s/dashboard/admin.yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

Now, apply the manifest and get your token.

```
kubectl apply -f ~/k8s/dashboard/admin.yml
kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token' | awk '{print $2}'
```

By default, the web dashboard is only accessible from within the cluster, which isn't particularly useful because we're on a separate machine. We need to open a second terminal on our personal machine and run `kubectl proxy`, which will open a proxy to the K3s cluster. With `kubectl proxy` still running in the background, click on the link below.

[http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

You'll be prompted to enter your token.

{{< img src="20220312_001.png" alt="k8s dashboard login screen" >}}

Finally, you'll see the dashboard. Click around to explore your setup.

{{< img src="20220312_002.png" alt="k8s dashboard" >}}

## Lens

[Lens](https://k8slens.dev/) is probably the next-most popular k8s GUI. It is made by [Mirantis](https://www.mirantis.com/software/lens/), the same people who make [k0s](https://k0sproject.io/) and who recently [purchased](https://www.mirantis.com/blog/mirantis-acquires-docker-enterprise-platform-business/) Docker Enterprise. It is [open source](https://github.com/lensapp/lens), but also offers a paid cloud service called [Lens Spaces](https://k8slens.dev/spaces.html).

Lens is Electron-based, which means it's available for a ton of platforms, but it's also Electron-based, so there's that slow memory leak to look forward to. :man_shrugging:

See the installation instructions [here](https://docs.k8slens.dev/main/getting-started/). I'm using Arch, btw, so I'm using the version from the [AUR](https://aur.archlinux.org/packages/lens-bin).

```
yay -s lens-bin
```

Lens reads your `~/.kube/config` file, so no setup or proxy is required.

{{< img src="20220328_002.png" alt="lens" >}}

## Octant

[Octant](https://octant.dev/) is made by the good folks at VMware, as part of their [Tanzu](https://tanzu.vmware.com/) portfolio of cloud/DevOps products. It is [open source](https://github.com/vmware-tanzu/octant/) and written in Go.

Installation instructions are [here](https://github.com/vmware-tanzu/octant/#installation), but it's available via the [AUR](https://aur.archlinux.org/packages/octant-bin).

```
yay -s octant-bin
```

Octant reads your `~/.kube/config` file and will open a proxy to 127.0.0.1:7777 in your default web browser.

{{< img src="20220328_003.png" alt="octant" >}}

## Infra App

[Infra App](https://infra.app/) is certainly beautiful to look at, but it appears to be closed source. For free, you can connect to one cluster. The paid plan offers unlimited clusters, but is a subscription at $100/yr.

Infra App reads your `~/.kube/config` file, so no setup or proxy is required.

{{< img src="20220328_005.png" alt="infra app" >}}

## Kubenav

[Kubenav](https://kubenav.io/) is a stand-alone project that is [open source](https://github.com/kubenav/kubenav) and written in Typescript. It also appears to be Electron-based, but its claim to fame is that it offers mobile apps for iOS and Android (since it's basically a website in a wrapper).

The version in the AUR was out of date (shock!), so I downloaded the binary from the [releases page](https://github.com/kubenav/kubenav/releases).

Kubenav reads your `~/.kube/config` file, so no setup or proxy is required.

{{< img src="20220328_004.png" alt="kubenav" >}}

## K9s

[K9s](https://github.com/derailed/k9s) is _technically_ a terminal UI (TUI), not a GUI.

I installed K9s via the [Arch repos](https://archlinux.org/packages/community/x86_64/k9s/) with pacman, but K9s offers [installation instructions](https://github.com/derailed/k9s#installation) for other operating systems on their GitHub page.

```
sudo pacman -S k9s
```

K9s reads your `~/.kube/config` file, so no setup or proxy is required.

{{< img src="20220328_001.png" alt="k9s" >}}

# Conclusion

I'm going to stick with Lens, since that's what we're using at work, but I'm probably going to keep looking at other products as they are improved over time.

\-Logan
---
title: "K3s single-node cluster for noobs"
date: "2022-03-11"
author: "Logan Marchione"
categories:
  - "oc"
  - "cloud-internet"
cover:
    image: "/assets/featured/featured_k3s.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I'm starting a new job in the next few days that will require me to learn Kubernetes (often stylized as k8s). This post is not about what k8s is or why you want it (you can read about that [here](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)). My only objective for now is to have a single-node k8s cluster running in my homelab.

⚠️ WARNING ⚠️

- I am not a Kubernetes expert!
- This is solely for my own learning. If you get something useful out of my ramblings, that's great, but it's not my primary goal.
- Nothing I setup here should be considered production-ready or secure.

## Lightweight k8s

Production k8s installations can vary in size and complexity, but upstream k8s has a ton of components and moving pieces (etcd, kube-apiserver, kube-scheduler, kubelet, DNS, etc...). As you can imagine, it's complicated to setup correctly, especially on resource-limited or single-node clusters. Out of necessity, there are now quite a few lightweight k8s distributions that not only strip out the features most people won't use, but also simplify installation and setup.

- [k0s](https://k0sproject.io/) (made by Mirantis, who owns Docker, Inc.)
- [MicroK8s](https://microk8s.io/) (made by Canonical, who also makes Ubuntu)
- [K3s](https://k3s.io/) (made by [Rancher](https://rancher.com/), which was recently [purchased](https://www.suse.com/news/suse-completes-rancher-acquisition/) by SUSE)
- [minikube](https://minikube.sigs.k8s.io/) (the "official" mini-k8s distribution)

I'm going with K3s because it seems to have the largest community, it's [CNCF-certified](https://www.cncf.io/projects/k3s/), and it's lightweight (~60MB binary).

## Single-node? Why?

Obviously, a single-node cluster provides no H/A or failover capability. However, you interact with a single-node cluster the same way you do a 100-node cluster. This is all about learning, not about being highly-available, efficient, or practical.

# Install K3s (on the server)

These commands should be entered on the server that will run K3s. In my case, this is a virtual machine running Debian 11.

Run the command below to install K3s on your server. Pro-tip: If you're doing this in a VM, take a snapshot now so you can roll back later if you mess up!

```
curl -sfL https://get.k3s.io | sh -
```

Once it's done, check that K3s is running.
```
sudo systemctl status k3s.service
```

Verify your cluster and node info.
```
sudo kubectl cluster-info
sudo kubectl get node
```

Congrats! Your single-node cluster is running! Now, view the contents of the `/etc/rancher/k3s/k3s.yaml` file, we'll need this later.
```
sudo cat /etc/rancher/k3s/k3s.yaml
```

Also, if there is a firewall on your server, you'll need to open `6443/TCP` for external cluster access.
```
sudo ufw allow 6443/tcp
sudo ufw reload
```

# Setup kubectl (on your personal machine)

These commands should be entered on the machine that will interact with your K3s cluster. In my case, this is a desktop running Arch Linux.

The tool used to interact with a k8s (or K3s) cluster is called [kubectl](https://kubernetes.io/docs/tasks/tools/), which is included with K3s. However, you typically don't SSH to the server to interact with the cluster. Instead, you install kubectl on your personal machine (desktop, laptop, etc...) and connect to the cluster remotely.

I'm running Arch, so I installed [kubectl](https://archlinux.org/packages/community/x86_64/kubectl/) with pacman.
```
sudo pacman -S kubectl
```

Run the command below to make sure kubectl works. For now, ignore the error about the connection to the server not working.
```
kubectl version --output=yaml
```

Next, create an empty directory to hold the configuration file for kubectl.
```
mkdir -p ~/.kube
touch ~/.kube/config
chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config
```

Now, copy/paste the contents of `/etc/rancher/k3s/k3s.yaml` from the server into `~/.kube/config` on your personal machine. While you're doing this, replace the IP (which is probably `127.0.0.1`) with your server's IP (mine was `10.10.1.51`).

Run the commands below and you should be able to see cluster info from your personal machine.

```
kubectl version --output=yaml
kubectl cluster-info
kubectl get node
```

Congrats! You can now interact with your cluster remotely.

# Web dashboard

Because K3s is upstream k8s (with some bits stripped out), let's go one step further and setup the [official k8s web dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

Kubernetes resources (pods, deployments, services, etc...) are written in plaintext JSON or YAML files called [manifests](https://kubernetes.io/docs/reference/glossary/?all=true#term-manifest). Think of manifests like `docker-compose` files.

First, we need to apply the dashboard manifest to the cluster by running the command below on our personal machine (again, kubectl on our personal machine connects to the cluster).

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.1/aio/deploy/recommended.yaml
```

Next, we need to create a user and role to login to the dashboard. I recommend storing all of your manifests in a directory for easy management. You can copy/paste the commands below to create the directory and the manifest.

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

By default, the web dashboard is only accessible from within the cluster, which isn't particularly useful because we're on a separate machine. We need to open a second terminal on our personal machine and run `kubectl proxy`, which will open a proxy to the K3s cluster.

With `kubectl proxy` still running in the background, click on this link.

[http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

You'll be prompted to enter your token.

{{< img src="20220312_001.png" alt="k8s dashboard login screen" >}}

Finally, you'll see the dashboard. Click around to explore your setup.

{{< img src="20220312_002.png" alt="k8s dashboard login screen" >}}

# Conclusion

Like I mentioned, this cluster is for learning. I have my homelab (more about that setup [here](/2021/01/homelab-10-mini-rack/)) running mostly on docker-compose. My plan is make this a multi-part series, then slowly start migrating applications to K3s. Before I do that, I'll need to investigate the following things:

- Persistent storage (i.e., volumes)
- Secret storage (e.g., passwords, database connection strings, etc...)
- Ingress (accessing applications from outside the cluster)
- SSL/TLS
- Backups

If you're running K3s (or any k8s distribution) at home, I'd love to hear about it!

\-Logan
---
title: "K3s cluster updates"
date: "2022-12-07"
author: "Logan Marchione"
categories:
  - "oc"
  - "cloud-internet"
  - "linux"
  - "kubernetes"
cover:
    image: "/assets/featured/featured_k3s.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_k3s %}}

# Introduction

It's been a while since my [last K3s post](/2022/03/kubernetes-guis/). In that time, I've torn-down and rebuilt my single-node cluster a dozen times, but never actually moved any workloads to that cluster. I've also been at my job using Amazon EKS for about six months, so I think I know *just* enough to be dangerous now :winking_face:.

# Changes since last post

In the [conclusion section](/2022/03/k3s-single-node-cluster-for-noobs/#conclusion) of my initial K3s post, I outlined things that I needed to setup in order to move my workloads to my single-node cluster. This post today is an attempt to explain some of those updates (and more).

## Database

Vanilla K8s stores all of its configuration data, state data, and metadata in [etcd](https://etcd.io/), which is an open source NoSQL key-value database. There is an excellent article [here](https://learnk8s.io/etcd-kubernetes) about how etcd works.

Interestingly, while K3s can use etcd, it also has a home-grown shim called [Kine](https://github.com/k3s-io/kine/) (Kine is not etcd) which can translate a subset of etcd API calls into SQLite, MySQL, and PostgreSQL calls. This allows K3s to use other databases as backend storage (even though vanilla K8s only allows etcd).

I chose to specifically use the etcd database instead of the default SQLite by specifying `--cluster-init` when installing K3s.


```
curl -sfL https://get.k3s.io | sh -s - server --cluster-init
```

## Imperative vs Declarative

K8s can be managed in one of two ways: imperatively or declaratively.

Imperative management is when you tell K8s to do something. For example, "create a namespace call test".

```
kubectl create namespace test
```

Imperative management is useful for making small one-off changes (e.g., in an emergency), but it provides no audit trail or history.

Declarative management is when you tell K8s what desired state you want to have in the end and you trust K8s to figure out how to get there. For example, "I want a namespace called test to exist". Typically, this is done by defining your resources in a YAML file, then applying that file.

```
cat <<EOF > namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: test
EOF

kubectl apply -f namespace.yaml
```

Declarative management is what you should be using in production, as it gives you a reproducible build every time. Because of this, I'm going to *try* to stick to declarative management, which typically means using [GitOps](https://www.gitops.tech/#what-is-gitops). If you're not familiar, GitOps simply means storing everything in Git and using Git as your source of truth. This is both a blessing and a curse, as it gives you reproducible builds, but you need to be careful what you commit to Git (e.g., don't commit plain-text passwords).

## Flux vs ArgoCD

[Flux](https://fluxcd.io/flux/) and [ArgoCD](https://argoproj.github.io/cd/) are both continuous delivery (CD) tools. They watch a Git repo for changes (in my case, GitHub) and apply updates when seen. Hint: this is why I'm using declarative management.

I originally wanted to use ArgoCD in my K3s cluster because it has a very nice web UI, but I went with Flux instead. After some testing, I discovered ArgoCD didn't support [variable substitution](https://github.com/argoproj/argo-cd/issues/5580) inside manifest files for deployments/services/ingress/etc... Even though the information isn't "secret", I didn't want to expose internal domain names in plain-text in my Git repo (same reasoning as [this post](https://budimanjojo.com/2021/10/27/variable-substitution-in-flux-gitops/)).

```
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: whoami-ingress
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
    - host: whoami.${DOMAIN_NAME}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: whoami-service
                port:
                  number: 80
```

If you're interested, my homelab K3s repository that Flux watches is [here](https://github.com/loganmarchione/k8s_homelab).

## Persistent storage

To make K3s smaller, Rancher [removed a bunch of volume plugins](https://docs.k3s.io/storage) from K3s. For me, this is mostly ok, since I'm using K3s at home and don't need this enterprise functionality.

Currently, my Docker-based homelab runs on a single virtual machine on a single Proxmox host (see below for crude ACSII art). Docker Compose creates volumes for each application under `/var/lib/docker/volumes`. I have no redundancy at the hypervisor-level, or the host-level, and I'm OK with that.

```
|----------------------------------------------------------------------------------------|
|          Proxmox host                                                                  |
|                                                                                        |
| |----------------------|       |----------------------|       |----------------------| |
| |   Docker host (VM)   |       |                      |       |                      | |
| |                      |       |     Other VM         |       |     Other VM         | |
| | |------------------| |       |                      |       |                      | |
| | |                  | |       |----------------------|       |----------------------| |
| | |   Container1     | |                                                               |
| | |                  | |       |----------------------|       |----------------------| |
| | |------------------| |       |                      |       |                      | |
| |                      |       |     Other VM         |       |     Other VM         | |
| | |------------------| |       |                      |       |                      | |
| | |                  | |       |----------------------|       |----------------------| |
| | |   Container2     | |                                                               |
| | |                  | |                                                               |
| | |------------------| |                                                               |
| |                      |                                                               |
| | |------------------| |                                                               |
| | |                  | |                                                               |
| | |   Container3     | |                                                               |
| | |                  | |                                                               |
| | |------------------| |                                                               |
| |                      |                                                               |
| |----------------------|                                                               |
|                                                                                        |
|----------------------------------------------------------------------------------------|
```


I don't need multiple nodes at home, and the complexity of HA with compute and storage isn't worth it. For K3s, I considered installing [Rancher Longhorn](https://longhorn.io/), but it seemed like too much work. I'm currently using single-node storage, and I'll continue to do so with K3s. K3s currently supports the following local storage options:

- [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) - Mounts a file/directory from the host into the Pod (best practice to not use this).
- [local](https://kubernetes.io/docs/concepts/storage/volumes/#local) - Like `hostPath`, but K8s tracks which node has the storage, and won't assign a pod to a different node if its storage is on a specific node.
- [local path provisioner](https://github.com/rancher/local-path-provisioner) - This was created by Rancher and is built into K3s (run `kubectl get storageclass` to see it). This is what I'm using.

## Secret storage

K8s includes a native secret storage object called a [secret](https://kubernetes.io/docs/concepts/configuration/secret/). A secret is used to store user-defined secrets, like passwords, API keys, etc... Secrets are, somewhat unintuitively, not encrypted. Instead, they are [base64 encoded](https://en.wikipedia.org/wiki/Base64) and stored (unencrypted) in the underlying data store (e.g., etcd). Base64 encoding is **NOT** encryption.

```
example_here ---base64encode---> ZXhhbXBsZV9oZXJl ---base64decode---> example_here
```

I highly recommend that you read [this post](https://www.macchaffee.com/blog/2022/k8s-secrets/) called "Plain Kubernetes Secrets are fine". I won't rehash it, but basically, the author argues that secrets have to be stored unencrypted *somewhere*, so it might as well be in your etcd, and if someone gets access to your cluster, you're screwed anyways :man_shrugging:. I considered the following options:

* [Bitnami's Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) - It felt...:face_vomiting:...to store secrets in Git, even if they were encrypted
* [Mozilla SOPS](https://github.com/mozilla/sops) - Again, storing secrets in Git
* [External Secrets](https://github.com/external-secrets/external-secrets/) - Would require an external server/service to manage
* [Hashicorp's Vault](https://github.com/hashicorp/vault) - While this is definitely the "best" solution, it seemed like overkill and something that could too easily go wrong (e.g., bootstrap, unsealing, backup, restore, etc...)

It's not the GitOps way, but I'm currently manually creating a series of secrets at the start of the bootstrap process. I'm doing this to save time and complexity, but this isn't a permanent solution.

```
kubectl create secret generic cluster-secret-vars \
  --namespace=flux-system \
  --from-literal=SECRET_INTERNAL_DOMAIN_NAME=your.domain.com \
  --from-literal=SECRET_LETS_ENCRYPT_EMAIL=name@email.com \
  --from-literal=SECRET_AWS_REGION=region-here-1
```

## Ingress

For simplicity's sake, I'm sticking with [Traefik ingress](https://github.com/traefik/traefik), which comes bundled with K3s. I know Nginx's configuration language better, but I'm using Traefik with Docker Compose right now, so I figured most of my configuration could translate to K3s. I did consider the following options:

- [ingress-nginx](https://github.com/kubernetes/ingress-nginx) (the "official" community ingress controller)
- [nginxinc/kubernetes-ingress ](https://github.com/nginxinc/kubernetes-ingress) (the freemium offering from F5/Nginx)
- [Kong](https://github.com/Kong/kubernetes-ingress-controller) (based on Nginx, also freemium)

## SSL/TLS

Traefik can handle SSL/TLS natively, and it's what I currently use in my Compose-based homelab. However, Traefik stores its certificates in JSON files, while [cert-manager](https://cert-manager.io/) stores its certificates in K8s secrets, which makes them easier to reference. As an added bonus, cert-manager also has support for:

- private CAs
- self-signed certs
- external issuers like AWS, GCP, and smallstep
- other ACME providers (not just Let's Encrypt)

I use Route53 for DNS, so I already had the correct IAM policy and access keys, so I was able to follow the [official documentation](https://cert-manager.io/docs/configuration/acme/dns01/route53/) and [this post](https://taco.moe/kubernetes-managed-tls-certificates-with-cert-manager) as well.

## Backups

I'm running my K3s node on Proxmox, so I already have daily virtual machine backups setup via Proxmox.

For file-level backups, Rancher's local path provisioner stores volumes in `/var/lib/rancher/k3s/storage/`. I'm going to end up writing a script that:

1. stops K3s and all running pods
1. uses `tar` and `zstd` to compress the entire `/var/lib/rancher/k3s/storage/` directory
1. starts K3s and all pods
1. moves the `filename.tar.zst` file offsite

# Things I'm keeping an eye on

- K3s comes with a built-in service load balancer called [Klipper](https://docs.k3s.io/networking#service-load-balancer). However, as outlined in [this post](https://geek-cookbook.funkypenguin.co.nz/kubernetes/loadbalancer/k3s/), Klipper has some limitations and might bite me in the future.
- Even though I'm using local storage via the local path provisioner provided by K3s, I still may using Longhorn in a single-node setup. If I ever get more nodes, it should be easy to expand.
- I need a new strategy for secret management. As a first step, I will probably [encrypt secrets inside the cluster](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).

# Conclusion

I've moved 20+ applications onto my single-node K3s cluster. I have Renovate setup watching my GitHub repo, so it is always making PRs for updates (which I like). I've also gone through a K3s, Flux, and Helm upgrade, all without issue. So far, so good!

\-Logan
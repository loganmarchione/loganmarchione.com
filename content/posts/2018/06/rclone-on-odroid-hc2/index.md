---
title: "Rclone on ODROID-HC2"
date: "2018-06-18"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
  - "storage"
cover:
    image: "/assets/featured/featured_rclone_logo.svg"
    alt: "featured image"
    relative: false
---

# Introduction

In my last post, I talked about setting up an [ODROID-HC2 as a NAS](/2018/06/odroid-hc2-as-an-entry-level-nas/) using OpenMediaVault. I have that up and running, and I've also written a few scripts to backup my data to a few of the SMB shares.

Now, I need to get that data shipped offsite to an external location to cover my 3-2-1 backup strategy:

- 3 backups
- 2 different types of media
- 1 backup offsite

## Software

My cloud storage provider of choice is B2. I've [written](/2017/07/backblaze-b2-backup-setup/) about them in the past and have generally had good luck with them, so I'd like to keep using them.

I was looking for software to transfer my backups to an offsite location, but it had it fit a few requirements:

- work with B2 by default - B2 is [object storage](https://www.digitalocean.com/community/tutorials/object-storage-vs-block-storage-services), so I can't just push files to it via SSH or SCP, I need a client that can speak in B2's [HTTP API](https://www.backblaze.com/b2/docs/calling.html) language
- support encryption locally - because this data is going to be stored on devices not controlled by me, I wanted it to be encrypted locally before being sent to storage
- open source - since this program is going to be encrypting my data, I want it to be auditable and trustworthy

While looking for backup programs, I compared the following:

- [Attic](https://attic-backup.org/)
- [BorgBackup](https://github.com/borgbackup)
- [Duplicity](http://duplicity.nongnu.org/)
- [Duplicacy](https://duplicacy.com/)
- [Duplicati](https://www.duplicati.com)
- [git-annex](https://git-annex.branchable.com/)
- [rclone](https://rclone.org/)

I ended up choosing rclone for this task, instead of Duplicity. Duplicity is great, but it requires a good bit of memory to run, and it writes temporary files to local storage while it encrypts and uploads them. Because the ODROID-HC2 has limited hardware, I didn't want this to become a problem. As far as I can tell, rclone doesn't have these problems or limitations. In addition, this backup is really a backup of a backup, so I'm just interested in pushing large amounts of data offsite as quickly as possible, which rclone seems to be suited for.

# Setup rclone

## Install rclone

Rclone is available in the default Debian/Ubuntu repositories. However, the version is pretty out of date. On Ubuntu, you can add a PPA to get a newer version, but on Debian you can't. Because of this, I recommend downloading the .deb directly from the rclone website.

```
sudo curl -sLO https://downloads.rclone.org/rclone-current-linux-arm.deb && sudo dpkg -i rclone-current-linux-arm.deb
```

Then, verify rclone is installed.

```
rclone -V
```

## Configure rclone remote

Rclone uses a concept called _remotes_. Remotes are just remote storage locations, and you can nest remotes inside of other remotes.

First, configure rclone. It's important to do this as the user that will be running rclone, so keep that in mind if you want to use a service account (more about this later).

```
rclone config
```

Press _n_ to create a new remote.

```
n
```

Name the remote (I'm using _backup01_).

```
backup01
```

Press _3_ to select _B2_ from the menu.

```
3
```

Enter your B2 account ID (you get this from B2's control panel).

```
xxxxxxxxxxxx
```

Enter your B2 application ID (you get this from B2's control panel).

```
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Leave the endpoint blank.

Press _y_ to to save your configuration.

```
y
```

## Configure rclone encrypted remote

Now, we're going to created an encrypted remote inside of our first remote. Anything that goes into this encrypted remote will be encrypted automatically.

Press _n_ to create a new remote.

```
n
```

Name the remote (I'm using _backup01\_crypt_).

```
backup01_crypt
```

Press _5_ to select _crypt_ from the menu.

```
5
```

Enter the name of your rclone remote (e.g., _backup01_), followed by your B2 bucket name.

```
backup01:bucket01
```

Press _2_ to encrypt the file names.

```
2
```

Choose to create or generate a passphrase (I'm going to generate one).

Choose to create or generate a salt (I'm going to generate one).

Press _y_ to to save your configuration.

```
y
```

# Run backup

When you want to backup a file or directory, use the command below.

```
rclone sync /home/local/directory remote:bucket
```

In my case, the remote is _backup01\_crypt_, and the bucket name is _bucket01_.

```
rclone sync /home/local/directory backup01_crypt:bucket01
```

Once the files are synced, you can list the files on the remote using the command below.

```
rclone lsf remote:bucket
```

In my case, the remote is _backup01\_crypt_, and the bucket name is _bucket01_.

```
rclone lsf backup01_crypt:bucket01
```

# ODROID performance

Overall, it look a little under 24 hours to do the initial transfer of around 580GB. During that time, my ODROID was hovering about 65-70°C.

```
CPU temp: 68°C
```

Also during this time, the ODROID-HC2 was using about 1GB RAM out of the available 2GB.

```
      total used free shared buff/cache available
Mem:   1993  965  209     51        818       921
Swap:   996   91  905
```

CPU usage hovered around 60% total capacity.

```
Load average: 0.59 0.56 0.71
```

# A note about bandwidth

By default, rclone will transfer four files at the same time. If you want to change this number, you can use the `--transfers` flag. Obviously, if you have the hardware to support it, you can increase this number, which will decrease the amount of time it takes to complete your transfers, at the cost of CPU, memory, and bandwidth.

```
rclone --transfers=6 sync /home/local/directory backup01_crypt:bucket01
```

My internet connection is Verizon FiOS 100/100Mbps. I found that when using the default of four transfers at once, my bandwidth usage was about 60-80Mbps. However, when I kicked the transfers up to six, my bandwidth was 100% utilized at 100Mbps. This does decrease transfer time, but the internet in my house was almost unusable because the connection was saturated. Just something to keep in mind.

# Backup your config file!

By default, rclone stores all of your B2 account information, your password, salt, and settings in the _~/.rclone.conf_ file of the account you used to configure rclone. If you lose this file, you lose access to all of your backups. Obviously, backup this file, but don't save the backup on your encrypted storage.

# Helpful commands

I've tried to gather some of the most useful commands from [rclone's website](https://rclone.org/commands/).

| Command | Description |
| --- | --- |
| `rclone listremotes` | List all remotes |
| `rclone config show remote` | Show config for a remote |
| `rclone size remote:bucket` | Show total size and number of objects on remote |
| `rclone ls remote:bucket` | List objects on remote |
| `rclone lsd remote:bucket` | List directories on remote |
| `rclone ncdu remote:bucket` | Like NCDU, but for your remote. Useful for seeing what is taking up disk space |
| `rclone mount --read-only remote: /path/to/local/directory` | Mount your remote in a read-only state on a local directory |
| `rclone tree remote:bucket` | Like tree Caveat - if filenames are encrypted, it will show them as encrypted |
| `rclone serve http remote:bucket --addr :8080` | Start a HTTP server to browse the remote, listen on all IPs on port 8080. Caveat - if filenames are encrypted, it will show them as encrypted |
| `rclone sync /home/local/directory remote:bucket` | Copy source to destination, but **do** delete files in the destination if they were deleted from source (like the `--delete` flag in rsync) |
| `rclone copy /home/local/directory remote:bucket` | Copy source to destination, but **do not** delete files in the destination if they were deleted from source |
| `rclone cleanup remote:bucket` | Delete old versions of files stored on the remote |

Hope this helps!

\-Logan

# Comments

[Old comments from WordPress](/2018/06/rclone-on-odroid-hc2/comments.txt)
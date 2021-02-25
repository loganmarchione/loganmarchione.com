---
title: "Securing Postgres connections using Let's Encrypt certificates"
date: "2020-10-22"
author: "Logan Marchione"
categories: 
  - "oc"
  - "encryption-privacy"
  - "linux"
cover:
    image: "/assets/featured/featured_postgres_lets_encrypt.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I'm on a quest to SSL all the things on my local network. I work in IT security, and am more than paranoid when it comes to my homelab (shout-out to [r/homelab](https://www.reddit.com/r/homelab/) and [r/selfhosted](https://www.reddit.com/r/selfhosted/)).

{{< img src="20201021_001.jpg" alt="meme" >}}

For my web applications, everything is accessed through a [Nginx reverse proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/) that uses [Let's Encrypt](https://letsencrypt.org/) wildcard certificates (using the [DNS challenge](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge)) for encryption. It provides a single choke-point for all my traffic, all using one wildcard certificate, and all my clients accept it with the green lock.

However, connections between servers/applications are usually not encrypted. For example, I run a bunch of applications in Docker, but one thing I keep on a separate VM are my databases (specifically, [PostgreSQL](https://www.postgresql.org/)). Some of my Docker containers (specifically, [Gitea](https://gitea.io/), [Drone](https://drone.io/), and [Miniflux](https://miniflux.app/)) connect to this database, but these connections are not encrypted.

```
------------------
|     Docker     |
|                |
|  ------------  |
|  |          |  |
|  |  Gitea   |--|-\
|  |          |  |  \
|  ------------  |   \
|                |    \
|  ------------  |     \         ------------
|  |          |  |      \        |   (VM)   |
|  |  Drone   |--|-------------> | Postgres |
|  |          |  |      /        |          |
|  ------------  |     /         ------------
|                |    /
|  ------------  |   /
|  |          |  |  /
|  | Miniflux |--|-/
|  |          |  |
|  ------------  |
|                |
------------------
```

My plan is to:

- get a certificate on the database server
- make Postgres use those certificates
- make my applications connect to Postgres over SSL

# Get a certificate

I could generate a self-signed SSL certificate on the database server, and just tell the clients to trust it (even though it is not signed). However, since Let's Encrypt is so easy to use, I figured I'd try that first, and go from there.

I won't go over how to request a certificate from Let's Encrypt. I used [Certbot](https://certbot.eff.org/), requesting the certificate only (since there's no webserver needed). In the end, we need the two certificate files below (where _postgres.yourdomain.com_ is the name of the Postgres server from the certificate request).

```
/etc/letsencrypt/live/postgres.yourdomain.com/fullchain.pem
/etc/letsencrypt/live/postgres.yourdomain.com/privkey.pem
```

# Configure Postgres

## Edit Postgres configuration

First, edit the configuration file at _/etc/postgresql/VERSION/main/pg\_hba.conf_, where _VERSION_ is your Postgres version (mine is _11_). Change `host` to `hostssl` on the line where the server listens for external connections (e.g., 0.0.0.0/0).

```
hostssl all all 0.0.0.0/0 md5
```

Normally, you would set the certificate and key paths in the Postgres configuration file, restart, and be good to go. However, Postgres won't have permissions to read the certificates, but if we change the permissions, Certbot won't renew the certificates. Also, symlinks won't work (I tried).

Edit the configuration file at _/etc/postgresql/VERSION/main/postgresql.conf_, where _VERSION_ is your Postgres version (mine is _11_). Find the SSL section, then edit it to enable SSL and specify the locations of the certificate and key.

```
ssl = on
ssl_cert_file = '/etc/postgresql/11/main/fullchain.pem'
ssl_key_file = '/etc/postgresql/11/main/privkey.pem'
```

Next, run the commands below to copy the certificates from their original location to the Postgres configuration folder, change their permissions, then restart Postgres (change the paths as necessary).

```
cp /etc/letsencrypt/live/postgres.yourdomain.com/fullchain.pem /etc/postgresql/11/main/fullchain.pem
cp /etc/letsencrypt/live/postgres.yourdomain.com/privkey.pem /etc/postgresql/11/main/privkey.pem
chmod 600 /etc/postgresql/11/main/fullchain.pem /etc/postgresql/11/main/privkey.pem
chown postgres:postgres /etc/postgresql/11/main/fullchain.pem /etc/postgresql/11/main/privkey.pem
systemctl restart postgresql
```

## Test Postgres connection

Check the logs for Postgres (probably located at _/var/log/postgresql_) to make sure there were no errors starting. You may see errors from your applications trying to connect in a non-secure way, but we'll fix that shortly. From a separate server, check that Postgres is communicating with a certificate (OpenSSL recently added [this](https://www.openssl.org/docs/manmaster/man1/openssl-s_client.html#starttls-protocol) feature).

```
openssl s_client -starttls postgres -connect postgres.yourdomain.com:5432 </dev/null
```

# Configure clients

Luckily for me, Gitea, Drone, and Miniflux are all written in Go. Because of this, they use the [lib/pq](https://pkg.go.dev/github.com/lib/pq) library to connect to Postgres databases, which means they all use the same connection string. All I needed to change was the `sslmode` option from `disable` to `verify-full`, then restart the applications (in my case, the Docker containers).

```
postgres://user:password@postgres.yourdomain.com:5432/database_name?sslmode=verify-full
```

As long as the Docker image you're using has the `ca-certificates` package installed, you're good to use `verify-full` or `verify-ca`, since Let's Encrypt is in the list of valid root certificates.

## Check clients (on the database)

Now, back on the Postgres database, run the command below.

```
SELECT ssl.pid, usename, datname, ssl, ssl.version, ssl.cipher, ssl.bits, ssl.compression, client_addr
FROM pg_catalog.pg_stat_ssl ssl, pg_catalog.pg_stat_activity activity
WHERE ssl.pid = activity.pid;
```

Here, we can see the clients are all connected via SSL.

```
pid  | usename  |  datname   | ssl | version |         cipher         | bits | compression | client_addr  
-----+----------+------------+-----+---------+------------------------+------+-------------+------------- 
4880 |          |            | f   |         |                        |      |             |  
4882 | postgres |            | f   |         |                        |      |             |  
5270 | postgres | postgres   | f   |         |                        |      |             |  
5927 | miniflux | dbminiflux | t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256 | f           | 10.10.1.32 
5931 | gitea    | dbgitea    | t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256 | f           | 10.10.1.32 
5937 | drone    | dbdrone    | t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256 | f           | 10.10.1.32 
5939 | drone    | dbdrone    | t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256 | f           | 10.10.1.32 
5935 | gitea    | dbgitea    | t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256 | f           | 10.10.1.32 
4878 |          |            | f   |         |                        |      |             |  
4877 |          |            | f   |         |                        |      |             |  
4879 |          |            | f   |         |                        |      |             |  
(11 rows)
```

# Certbot post-renew hook

The keen-eyed among you may have noticed that we copied the certificates from the Let's Encrypt directory to the Postgres directory. In 90 days when these certificates renew, we'll need to re-copy them. Conveniently, Certbot includes a way to run commands after a certificate is renewed, called a [post-hook](https://certbot.eff.org/docs/using.html?highlight=hook#renewing-certificates). In my case, I'll renew the certificate via cronjob, and run the same copy commands as before, but all in one line. It's not pretty, but it gets the job done (you could also make this into a bash script).

```
# LE cert renewal
14 08 * * * /opt/certbot/bin/certbot renew --post-hook "cp /etc/letsencrypt/live/postgres.yourdomain.com/fullchain.pem /etc/postgresql/11/main/fullchain.pem && cp /etc/letsencrypt/live/postgres.yourdomain.com/privkey.pem /etc/postgresql/11/main/privkey.pem && chmod 600 /etc/postgresql/11/main/fullchain.pem /etc/postgresql/11/main/privkey.pem && chown postgres:postgres /etc/postgresql/11/main/fullchain.pem /etc/postgresql/11/main/privkey.pem && systemctl restart postgresql" --quiet
```

# Conclusion

My other solution to this problem was to run Postgres in the same Docker stack as the application, eliminating the need for any traffic to cross the network. I still may do this in the future, but then it requires managing three instances of Postgres instead of one.

```
---------------------------------
|             Docker            |
|                               |
|  ------------   ------------  |
|  |          |   |          |  |
|  |  Gitea   |-->| Postgres |  |
|  |          |   |          |  |
|  ------------   ------------  |
|                               |
|  ------------   ------------  |
|  |          |   |          |  |
|  |  Drone   |-->| Postgres |  |
|  |          |   |          |  |
|  ------------   ------------  |
|                               |
|  ------------   ------------  |
|  |          |   |          |  |
|  | Miniflux |-->| Postgres |  |
|  |          |   |          |  |
|  ------------   ------------  |
|                               |
---------------------------------
```

Thanks for reading!

\-Logan
---
post_title: How to use NGINX
nav_title: NGINX
menu_order: 7
---

[NGINX](https://www.nginx.com) is a high-performance HTTP server, reverse proxy, and an IMAP/POP3 proxy server. NGINX is known for its high performance, stability, rich feature set, simple configuration, and low resource consumption. DC/OS allows you to quickly configure, install and manage NGINX. 

**Terminology**

- **Docker**: 
- **BRIDGE mode**: 

**Scope**

In this tutorial you will learn:
* How to install NGINX on DC/OS to serve a static website

**Table of Contents**

## Prerequisites

- A running DC/OS cluster, with atleast 1 node having atleast 1 CPUs and 1 GB of RAM available.
- [DC/OS CLI](https://docs.mesosphere.com/usage/cli/install/) installed

### Installing NGINX to serve a static website

Assuming you have a DC/OS cluster up and running, we are going to install NGINX on DC/OS to serve up a [hello-nginx website](http://mesosphere.github.io/hello-nginx/). Let's get started by creating a file called `options.json` with following contents:

```json
{
  "nginx": {
    "cpus": 1,
    "mem": 1024,
    "contentUrl":"https://github.com/mesosphere/hello-nginx/archive/master.zip",
    "bridge": true,
    "contentDir":"hello-nginx-master/"
  }
}
```

Next, we are going to install nginx using this `options.json` file:

```bash
dcos package install nginx --options=options.json
```

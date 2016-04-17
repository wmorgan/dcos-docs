---
post_title: How to use NGINX
nav_title: NGINX
menu_order: 7
---

## NGINX

### Installing NGINX on DC/OS
Installing nginx on DC/OS is as simple as doing:

```bash
dcos package install nginx
```

### Installing NGINX using BRIDGE Mode
To install NGINX using BRIDGE mode, create an options.json file with this content:

```json
{
  "nginx": {
    "bridge": true
  }
}
```

And, then install nginx like this:

```bash
dcos package install nginx --options=options.json
```

### Hosting static content using NGINX

To host static content using NGINX, create an options.json file with this content:
```json
{
  "nginx": {
    "contentUrl":"https://github.com/mohitsoni/mohitsoni.github.io/archive/master.zip",
    "bridge": true,
    "contentDir":"mohitsoni.github.io-master/"
  }
}
```

And, then install nginx like this:

```bash
dcos package install nginx --options=options.json
```

### Overriding default NGINX config

To override other NGINX configuration, please do so with an options.json file as above:

```json
{
  "nginx": {
    "cpus": 4,
    "mem": 4096,
    "contentUrl":"https://github.com/mohitsoni/mohitsoni.github.io/archive/master.zip",
    "bridge": true,
    "contentDir":"mohitsoni.github.io-master/"
  }
}
```

And, then install nginx like this:

```bash
dcos package install nginx --options=options.json
```

---
post_title: DC/OS Security
post_excerpt: "Describes security features and best practices in DC/OS"
layout: page
published: true
menu_order: 4
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

# DC/OS Security

This document will discuss some of the security features in DC/OS, in addition
to best practices for deploying DC/OS securely.

## General security concepts

DC/OS is based on a Linux kernel and userspace. The same best practices for
securing any Linux system apply to securing DC/OS, including setting correct
file permissions, restricting user accounts, protecting network interfaces
(e.g., by using iptables) and regularly applying updates from the distribution
(CentOS, CoreOS, etc.) to system libraries, utilities and core services like
systemd and OpenSSH.

## Security Zones

At the highest level we can distinguish three security zones in a DC/OS
deployment, namely the admin, private, and public security zones.

![Security Zones](img/security-zones.jpg)

### Admin zone

The **admin** zone is accessible via HTTP/HTTPS and SSH connections, and
provides access to the master nodes. It also provides reverse proxy access to
the other nodes in the cluster via URL routing. For security, you can
configure a whitelist during cluster creation so that only specific IP address
ranges are permitted to access the admin zone. The DC/OS template creates 1, 3
or 5 master nodes in the admin zone.

### Private zone

The **private** zone is a non-routable network that is only accessible from
the admin zone or through the edge router from the public zone. Deployed
services are run in the private zone. This zone is where the majority of agent
nodes are run. By default, the DC/OS cloud template creates 5 agent nodes in
the private zone

### Public zone

The optional **public** zone is where publicly accessible applications are
run. Generally, only a small number of agent nodes are run in this zone. The
edge router forwards traffic to applications running in the private zone. By
default, the DC/OS cloud template creates 1 agent node in the public zone.

The agent nodes in the public zone are labeled with a special role so that
only specific tasks can be scheduled here. These agent nodes have both public
and private IP addresses and only specific ports should be open in their
iptables firewall.

## Admin Router

Access to the Admin zone is controlled by the Admin Router.

HTTP requests incoming to your DC/OS cluster are proxied through the Admin
Router (using [Nginx](http://nginx.org) with
[OpenResty](https://openresty.org) at its core). The Admin Router denies
access to most HTTP endpoints for unauthenticated requests. In order for a
request to be authenticated, it needs to present a valid authentication token
in its Authorization header. A token can be obtained by going through the
authentication flow, as described in the next section.

Authenticated users are authorized to perform arbitrary actions in their
cluster. That is, there is currently no fine-grained level of access control
in DC/OS besides having access or not having access to services.

## Authentication Tokens

DC/OS uses the JSON Web Token (JWT) format for its tokens. JWT is an open,
industry standard ([RFC 7519](https://tools.ietf.org/html/rfc7519)) method for
securely representing claims between two parties.

Tokens sent to DC/OS in a HTTP Authorization header must be of the format
`token=<token>` instead of the more common `Bearer <token>`. The latter format
will be supported in addition to the current format in a future release.

## Authentication via CLI

To login, run `dcos auth login`
- You will be prompted with "Please go to the following link in your browser"
- Open the given link and authenticate with your account. Once you authenticate, you should see a token
- Copy the token from the browser to your cli
- If you correctly entered your token you should see "Login successful!"
- Your cli is now authenticated and can be used normally

To logout, run `dcos auth logout`.

Authentication is only supported for DC/OS CLI version 0.4.3 and above. See
[here](../docs/usage/cli/update/) for upgrade instructions.<

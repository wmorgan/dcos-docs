---
post_title: Using dcos tunnel
menu_order: 10
---

When developing applications on DC/OS, you may find it helpful to access your cluster via SOCKS proxy, HTTP proxy, or VPN. For instance, you can work from your own development environment and immediately test on your DC/OS cluster.

# SOCKS
dcos tunnel can run a SOCKS proxy over SSH to the cluster. SOCKS proxies work for any kind of network protocol on any port, but your application must be configured to use the proxy, which runs on port 1080 by default. 

# HTTP
Run the HTTP proxy on your local port 80 to have access to all URLs by appending the `mydcos.directory` domain. You can also use SRV records as if they were URLs. Otherwise, configure applications to use the proxy. <!-- ?? -->

## SRV Records
A SRV DNS record is a mapping from a name to a IP/port pair. DC/OS creates SRV records in the form `_<port-name>._<task-name>._tcp.marathon.mesos.mydcos.directory`. The HTTP proxy exposes these as URLs.

# VPN
dcos tunnel provides you with access to the DNS, masters, and agents from within the cluster. OpenVPN requires root privileges in order to configure these routes.

# Using dcos tunnel

## Prerequisites
* DC/OS 1.8+
* Docker
* Only Linux and OS X support currently
* Requires [SSH access](/1.8/administration/access-node/sshcluster/) (key authentication only)
* Fpr VPN you must have [the OpenVPN client](https://openvpn.net/index.php/open-source/downloads.html) installed.
* The dcos tunnel package must be installed from Universe: `dcos package install tunnel-cli --cli`


*** For commands that port forward, append `.mydcos.directory` to the end of your domain
e.g. http://example.com:8080/?query=hello becomes http://example.com.mydcos.directory:8080/?query=hello
SOCKS and HTTP port forward, VPN does not
The reason for this (does not need to be documented) is that the tunnel sends traffic that goes to `localhost` through SSH. But a normal url does not send traffic to `localhost`, it sends traffic to wherever you asked it to go (e.g. marathon.mesos). `mydcos.directory` is a special domain that always resolves to `localhost`, and within DC/OS we cut this part of the URL off before resolving it.

SOCKS
`dcos tunnel socks`
Port forwards! See above.
Configure application to use proxy on port 1080

HTTP
`sudo dcos tunnel http`
Port forwards! See above.
It will just work
Otherwise, if configured to not use port 80, it does not require root access (so just `dcos tunnel…`) and it will require applications to be configured to use the proxy.

OpenVPN
`sudo dcos tunnel vpn`
It should just work
There is an option enabled that auto-configures DNS, but it doesn’t work on OSX so DNS has to be configured manually with the printed ip addresses.

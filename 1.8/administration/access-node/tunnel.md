---
post_title: Access by Proxy
menu_order: 10
---

When developing applications on DC/OS, you may find it helpful to access your cluster via SOCKS proxy, HTTP proxy, or VPN. For instance, you can work from your own development environment and immediately test on your DC/OS cluster.

# SOCKS
dcos tunnel can run a SOCKS proxy over SSH to the cluster. SOCKS proxies work for any kind of network protocol on any port, but your application must be configured to use the proxy, which runs on port 1080 by default. Access URLs by appending the `mydcos.directory` domain.

# HTTP
Run the HTTP proxy on your local port 80 to tunnel HTTP requests without modifying your application. Access URLs by appending the `mydcos.directory` domain. You can also [use DNS SRV records as if they were URLs](#srv).

<a name="srv"></a>
## SRV Records
An SRV DNS record is a mapping from a name to a IP/port pair. DC/OS creates SRV records in the form `_<port-name>._<task-name>._tcp.marathon.mesos.mydcos.directory`. The HTTP proxy exposes these as URLs. This feature can be useful for communicating with Marathon apps.

# VPN
dcos tunnel provides you with full access to the DNS, masters, and agents from within the cluster. OpenVPN requires root privileges to configure these routes.

# Using dcos tunnel

## Prerequisites
* DC/OS 1.8+
* Docker
* Requires [SSH access](/1.8/administration/access-node/sshcluster/) (key authentication only).
* For VPN functionality, you must have [the OpenVPN client](https://openvpn.net/index.php/open-source/downloads.html) installed.
* The dcos tunnel package must be installed: run `dcos package install tunnel-cli --cli` from the DC/OS CLI.

**Note:** * Only Linux and OS X are supported currently.

##  SOCKS
Run the following command from the DC/OS CLI:

```
$ dcos tunnel socks
```

Configure your application to use the proxy on port 1080: `127.0.0.1:1080`

### Port Forwarding
The SOCKS proxy works by port forwarding. Append `.mydcos.directory` to the end of your domain when you enter commands. For instance, `http://example.com:8080/?query=hello` becomes `http://example.com.mydcos.directory:8080/?query=hello`.

##  HTTP
Run the following command from the DC/OS CLI:

```
$ sudo dcos tunnel http
```

To run the HTTP proxy without root privileges, configure it not to use port 80:

```
$ dcos tunnel http --port 8000
```

Then, configure your application to run HTTP on the port you specified above.

### Port Forwarding
The HTTP proxy works by port forwarding. Append `.mydcos.directory` to the end of your domain when you enter commands. For instance, `http://example.com:8080/?query=hello` becomes `http://example.com.mydcos.directory:8080/?query=hello`.

### SRV Records
The HTTP proxy exposes DC/OS SRV records as URLs in the form `_<port-name>._<task-name>._tcp.marathon.mesos.mydcos.directory`.

To name a port, add `name` to the `portMappings` field of a Marathon application definition:

```json
"portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 0,
          "servicePort": 10000,
          "name": "<my-port-name>",
          "labels": {
            "VIP_0": "1.1.1.1:30000"
          }
        }
      ]
```

Alternatively, [add a named VIP to your application from the DC/OS web interface](https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/virtual-ip-addresses/).

The `<task-name>` is the value of the `id` field in your Marathon application definition or the entry in the **ID** field of a service you create from the DC/OS web interface.

## VPN
Run the following command from the DC/OS CLI

```
$ sudo dcos tunnel vpn
```

The VPN client auto-configures DNS, but this functionality does not work on Mac OSX. To use the VPN client on OSX, [add the following DNS servers](https://support.apple.com/kb/PH18499?locale=en_US):

```
198.51.100.1
198.51.100.2
198.51.100.3
```

The VPN does not work by port forwarding, so you do not need to append `.mydcos.directory` to the end of your commands. For example, to access the DC/OS web interface from within the cluster, point your browser to `https://marathon.mesos`.

When you use the VPN, you are virtually within your cluster. To access your master node, just enter the following from your terminal:

```
ssh core@master.mesos
```

Similarly, you can interact with your agent nodes from virtually wthin the cluster. For instance:

```
$ ping slave.mesos
$ host slave.mesos
```

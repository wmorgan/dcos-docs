---
nav_title: Access by Proxy and VPN
post_title: Access by Proxy and VPN using DC/OS Tunnel
menu_order: 10
---

When developing services on DC/OS, you may find it helpful to access your cluster from your local machine via SOCKS proxy, HTTP proxy, or VPN. For instance, you can work from your own development environment and immediately test against your DC/OS cluster.

# SOCKS
DC/OS Tunnel can run a SOCKS proxy over SSH to the cluster. SOCKS proxies work for any protocol, but your service must be configured to use the proxy, which runs on port 1080 by default.

# HTTP

The HTTP proxy can run in two modes: transparent and standard.

##  Transparent Mode
In transparent mode, the HTTP proxy runs as superuser on port 80 and does not require modification to your application. Access URLs by appending the `mydcos.directory` domain. You can also [use DNS SRV records as if they were URLs](#srv).

## Standard Mode
You must configure your service to use the HTTP proxy in standard mode, though it does not have any of the limitations of transparent mode. As in transparent mode, you can use [DNS SRV](#srv) records as URLs.

<a name="srv"></a>
## SRV Records
A SRV DNS record is a mapping from a name to a IP/port pair. DC/OS creates SRV records in the form `_<port-name>._<service-name>._tcp.marathon.mesos`. The HTTP proxy exposes these as URLs. This feature can be useful for communicating with DC/OS services.

**Note:** The HTTP proxy cannot currently access HTTPS.

# VPN
DC/OS Tunnel provides you with full access to the DNS, masters, and agents from within the cluster. OpenVPN requires root privileges to configure these routes.

# DC/OS Tunnel Options at a Glance

<table class="table">
  <tr>
    <th>&nbsp;</th>
    <th>Pros</th>
    <th>Cons</th>
  </tr>
  <tr>
    <th>SOCKS</th>
    <td>
    <ul>
        <li>Specify ports</li>
        <li>All protocols</li>
    </ul>
    </td>
    <td>
        <ul>
            <li>Requires application configuration</li>
        </ul>
        </td>
  </tr>
  
  <tr>
      <th>HTTP (transparent)</th>
      <td>
      <ul>
          <li>SRV as URL</li>
          <li>No application configuration</li>
      </ul>
      </td>
      <td>
          <ul>
              <li>Cannot specify port</li>
              <li>Only supports HTTP</li>
              <li>Runs as superuser</li>
          </ul>
          </td>
    </tr>
    
    <tr>
          <th>HTTP (standard)</th>
          <td>
          <ul>
              <li>SRV as URL</li>
              <li>Specify ports</li>
          </ul>
          </td>
          <td>
              <ul>
                  <li>Requires application configuration</li>
                  <li>Only supports HTTP</li>
              </ul>
              </td>
     </tr>
     
     <tr>
               <th>VPN</th>
               <td>
               <ul>
                   <li>No application configuration</li>
                   <li>Full and direct access to cluster</li>
                   <li>Specify ports</li>
                   <li>All protocols</li>
               </ul>
               </td>
               <td>
                   <ul>
                       <li>More prerequisites</li>
                       <li>Runs as superuser</li>
                       <li><i>May</i> need to manually reconfigure DNS</li>
                       <li>Relatively heavyweight</li>
                   </ul>
                   </td>
      </tr>
    
</table>

# Using DC/OS Tunnel

## Prerequisites
* The [DC/OS CLI](/1.8/usage/cli/install/).
* The DC/OS Tunnel package. Run `dcos package install tunnel-cli --cli` from the DC/OS CLI.
* [SSH access](/1.8/administration/access-node/sshcluster/) (key authentication only).
* [The OpenVPN client](https://openvpn.net/index.php/open-source/downloads.html) for VPN functionality.

**Note:** Only Linux and OS X are supported currently.

##  SOCKS
Run the following command from the DC/OS CLI:

```
$ dcos tunnel socks
```

Configure your application to use the proxy on port 1080: `127.0.0.1:1080`

##  HTTP
### Transparent Mode

Run the following command from the DC/OS CLI:

```
$ sudo dcos tunnel http
```

#### Port Forwarding
In transparent mode, the HTTP proxy works by port forwarding. Append `.mydcos.directory` to the end of your domain when you enter commands. For instance, `http://example.com:8080/?query=hello` becomes `http://example.com.mydcos.directory:8080/?query=hello`.

### Standard mode
To run the HTTP proxy in standard mode, without root privileges, use the `--port` flag to configure it to use another port:

```
$ dcos tunnel http --port 8000
```

Then, configure your application to run HTTP on the port you specified above.

### SRV Records
The HTTP proxy exposes DC/OS SRV records as URLs in the form `_<port-name>._<service-name>._tcp.marathon.mesos.mydcos.directory` (transparent mode) or `_<port-name>._<service-name>._tcp.marathon.mesos` (standard mode).

#### Find your Service Name
The `<service-name>` is the entry in the **ID** field of a service you create from the DC/OS web interface or the value of the `id` field in your Marathon application definition.

#### Add a Named Port from the DC/OS Web Interface
To name a port from the DC/OS web interface, go to the **Services** tab, click the name of your service, and then click **Edit**. Enter a name for your port on the **Network** tab.

#### Add a Named Port in a Marathon Application Definition
Alternatively, you can add `name` to the `portMappings` or `portDefinitions` field of a Marathon application definition. Whether you use `portMappings` or `portDefinitions` depends on whether you are using `BRIDGE` or `HOST` networking. [Learn more about networking and ports in Marathon](https://mesosphere.github.io/marathon/docs/ports.html).

```json
"portMappings": [
    {
        "name": "<my-port-name>",
        "containerPort": 3000,
        "hostPort": 0,
        "servicePort": 10000,
        "labels": {
             "VIP_0": "1.1.1.1:30000"
        }
    }
]
```

```json
"portDefinitions": [
    {
      "name": "<my-port-name>",
      "protocol": "tcp",
      "port": 0,    
    }
  ]
```

## VPN
Run the following command from the DC/OS CLI

```
$ sudo dcos tunnel vpn
```

The VPN client attempts to auto-configure DNS, but this functionality does not work on Mac OSX. To use the VPN client on OSX, [add the DNS servers](https://support.apple.com/kb/PH18499?locale=en_US) that DC/OS Tunnel instructs you to use.

When you use the VPN, you are virtually within your cluster. To access your master node, just enter the following from your terminal:

```
$ ssh core@master.mesos
```

Similarly, you can interact with your agent nodes from virtually within the cluster. For instance:

```
$ ping slave.mesos
$ host slave.mesos
```

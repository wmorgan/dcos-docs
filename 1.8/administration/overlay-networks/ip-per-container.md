---
nav_title: IP-per-Container
post_title: Configuring IP-per-Container in Overlay Networks
menu_order: 10
---

In DC/OS the overlay network feature is enabled by default. The default configuration provides two overlay networks `dcos-1` and `dcos-2`, whose YAML configuration is as follows:

```yaml
  dcos_overlay_network:
    vtep_subnet: 172.16/12
    vtep_mac_oui: 70:B3:D5:00:00:00
    overlays:
      - name: dcos-1
        subnet: 192.168.0.0/17
        prefix: 24
      - name: dcos-2
        subnet: 192.168.128.0/17
        prefix: 24
```

**Note:** Use a recent Linux kernel (3.9 or later) and Docker version 1.11 or later on the agent nodes.

Each overlay network is identified by a canonical `name`. Containers launched on an overlay network will get an IP address from the subnet allocated to the overlay network. To remove the dependency on a global IPAM, the overlay subnet is further split into smaller container subnets. Each of the container subnets is allocated to an agent. The agents can then use a host-local IPAM to allocate IP addresses from their respective container subnets to containers launched on the agent and attached to the given overlay. The `prefix` determines the size of the container subnet (carved from the overlay subnet) allocated to each agent and thus defines the number of agents on which the overlay can run.

In the configuration above each overlay network is allocated a /17 subnet (in the “subnet” field), which is then divided into /24 container subnets to be used on each host that will be part of the network (in the “prefix” field) as shown:

![Overlay network address space](/1.8/administration/overlay-networks/img/overlay-network-address-space.png)

These values can be configured to adapt to each installation’s needs. If you need a larger network, decrease the network mask prefix of the `subnet`. To create an overlay network for only one agent node, specify the same value for the `subnet` network mask and the `prefix`. The size of the container space is `2^(32-<prefix>)`.

# Adding overlay networks during installation

Currently (as of version 1.8), DC/OS overlay networks can only be added and configured at install time. To replace or add another overlay network, [reinstall DC/OS according to these instructions](#replace).

You can override the default network or add additional overlay networks by modifying your `config.yaml` file:

```yaml
    agent_list:
    - 10.10.0.117
    - 10.10.0.116
    # Use this bootstrap_url value unless you have moved the DC/OS installer assets.
    bootstrap_url: file:///opt/dcos_install_tmp
    cluster_name: &lt;cluster-name&gt;
    master_discovery: static
    master_list:
    - 10.10.0.120
    - 10.10.0.119
    - 10.10.0.118
    resolvers:
    # You probably do not want to use these values since they point to public DNS servers.
    # Instead use values that are more specific to your particular infrastructure.
    - 8.8.4.4
    - 8.8.8.8
    ssh_port: 22
    ssh_user: centos
    dcos_overlay_network:
      vtep_subnet: 192.15.0.0/20
      vtep_mac_oui: 70:B3:D5:00:00:00
      overlays:
        - name: dcos-1
          subnet: 192.168.0.0/17
          prefix: 24
        - name: dcos-2
          subnet: 192.168.128.0/17
          prefix: 24
        - name: dcos-3
          subnet: 44.128.0.0/16
          prefix: 24
```

In the above example, we have defined three overlay networks. The overlay networks `dcos-1` and `dcos-2` basically retain the default overlay networks, and we have added another overlay network called `dcos-3` with subnet range `44.128.0.0/16`. When you create a network, you must give it a name and a subnet. That name is used to launch Marathon tasks and other Mesos frameworks tasks using this specific overlay network.

# Retrieving overlay network state

Once the DC/OS installation is complete you can query the overlay network configuration using the `https://leader.mesos/overlay-master/state` endpoint from within the cluster. The `network` key at the bottom lists the current overlay configuration and the `agents` key is a list showing how overlays are split across the Mesos agents. The following shows the network state when there is a single overlay in the cluster named `dcos`.

```json
    "agents": [
            {
                "ip": "10.10.0.120",
                "overlays": [
                    {
                        "backend": {
                            "vxlan": {
                                "vni": 1024,
                                "vtep_ip": "198.15.0.1/20",
                                "vtep_mac": "70:b3:d5:0f:00:01",
                                "vtep_name": "vtep1024"
                            }
                        },
                        "docker_bridge": {
                            "ip": "44.128.0.128/25",
                            "name": "d-dcos"
                        },
                        "info": {
                            "name": "dcos",
                            "prefix": 24,
                            "subnet": "44.128.0.0/16"
                        },
                        "state": {
                            "status": "STATUS_OK"
                        },
                        "subnet": "44.128.0.0/24"
                    }
                ]
            },
            {
                "ip": "10.10.0.118",
                "overlays": [
                    {
                        "backend": {
                            "vxlan": {
                                "vni": 1024,
                                "vtep_ip": "198.15.0.2/20",
                                "vtep_mac": "70:b3:d5:0f:00:02",
                                "vtep_name": "vtep1024"
                            }
                        },
                        "docker_bridge": {
                            "ip": "44.128.1.128/25",
                            "name": "d-dcos"
                        },
                        "info": {
                            "name": "dcos",
                            "prefix": 24,
                            "subnet": "44.128.0.0/16"
                        },
                        "state": {
                            "status": "STATUS_OK"
                        },
                        "subnet": "44.128.1.0/24"
                    }
                ]
            },
            {
                "ip": "10.10.0.119",
                "overlays": [
                    {
                        "backend": {
                            "vxlan": {
                                "vni": 1024,
                                "vtep_ip": "198.15.0.3/20",
                                "vtep_mac": "70:b3:d5:0f:00:03",
                                "vtep_name": "vtep1024"
                            }
                        },
                        "docker_bridge": {
                            "ip": "44.128.2.128/25",
                            "name": "d-dcos"
                        },
                        "info": {
                            "name": "dcos",
                            "prefix": 24,
                            "subnet": "44.128.0.0/16"
                        },
                        "state": {
                            "status": "STATUS_OK"
                        },
                        "subnet": "44.128.2.0/24"
                    }
                ]
            }
        ],
    "network": {
            "overlays": [
                {
                    "name": "dcos",
                    "prefix": 24,
                    "subnet": "44.128.0.0/16"
                }
            ],
            "vtep_mac_oui": "70:B3:D5:00:00:00",
            "vtep_subnet": "198.15.0.0/20"
        }
    }
```

# Deleting Overlay Networks

To delete your overlay network, uninstall DC/OS, then delete the overlay replicated log on the master nodes and the iptable rules on the agent nodes that are associated with the overlay networks.

## The Replicated Log

DC/OS overlay uses a replicated log to persist the overlay network state across Mesos master reboots and to recover overlay state when a new Mesos master is elected. The overlay replicated log is stored at `/var/lib/dcos/mesos/master/overlay_replicated_log`. The overlay replicated log is **not** removed when DC/OS is uninstalled from the cluster, so you need to delete this log manually before reinstalling DC/OS. Otherwise, the Mesos master will try to reconcile the existing overlay replicated log during startup and will fail if it finds an overlay network that was not configured.

**Note:** The overlay replicated log is different from the [master's replicated log](http://mesos.apache.org/documentation/latest/replicated-log-internals/), which is stored at /var/lib/mesos/master/replicated_log. Removing the *overlay* replicated log will have no effect on the master's recovery semantics.

## iptables
The overlay networks install IPMASQ rules in order to allow containers to talk outside the overlay network. When you delete or replace overlay networks, you must remove the rules associated with the previous overlay networks. To remove the IPMASQ rules associated with each overlay, remove the IPMASQ rule from the POSTROUTING change of the NAT table that corresponds to the overlay networks subnet. Remove these rules on each agent node.

<a name="replace"></a>
# Replacing or Adding New Overlay Networks

To replace your overlay network, uninstall DC/OS and delete the replicated log on the master nodes and the iptable rules on the agent nodes. Then, reinstall with the desired networks specified in your `config.yaml` file.

# Limitations
* In DC/OS overlay we slice the subnet of an overlay network into smaller subnets, and allocate these smaller subnets to agents. When an agent has exhausted its allocated address range and a framework tries to launch a container on the overlay network on this agent, the container launch will fail leading to a TASK_FAILED being reported to the framework. Since there is no API to report the exhaustion of addresses on an agent, it is up to the framework to infer that containers cannot be launched on an overlay network due to lack of IP addresses on the agent. This limitation of not being able to report address exhaustion has a direct impact on the behavior of frameworks, such as Marathon, that try to launch "services" with a specified number of instances. Due to this limitation, frameworks such as Marathon might not be able to complete their obligation of launching a service on an overlay network if they repeatedly try to launch instances of a service on an agent that has exhausted its allocated IP address range. The user should be aware of this limitation in order to debug issues using these frameworks when seeing task failures on an overlay network.
* The DC/OS overlay network does not allow frameworks to reserve IP addresses resulting in ephemeral addresses for containers across multiple incarnations on the overlay network. In order to host services whose IP addresses are assumed to be static, therefore, administrators should use [VIPs (virtual IP addresses)](https://dcos.io/docs/1.7/usage/service-discovery/load-balancing/).

# Troubleshooting

The **Networking** tab of the DC/OS web interface provides information helpful for troubleshooting. You can see which containers are on which network and see their IP addresses.


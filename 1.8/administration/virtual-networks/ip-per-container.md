---
layout: page
nav_title: IP-per-Container
post_title: Configuring IP-per-Container in Virtual Networks
menu_order: 10
---

In Enterprise DC/OS, the virtual network feature is enabled by default. The default configuration provides two overlay networks `dcos-1` and `dcos-2`, whose YAML configuration is as follows:

```yaml
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
```

**Note:** To use virtual networks in DC/OS you MUST make sure to use a recent Linux kernel (3.9 or above) as well as Docker version 1.11 on the agent nodes.

Each overlay network is identified by a canonical `name`. Containers launched on an overlay network will get an IP address from the `subnet` allocated to the overlay network. To remove the dependency on a global IPAM (IP address management system), the overlay `subnet` is further split into smaller subnets, with each subnet being allocated to an agent. The agents can then use a host-local IPAM to allocate IP addresses from their respective subnets to containers launched on the agent and attached to the given overlay. The `prefix` determines the size of the subnet (carved the overlay `subnet`) allocated to each
agent.

In the configuration above, each virtual network is allocated a /17 subnetwork (in the “subnet” field), which is then divided in /24 subnetworks to be used in each host that will be part of the network (in the “prefix” field). This allocates 8 bits (32 total minus 24 allocated for “prefix”) to designate the endpoint (container) inside a host for a maximum of 255 endpoints per host. It also allocates 7 bits (24 minus 17) for hosts that will be members of this overlay network, which provides a maximum of 127 hosts. These values can be configured to adapt to each installation’s needs.

# Adding overlay networks during installation

Currently (as of version 1.8), DC/OS virtual networks can only be added and configured at install time. You can override the default network or add additional virtual networks by modifying your `config.yaml` file:

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

**Note:** If you specify the same prefix and network mask for an overlay network, it will only work on one agent node.

# Retrieving overlay network state

Once the DC/OS installation is completed you can query the virtual network configuration using the `https://leader.mesos/overlay-master/state` endpoint from within the cluster. In the following, we show the resulting JSON. The `network` key at the bottom lists the current overlay configuration and the `agents` key is a list showing how overlays are split across the Mesos agents. The following shows the network state when there is a single overlay in the cluster named `dcos`.

```json
    &quot;agents&quot;: [
            {
                &quot;ip&quot;: &quot;10.10.0.120&quot;,
                &quot;overlays&quot;: [
                    {
                        &quot;backend&quot;: {
                            &quot;vxlan&quot;: {
                                &quot;vni&quot;: 1024,
                                &quot;vtep_ip&quot;: &quot;198.15.0.1/20&quot;,
                                &quot;vtep_mac&quot;: &quot;70:b3:d5:0f:00:01&quot;,
                                &quot;vtep_name&quot;: &quot;vtep1024&quot;
                            }
                        },
                        &quot;docker_bridge&quot;: {
                            &quot;ip&quot;: &quot;44.128.0.128/25&quot;,
                            &quot;name&quot;: &quot;d-dcos&quot;
                        },
                        &quot;info&quot;: {
                            &quot;name&quot;: &quot;dcos&quot;,
                            &quot;prefix&quot;: 24,
                            &quot;subnet&quot;: &quot;44.128.0.0/16&quot;
                        },
                        &quot;state&quot;: {
                            &quot;status&quot;: &quot;STATUS_OK&quot;
                        },
                        &quot;subnet&quot;: &quot;44.128.0.0/24&quot;
                    }
                ]
            },
            {
                &quot;ip&quot;: &quot;10.10.0.118&quot;,
                &quot;overlays&quot;: [
                    {
                        &quot;backend&quot;: {
                            &quot;vxlan&quot;: {
                                &quot;vni&quot;: 1024,
                                &quot;vtep_ip&quot;: &quot;198.15.0.2/20&quot;,
                                &quot;vtep_mac&quot;: &quot;70:b3:d5:0f:00:02&quot;,
                                &quot;vtep_name&quot;: &quot;vtep1024&quot;
                            }
                        },
                        &quot;docker_bridge&quot;: {
                            &quot;ip&quot;: &quot;44.128.1.128/25&quot;,
                            &quot;name&quot;: &quot;d-dcos&quot;
                        },
                        &quot;info&quot;: {
                            &quot;name&quot;: &quot;dcos&quot;,
                            &quot;prefix&quot;: 24,
                            &quot;subnet&quot;: &quot;44.128.0.0/16&quot;
                        },
                        &quot;state&quot;: {
                            &quot;status&quot;: &quot;STATUS_OK&quot;
                        },
                        &quot;subnet&quot;: &quot;44.128.1.0/24&quot;
                    }
                ]
            },
            {
                &quot;ip&quot;: &quot;10.10.0.119&quot;,
                &quot;overlays&quot;: [
                    {
                        &quot;backend&quot;: {
                            &quot;vxlan&quot;: {
                                &quot;vni&quot;: 1024,
                                &quot;vtep_ip&quot;: &quot;198.15.0.3/20&quot;,
                                &quot;vtep_mac&quot;: &quot;70:b3:d5:0f:00:03&quot;,
                                &quot;vtep_name&quot;: &quot;vtep1024&quot;
                            }
                        },
                        &quot;docker_bridge&quot;: {
                            &quot;ip&quot;: &quot;44.128.2.128/25&quot;,
                            &quot;name&quot;: &quot;d-dcos&quot;
                        },
                        &quot;info&quot;: {
                            &quot;name&quot;: &quot;dcos&quot;,
                            &quot;prefix&quot;: 24,
                            &quot;subnet&quot;: &quot;44.128.0.0/16&quot;
                        },
                        &quot;state&quot;: {
                            &quot;status&quot;: &quot;STATUS_OK&quot;
                        },
                        &quot;subnet&quot;: &quot;44.128.2.0/24&quot;
                    }
                ]
            }
        ],
    &quot;network&quot;: {
            &quot;overlays&quot;: [
                {
                    &quot;name&quot;: &quot;dcos&quot;,
                    &quot;prefix&quot;: 24,
                    &quot;subnet&quot;: &quot;44.128.0.0/16&quot;
                }
            ],
            &quot;vtep_mac_oui&quot;: &quot;70:B3:D5:00:00:00&quot;,
            &quot;vtep_subnet&quot;: &quot;198.15.0.0/20&quot;
        }
    }
```

# Deleting Overlay Networks

To delete your overlay network, uninstall DC/OS, then delete the overlay replicated log on the master nodes and the iptable rules on the agent nodes that aer associated with the overlay networks.

## The Replicated Log

DC/OS overlay uses a replicated log to persist the overlay network state across Mesos master reboots and to recover overlay state when a new Mesos master is elected. The overlay replicated log is stored at `/var/lib/dcos/mesos/master/overlay_replicated_log`. The overlay replicated log is **not** removed when DC/OS is uninstalled from the cluster, so you need to delete this log manually before reinstalling DC/OS. Otherwise, the Mesos master will try to reconcile the existing overlay replicated log during startup and will fail if it finds an overlay network that was not configured.

**Note:** The overlay replicated log is different from the [master's replicated log](http://mesos.apache.org/documentation/latest/replicated-log-internals/), which is stored at /var/lib/mesos/master/replicated_log. Removing the *overlay* replicated log will have no effect on the master's recovery semantics.

## iptables
The overlay networks install IPMASQ rules in order to allow containers to talk outside the overlay network. When you delete or replace overlay networks, you must remove the rules associated with the previous overlay networks. To remove the IPMASQ rules associated with each overlay, remove the IPMASQ rule from the POSTROUTING change of the NAT table that corresponds to the overlay networks subnet. Remove these rules on each agent node. 

# Replacing or Adding New Overlay Networks

To replace your overlay network, uninstall DC/OS and delete the replicated log on the master nodes and the iptable rules on the agent nodes. Then, reinstall with the desired networks specified in your `config.yaml` file.

# Troubleshooting

The **Networking** tab of the DC/OS web interface provides information helpful for troubleshooting. You can see which containers are on which network and see their IP addresses.

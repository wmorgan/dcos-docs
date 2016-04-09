---
UID: 56f98446d83f7
post_title: 'FAQ &#038; Troubleshooting'
post_excerpt: ""
layout: page
published: true
menu_order: 4
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
# How can I check the Mesos-DNS version?

You can check the Mesos-DNS version with `mesos-dns -version`.

**Note:** We do not recommend upgrading Mesos-DNS independently of DCOS. Use the version of Mesos-DNS that shipped with your version of DCOS.

# What if Mesos-DNS fails to launch?

Check that port 53 and port 8123 are available and not in use by other processes.

# What if my Agent nodes cannot connect to Mesos-DNS?

*   Make sure that port 53 is not blocked by a firewall rule on your cluster.

*   It is possible that the Master nodes are not running. Run `sudo systemctl status dcos-mesos-dns` and `sudo journalctl -u dcos-gen-resolvconf.service -n 200 -f` for more information about Mesos-DNS errors.

# How do I configure my DCOS cluster to communicate with external hosts and services?

For DNS requests for hostnames or services outside the DCOS cluster, Mesos-DNS will query an external nameserver. By default, Google's nameserver with IP address 8.8.8.8 will be used. If you need to configure a custom external name server, use the [`resolvers` parameter][1] when you first install DCOS.

**Important:** External nameservers can only be set when you install DCOS. They cannot be changed after installation.

# <a name="leader"></a>What is the difference between leader.mesos and master.mesos?

To query the leading master node, always query `leader.mesos`.

If you try to connect to `master.mesos` using HTTP, you will be automatically redirected to the leading master node.

However, if you try to query or connect to `master.mesos` using any method other than HTTP, the results will be unpredictable because the name will resolve to a random master node. For example, a service that attempts to register with `master.mesos` may communicate with a non-leading master node and will be unable to register as a service on the cluster.

 [1]: /administration/installing/installing-enterprise-edition/#config-json
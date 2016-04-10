---
UID: 56f98449d6863
post_title: Network Security
post_excerpt: ""
layout: page
published: true
menu_order: 4
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
The DCOS provides the admin, private, and public security zones.

<a href="/wp-content/uploads/2015/12/security-zones-ce.jpg" rel="attachment wp-att-1583"><img src="/wp-content/uploads/2015/12/security-zones-ce-800x640.jpg" alt="security-zones-ce" width="800" height="640" class="alignnone size-large wp-image-1583" /></a>

# Admin zone

The **admin** zone is accessible via HTTP/HTTPS and SSH connections, and provides access to your master nodes. It also provides proxy access to the other nodes in your cluster via URL routing. For security, you can configure a whitelist during [cluster creation][1] so that only specific IP address ranges are permitted to access the admin zone. The DCOS template creates 1 or 3 Mesos master nodes in the admin zone.

# Private zone

The **private** zone is a non-routable network that is only accessible from the admin zone or through the edgerouter from the public zone. Deployed apps and services are run in the private zone. This zone is where the majority of Mesos agent nodes are run. By default, the DCOS template creates 5 Mesos agent nodes in the private zone.

# Public zone

The optional **public** zone is where publicly accessible applications are run. Generally, only a small number of agent nodes are run in this zone. The edge router forwards traffic to applications running in the private zone. By default, the DCOS template creates 1 agent node in the public zone.

The agent nodes in the public zone are labeled with a special role so that only specific tasks can be scheduled here. These agent nodes have both public and private IP addresses and only specific ports are open in the firewall.

<!-- add more details around public zone -->

# Limitations

*   The DCOS Community Edition does not provide authentication. Authentication is available in the <a href="https://mesosphere.com/product/#" target="_blank">DCOS Enterprise Edition</a>. 
*   The DCOS CLI and web interface do not currently use an encrypted channel for communication. However, you can upload your own SSL certificate to the masters and change your CLI and web interface configuration to use HTTPS instead of HTTP.
*   You must secure your cluster by using security rules. It is strongly recommended that you only allow internal traffic.
*   If there is sensitive data in your cluster, follow standard cloud policies for accessing that data. Either set up a point to point VPN between your secure networks or run a VPN server inside your DCOS cluster.

 [1]: /administration/installing/
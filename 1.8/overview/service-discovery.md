---
post_title: Service Discovery
menu_order: 8
---

There are three levels of service discovery in DC/OS. Every task that runs on DC/OS is provided with a well known DNS name. Additionally, you can request a well known VIP that enables clients to have a single configuration value. Finally, you can assign logical names to services and route traffic by these names.

# VIPs

You can assign a VIP or VIPs to one of your services by following the steps in the [Service Discovery][1] section.

# Mesos-DNS

Every task started by DC/OS gets a well known DNS name. You can even enumerate every [DNS name][5] in your cluster. For a Marathon service named "testing", you can find where it is running via:

        dig testing.marathon.mesos

Take a look at the [mesos-dns documentation][4] for a more in-depth look at how Mesos-DNS is working and what it is doing for you.

# Logical names

You can use [linkerd][6] to route HTTP, Thrift and gRPC traffic to services by their logical name, by following the instructions in the [Service Discovery with linkerd][6] section. By default, logical names are the same as Marathon task name. More complex scenarios, such as blue-green deployments between versions of a service, are possible as well.

[1]: /docs/1.8/usage/service-discovery/
[2]: https://mesosphere.github.io/marathon/docs/ports.html
[3]: /docs/1.8/administration/sshcluster/
[4]: /docs/1.8/usage/service-discovery/mesos-dns/
[5]: /docs/1.8/usage/service-discovery/dns-naming/
[6]: /docs/1.8/usage/service-discovery/linkerd/

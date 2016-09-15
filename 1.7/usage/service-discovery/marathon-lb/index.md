---
post_title: Marathon-LB
---

marathon-lb is based on HAProxy, a rapid proxy and load balancer. HAProxy provides proxying and load balancing for TCP and HTTP based applications, with features such as SSL support, HTTP compression, health checking, Lua scripting and more. marathon-lb subscribes to Marathon’s event bus and updates the HAProxy configuration in real time.

Up to date documentation for MLB can be found on the GitHub page.

 * [Marathon-lb GitHub project][1]
 * [Detailed templates documentation][2]

You can can configure marathon-lb with various topologies. Here are some examples of how you might use marathon-lb:

*   Use marathon-lb as your edge load balancer and service discovery mechanism. You could run marathon-lb on public-facing nodes to route ingress traffic. You would use the IP addresses of your public-facing nodes in the A-records for your internal or external DNS records (depending on your use-case).
*   Use marathon-lb as an internal LB and service discovery mechanism, with a separate HA load balancer for routing public traffic in. For example, you may use an external F5 load balancer on-premise, or an Elastic Load Balancer on Amazon Web Services.
*   Use marathon-lb strictly as an internal load balancer and service discovery mechanism.
*   You might also want to use a combination of internal and external load balancers, with different services exposed on different load balancers.

Here, we discuss the fourth option above in order to highlight the features of marathon-lb.

![lb1](img/lb1.png)

# Next Steps

- [Getting Started][3]

[1]: https://github.com/mesosphere/marathon-lb
[2]: https://github.com/mesosphere/marathon-lb/blob/master/Longhelp.md#templates
[3]: usage/

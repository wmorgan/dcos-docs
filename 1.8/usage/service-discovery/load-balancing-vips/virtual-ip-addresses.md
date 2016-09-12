---
post_title: Using Virtual IP Addresses
menu_order: 10
---
DC/OS can map traffic from a single Virtual IP (VIP) to multiple IP addresses and ports. DC/OS VIPs are name-based, which means clients connect with a service address instead of an IP address. DC/OS generates name-based VIPs such that the cannot collide with IP VIPs, so administrators don't need to carefully manage name-based VIPs to avoid collision. This also means that name-based VIPs can be automatically created when the service is installed.

A named VIP contains 3 components:

 * Private virtual IP address
 * Port (a port which the service is available on)
 * Service name

You can assign a VIP to your application from the DC/OS web interface. The values you enter when you deploy a new service are translated into the appropriate `portMapping` entry in your Marathon application definition. Toggle to `JSON mode` as you create your app to see and edit your application definition.

## Prerequisite:

*   A pool of VIP addresses that are unique to your application.

To create a VIP:

1.  From the DC/OS web interface, click on the **Services** tab and click "Deploy Service".

    *   To create a new application, click **Create Application** and select the **Network** menu option.
    *   To edit an existing application, select your application, then click **Edit**. You can then select the **Network** menu option.

2.  Check the "Discovery" checkbox, then fill in the LB Port, Name, and Protocol fields. As you fill in these fields, the service addresses that Marathon sets up will appear at the bottom of the screen. You can assign multiple VIPs to your app by clicking "+ Add an endpoint".

    **Tip:** Toggle to **JSON Mode** to edit your application JSON directly and to see the application definition you have created.

    For more information on port configuration, see the [ports documentation][1].

 [1]: http://mesosphere.github.io/marathon/docs/ports.html

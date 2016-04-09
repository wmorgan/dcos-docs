---
UID: 56f98445387d2
post_title: Assigning a Virtual IP Addresses
post_excerpt: ""
layout: page
published: true
menu_order: 100
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: true
hide_from_related: true
---
DCOS can map traffic from a single Virtual IP (VIP) to multiple IP addresses and ports.

You can assign a VIP to your application by using the DCOS Marathon web interface. The values you enter in these fields are translated into the appropriate `portMapping` entry in your application definition. Toggle to `JSON mode` as you create your app to see and edit your application definition.

## Prerequisite:

*   A pool of VIP addresses that are unique to your application.

To create a VIP:

1.  From the DCOS web interface, click on the **Services** tab and select **marathon**.
    
    *   To create a new application, click **Create Application** and select the **Ports and Service Discovery** menu option. 
    *   To edit an existing application, select your application and click the **Configuration** tab, then click **Edit**. You can then select the **Ports and Service Discovery** menu option. 
    
    <a href="/wp-content/uploads/2016/03/ui-marathon-ports.gif" rel="attachment wp-att-4169"><img src="/wp-content/uploads/2016/03/ui-marathon-ports-800x406.gif" alt="ui-marathon-ports" width="800" height="406" class="alignnone size-large wp-image-4169" /></a>

2.  Enter the Port, Protocol, Name, and VIP address.
    
    **Tip:** Select **JSON Mode** to edit your application directly in JSON.
    
    For more information on port configuration, see the [ports documentation][1].

## Assigning Multiple VIPs to Your App

To assign multiple VIPs to your application, switch to JSON mode and add the additional VIPs to your `portDefinitions`. In this example, the additional VIP added is `"VIP_1": "111.2.1.23:5050"`:

    {
      "id": null,
      "cmd": "",
      "cpus": 1,
      "mem": 128,
      "disk": 0,
      "instances": 1,
      "ports": [
        0
      ],
      "portDefinitions": [
        {
          "port": 3333,
          "protocol": "tcp",
          "name": "test",
          "labels": {
            "VIP_0": "111.2.1.23",
            "VIP_1": "111.2.1.23:5050"
          }
        },
        {
          "port": 0,
          "protocol": "tcp",
          "name": null,
          "labels": null
        }
      ]
    }

 [1]: http://mesosphere.github.io/marathon/docs/ports.html
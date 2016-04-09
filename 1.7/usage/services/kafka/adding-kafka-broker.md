---
UID: 56f9844845c26
post_title: Adding a Kafka broker
post_excerpt: ""
layout: page
published: true
menu_order: 105
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
In this example, a Kafka broker is added by using the Kafka CLI.

**Prerequisites:**

*   The DCOS Kafka service is [installed][1]

1.  From the Kafka CLI add a new broker:
    
        $ dcos kafka broker add 1
        
        broker added:
          id: 1
          active: false
          state: stopped
          resources: cpus:1.00, mem:2048, heap:1024, port:auto
          failover: delay:1m, max-delay:10m
          stickiness: period:10m
        

2.  Start a new broker:
    
        $ dcos kafka broker start 1
        Broker 1 started
        

3.  Verify that the broker is added and started:
    
        $ dcos kafka broker list

 [1]: /usage/services/kafka/#kafkainstall
---
UID: 56f98447f1528
post_title: Listing Installed Services
post_excerpt: ""
layout: page
published: true
menu_order: 6
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
You can monitor the installed DCOS services and their health through the DCOS web interface or command line interface.

**Prerequisites:**

*   [DCOS cluster][1] is up and running.
*   [DCOS CLI][2] is installed and configured.

# Monitoring DCOS services in the DCOS web interface

From the DCOS web interface, click the **Services** tab. In this example you can see the installed DCOS services Cassandra, Chronos, and HDFS. All of the services are showing a status of Healthy.

<a href="/wp-content/uploads/2015/12/services.png" rel="attachment wp-att-1126"><img src="/wp-content/uploads/2015/12/services-800x486.png" alt="Services page" width="800" height="486" class="alignnone size-large wp-image-1126" /></a>

*   **SERVICE NAME** Displays the DCOS service name.
*   **HEALTH** Displays the [Marathon health check][3] status for the service.
*   **TASKS** Display the number of running tasks.
*   **CPU** Displays the percentage of CPU in use.
*   **MEM** Displays the amount of memory used.
*   **DISK** Displays the amount of disk space used.

For more information about the Services tab, see the DCOS web interface [documentation][4].

# Monitoring DCOS services in the DCOS CLI

From the DCOS CLI, enter the `dcos service` command. In this example you can see the native Marathon instance, and the installed DCOS services Chronos, HDFS, and Kafka.

    $ dcos service
    NAME      HOST             ACTIVE  TASKS CPU   MEM     DISK   ID                                         
    chronos   <privatenode1>   True     0    0.0    0.0     0.0   <service-id1>  
    hdfs      <privatenode2>   True     1    0.35  1036.8   0.0   <service-id2>  
    kafka     <privatenode3>   True     0    0.0    0.0     0.0   <service-id3> 
    marathon  <privatenode3>   True     3    2.0   1843.0  100.0  <service-id4>
    

*   **NAME** Displays the DCOS service name.
*   **HOST** Displays the private agent node where the service running.
*   **ACTIVE** Indicates whether the service is connected to a scheduler.
*   **TASK** Displays the number of running tasks.
*   **CPU** Displays the percentage of CPU in use.
*   **MEM** Displays the amount of memory used.
*   **DISK** Displays the amount of disk space used.
*   **ID** Displays the DCOS service framework ID. This value is automatically generated and is unique across the cluster.

 [1]: /administration/installing/
 [2]: /usage/cli/install/
 [3]: https://mesosphere.github.io/marathon/docs/health-checks.html
 [4]: /usage/webinterface/#scrollNav-2
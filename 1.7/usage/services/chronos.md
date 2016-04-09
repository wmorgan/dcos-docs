---
UID: 56f98449a773c
post_title: Chronos
post_excerpt: ""
layout: page
published: true
menu_order: 11
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
Chronos is the "cron" for your Mesosphere DCOS. It is a highly-available distributed job scheduler, providing the most robust way to run batch jobs in your datacenter. Chronos schedules jobs across the Mesos cluster and manages dependencies between jobs in an intelligent way.

*   [Installing Chronos on DCOS][1]
*   [Uninstalling Chronos][2]

### <a name="chronosinstall"></a>Installing Chronos on DCOS

**Prerequisite**

*   The DCOS CLI must be [installed][3].

1.  From the DCOS CLI, enter this command:
    
        $ dcos package install chronos
        
    
    **Tip:** You can specify a JSON configuration file along with the Chronos installation command: `dcos package install chronos --option <config_file>`. For more information, see the [dcos package section of the CLI command reference][4].

2.  [verify-service-install]

### <a name="uninstall"></a>Uninstalling Chronos

1.  From the DCOS CLI, enter this command:
    
        $ dcos package uninstall chronos
        

2.  Open the Zookeeper Exhibitor web interface at `<hostname>/exhibitor`, where `<hostname>` is the [Mesos Master hostname][5].
    
    1.  Click on the **Explorer** tab and navigate to the `chronos` folder.
        
        <a href="/wp-content/uploads/2015/12/chef-zk-status.png" rel="attachment wp-att-2112"><img src="/wp-content/uploads/2015/12/chef-zk-status.png" alt="chef-zk-status" width="551" height="467" class="alignnone size-full wp-image-2112" /></a>
    
    2.  Choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
        
        <a href="/wp-content/uploads/2015/12/zkchronosdelete.png" rel="attachment wp-att-1617"><img src="/wp-content/uploads/2015/12/zkchronosdelete.png" alt="zkchronosdelete" width="613" height="339" class="alignnone size-full wp-image-1617" /></a>
    
    3.  Click **OK** to confirm your deletion.

For more information:

*   <a href="http://mesos.github.io/chronos/docs/" target="_blank">Chronos documentation</a>

 [1]: #chronosinstall
 [2]: #uninstall
 [3]: /usage/cli/install/
 [4]: /usage/cli/command-reference/
 [5]: /administration/installing/awscluster#launchdcos
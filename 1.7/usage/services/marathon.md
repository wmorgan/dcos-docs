---
UID: 56f984496ddfc
post_title: Marathon
post_excerpt: ""
layout: page
published: true
menu_order: 17
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
The DCOS uses Marathon to manage the processes and services and is the "init system" for the DCOS. Marathon starts and monitors your applications and services, automatically healing failures.

A native Marathon instance is installed as a part of the DCOS installation. After DCOS has been started, you can manage the native Marathon instance through the web interface at `<hostname>/marathon` or from the DCOS CLI with the `dcos marathon` command.

You can create additional Marathon instances for specific users by using the instructions below.

# <a name="install"></a>Installing a Marathon instance on DCOS

**Prerequisite**

*   The DCOS CLI must be [installed][1].

1.  Install a Marathon instance:
    
    *   To install a single Marathon instance, enter this command from the DCOS CLI:
        
            $ dcos package install marathon
            
        
        By default the DCOS Service name is `marathon-user`. <a href="/wp-content/uploads/2015/12/marathontask.png" rel="attachment wp-att-1410"><img src="/wp-content/uploads/2015/12/marathontask.png" alt="marathontask" width="709" height="44" class="alignnone size-full wp-image-1410" /></a>
    
    *   To install multiple Marathon instances:
        
        1.  Create a custom JSON configuration file that includes this entry where `<name>` is the unique Marathon instance name:
            
                 {"marathon": {"framework-name": "marathon-<name>" }}
                
            
            **Tip:** You must create a separate JSON configuration file for each Marathon instance.
        
        2.  From the DCOS CLI, enter this command:
            
                 $ dcos package install --options=<config-file>.json marathon
                
        
        3.  From the DCOS web interface **Services** tab, click on your Marathon service name to navigate to the web interface. For more information, see [Deploying Multiple Marathon Instances][2].

# <a name="uninstall"></a>Uninstalling a Marathon Instance

1.  From the DCOS CLI, enter this command:
    
        $ dcos package uninstall marathon
        

2.  Open the Zookeeper Exhibitor web interface at `<hostname>/exhibitor`, where `<hostname>` is the [Mesos Master hostname][3].
    
    1.  Click on the **Explorer** tab and navigate to the `universe/<marathon-user>` folder.
        
        **Important:** Do not delete the `marathon` folder. This is the native DCOS Marathon instance.
        
        <a href="/wp-content/uploads/2015/12/zkmarathon.png" rel="attachment wp-att-1407"><img src="/wp-content/uploads/2015/12/zkmarathon-600x482.png" alt="zkmarathon" width="300" height="241" class="alignnone size-medium wp-image-1407" /></a>
    
    2.  Choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
        
        <a href="/wp-content/uploads/2015/12/zkmarathondelete.png" rel="attachment wp-att-1409"><img src="/wp-content/uploads/2015/12/zkmarathondelete-600x331.png" alt="zkmarathondelete" width="300" height="166" class="alignnone size-medium wp-image-1409" /></a>
    
    3.  Click **OK** to confirm your deletion.

For more information:

*   <a href="http://mesosphere.github.io/marathon/docs/" target="_blank">Marathon documentation</a>
*   [Deploying a Web App][4]

 [1]: /usage/cli/install/
 [2]: /usage/services/marathon/marathon-user-instance/
 [3]: /administration/installing/awscluster#launchdcos
 [4]: /tutorials/deploywebapp/
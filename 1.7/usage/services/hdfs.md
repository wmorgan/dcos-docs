---
UID: 56f984499056d
post_title: HDFS
post_excerpt: ""
layout: page
published: true
menu_order: 13
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
HDFS can be used to store and distribute data across your entire Mesosphere DCOS cluster.

# <a name="hdfsinstall"></a>Installing HDFS on DCOS

**Prerequisites**

*   The DCOS CLI must be [installed][1].
*   A DCOS cluster with a minimum of 5 private agents with at least 2 CPUs and 8 GB of RAM available for the HDFS Service.

1.  Install the HDFS DCOS service by using the default or custom installation:
    
    *   Default installation:
        
        1.  Enter this command:
            
                $ dcos package install hdfs
                
    
    *   Custom installation
        
        1.  Create an `options.json` file with additional configuration options. For example:
            
                {
                  "hdfs": {
                  "framework-name": "different-name-for-hdfs"
                  }
                }
                
        
        2.  Install the HDFS package with the `options.json` file specified:
            
                $ dcos package install --options=options.json hdfs
                
    
    **Tip:** HDFS can take up to 5 minutes to launch and fully verify its components.

2.  [verify-service-install] There should be several journalnodes, namenodes, and datanodes running as tasks. Wait for all of these to show the RUNNING state.

3.  Optional: To run advanced HDFS operations, [SSH into your cluster][2].
    
    1.  Using SSH, run the following commands on the agent node to test HDFS:
        
            $ hadoop fs -ls hdfs://hdfs/
            
            $ echo “this is a test” > test.txt
            
            $ hadoop fs -put test.txt hdfs://hdfs/
            
            $ hadoop fs -cat hdfs://hdfs/test.txt
            

# <a name="uninstall"></a>Uninstalling HDFS

1.  From the DCOS CLI, enter this command:
    
        $ dcos package uninstall hdfs
        

2.  Open the Zookeeper Exhibitor web interface at `<hostname>/exhibitor`, where `<hostname>` is the [Mesos Master hostname][3].
    
    1.  Click on the **Explorer** tab and navigate to the **hadoop-ha -> hdfs** folder.
        
        <a href="/wp-content/uploads/2015/12/zkhdfs2.png" rel="attachment wp-att-1620"><img src="/wp-content/uploads/2015/12/zkhdfs2.png" alt="zkhdfs2" width="399" height="246" class="alignnone size-full wp-image-1620" /></a>
    
    2.  Click the **Modify...** button at the bottom of the page.
    
    3.  Choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
        
        <a href="/wp-content/uploads/2015/12/zkhdfsdelete.png" rel="attachment wp-att-1621"><img src="/wp-content/uploads/2015/12/zkhdfsdelete.png" alt="zkhdfsdelete" width="537" height="285" class="alignnone size-full wp-image-1621" /></a>
    
    4.  You will be prompted to confirm the deletion. If you are sure you want to delete, click the OK button.
    
    5.  Click on the **Explorer** tab and navigate to the **hdfs-mesos** folder.
    
    6.  Repeat the procedure for removing the folder: Click the **Modify...** button, choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
    
    7.  Click **OK** to confirm your deletion.

3.  For a complete uninstall, you must delete the data directories for HDFS in the individual agent nodes.
    
    1.  Identify the HDFS agent nodes to delete by using the DCOS web interface [Nodes tab][4]. For example, to identify all of the HDFS agent nodes choose the the **hdfs** filter on the Nodes tab:
        
        <a href="/wp-content/uploads/2015/12/nodeshdfs.png" rel="attachment wp-att-1571"><img src="/wp-content/uploads/2015/12/nodeshdfs-600x419.png" alt="nodeshdfs" width="300" height="210" class="alignnone size-medium wp-image-1571" /></a>
    
    2.  [SSH to your agent node][2].
    
    3.  Navigate to your data directory in the agent node. In DCOS, the default location for HDFS data directories is `/var/lib/hdfs`.
        
            $ cd /var/lib
            
    
    4.  Delete the data directory for HDFS:
        
            $ sudo rm -rf <service-name>
            
    
    5.  Close your agent node SSH connection:
        
            $ exit
            
    
    6.  Repeat these steps for each agent node.

For more information, see the <a href="https://github.com/mesosphere/hdfs/" target="_blank">HDFS on Mesos documentation</a>.

 [1]: /usage/cli/install/
 [2]: /administration/sshcluster/
 [3]: /administration/installing/awscluster#launchdcos
 [4]: /usage/webinterface/#nodes
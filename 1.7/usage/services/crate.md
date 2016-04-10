---
UID: 56f9844943dff
post_title: Crate
post_excerpt: ""
layout: page
published: true
menu_order: 12
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
**Disclaimer:** The Crate service is available at the alpha level and not recommended for Mesosphere DCOS production systems.

Crate is a distributed NoSQL database that you can use to query and compute data with SQL in real-time. It provides a distributed aggregation engine, native search, and super simple scalability. Crate's shared-nothing-architecture means it is optimized for distributed environments that allow horizontal scaling of applications.

The Crate DCOS service is <a href="https://crate.io/docs/support/" target="_blank">supported</a> by a Crate Technology Gmbh.

*   [Installing Crate on DCOS][1]
*   [Usage Examples][2]
*   [Uninstalling Crate][3]

## <a name="install"></a>Installing Crate on DCOS

Prerequisite
:   The DCOS CLI must be [installed][4].

To install Crate using the DCOS CLI:

1.  Install Crate with this command:
    
        $ dcos package install crate
        

3.  Verify that Crate is successfully installed and running:
    
    *   From the DCOS CLI:
        
        $ dcos package list NAME VERSION APP COMMAND DESCRIPTION crate 0.1.0 /crate --- A Mesos Framework that allows running and resizing one or multiple Crate database clusters.
    
    *   From the DCOS web interface, go to the **Services** tab and confirm that Crate is running:

<a href="/wp-content/uploads/2015/12/cratetask.png" rel="attachment wp-att-1515"><img src="/wp-content/uploads/2015/12/cratetask-800x47.png" alt="cratetask" width="800" height="47" class="alignnone size-large wp-image-1515" /></a>

## <a name="usage"></a>Usage Examples

After installing, only a single Crate task is running on the DCOS cluster. To launch the Crate cluster you must use the Framework API and have enough resources to add Crate instances.

*   [Launching/Resizing the Cluster][6]
*   [Shutting Down the Cluster][7]
*   [Installing Multiple Crate Clusters][8]

### <a name="launch"></a>Launching and Resizing the Cluster

**Prerequisite:** You must [SSH into the agent node][9] that is running the Crate service.

To launch instances, POST the number of desired instances to the `/resize` endpoint:

    $ curl -X POST localhost:4040/cluster/resize \
          -H "Content-Type: application/json" \
          -d '{"instances": 3}'
    

### <a name="shutdown"></a>Shutting Down the Cluster

**Prerequisite:** You must [SSH into the agent node][9] that is running the Crate service.

1.  To shut down the cluster, POST to the `/shutdown` endpoint:
    
        $ curl -X POST localhost:4040/cluster/shutdown
        
    
    This immediately shuts down all running Crate nodes of the cluster.

### <a name="multiple"></a>Installing Multiple Crate Clusters

A single instance of the Crate framework can only run a single Crate cluster. To install multiple Crate clusters, specify unique framework names for each cluster in your options file.

**Prerequisite:** You must [SSH into the agent node][9] that is running the Crate service.

1.  Add `crate.framework-name` and `crate.cluster-name` to your options file. You must use a unique name for each cluster and set each framwork API port to a unique and available port (default is 4040). This is not exposed but is required to route the DCOS endpoints to the correct framework instance.
    
        {
          "crate": {
            "version": "0.50.2",
            "framework-name": "crate-2",
            "cluster-name": "my-cluster"
            "framework": {
              "api-port": 4041
            }
          }
        }
        

2.  Run the install command with the DCOS CLI:
    
        $ dcos package install crate --options=crate-options.json
        

## <a name="uninstall"></a>Uninstalling Crate

1.  From the DCOS CLI, enter this command::
    
        $ dcos package uninstall crate
        
    
    If you have installed multiple Crate frameworks you will need to provide the `--app-id` option. For example:
    
        $ dcos package uninstall crate --app-id /crate-2
        

2.  Open the Zookeeper Exhibitor web interface at `<hostname>/exhibitor`, where `<hostname>` is the [Mesos Master hostname][10].
    
    1.  Click on **Explorer** tab and select the desired app folder (`crate`) and click **Modify** at the bottom of the explorer.
        
        <a href="/wp-content/uploads/2015/12/screenshot-delete-zookeeper.png" rel="attachment wp-att-1581"><img src="/wp-content/uploads/2015/12/screenshot-delete-zookeeper-800x675.png" alt="screenshot-delete-zookeeper" width="800" height="675" class="alignnone size-large wp-image-1581" /></a>
    
    2.  Choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
    
    3.  Click **OK** to confirm your deletion.

3.  Optional: Clear your data directories. By default the Crate DCOS Service data and log directories are written into the Mesos task sandbox. The Mesos task sandbox is automatically purged periodically. You can change this by setting the `crate.data-directory` option when you install the Crate DCOS Service. You can find more information about how to use custom, persistent data paths in the [Crate framework documentation][11].

## Links

Crate is <a href="https://crate.io/docs/support/" target="_blank">supported</a> by a Crate Technology Gmbh. For information about Crate enterprise edition, see <a href="https://crate.io/enterprise/" target="_blank">https://crate.io/enterprise/</a> or contact <sales@crate.io>.

*   <https://crate.io>
*   [Framework Documentation][12]
*   [Crate Documentation][13]

 [1]: #install
 [2]: #usage
 [3]: #uninstall
 [4]: /usage/cli/install/
 [5]: /usage/package-repo/
 [6]: #launch
 [7]: #shutdown
 [8]: #multiple
 [9]: /administration/sshcluster/
 [10]: /administration/installing/awscluster#launchdcos
 [11]: https://github.com/crate/crate-mesos-framework#persistent-data-paths
 [12]: https://github.com/crate/crate-mesos-framework/blob/master/README.rst
 [13]: https://crate.io/docs
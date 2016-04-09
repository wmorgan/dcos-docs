---
UID: 56f98449afc05
post_title: Cassandra
post_excerpt: ""
layout: page
published: true
menu_order: 10
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
Cassandra is an open source distributed database management system designed to handle large amounts of data across many commodity servers, providing high availability with no single point of failure. Cassandra is well suited to run on Mesos due to its peer-to-peer architecture. Cassandra has great features that back today’s web applications with its horizontal scalability, no single point of failure, and a simple query language (CQL).

For information about how Mesos DNS is implemented for the Cassandra DCOS service, see the <a href="http://mesosphere.github.io/cassandra-mesos/docs/mesos-dns.html" target="_blank">Cassandra-Mesos documentation</a>.

# <a name="cassandrainstall"></a>Installing Cassandra on DCOS

**Prerequisite**

*   The DCOS CLI must be [installed][1].
*   A DCOS cluster with at least 3 private nodes, each with 0.3 CPU shares, 1184MB of memory and 272MB of disk.

1.  From the DCOS CLI, enter this command:
    
        $ dcos package install cassandra
        
    
    **Tip:** It can take up to 6 minutes for the Cassandra ring to bootstrap. During this time, the DCOS web interface may show the service as Unhealthy.

2.  [verify-service-install]

3.  To run advanced Cassandra jobs, you must SSH into your cluster. For more information on SSHing into your cluster, see [Establishing an SSH Connection][2].
    
    For example, to view several system tables in the Cassandra servers, from any node in your cluster, run the following command. Because this example downloads a Docker file, it may take a while.
    
        $ docker run -i -t --net=host \
              --entrypoint=/usr/bin/cqlsh \
              spotify/cassandra -e " \
              SELECT * FROM system.schema_keyspaces ; \
              SELECT * FROM system.schema_columns ; \
              SELECT * FROM system.schema_columnfamilies ;" \
              cassandra-dcos-node.cassandra.dcos.mesos 9160
        

# <a name="uninstall"></a>Uninstalling Cassandra

1.  From the DCOS CLI, enter this command:
    
        $ dcos package uninstall cassandra
        

2.  Open the Zookeeper Exhibitor web interface at `<hostname>/exhibitor`, where `<hostname>` is the [Mesos Master hostname][3].
    
    1.  Click on the **Explorer** tab and navigate to the `cassandra-mesos` folder.
        
        <a href="/wp-content/uploads/2015/12/zkcassandra.png" rel="attachment wp-att-1329"><img src="/wp-content/uploads/2015/12/zkcassandra-150x150.png" alt="zkcassandra" width="150" height="150" class="alignnone size-thumbnail wp-image-1329" /></a>
    
    2.  Click the **Modify** button on the lower-left side of browser.
    
    3.  Choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
        
        <a href="/wp-content/uploads/2015/12/zkcassandradelete.png" rel="attachment wp-att-1332"><img src="/wp-content/uploads/2015/12/zkcassandradelete-600x334.png" alt="zkcassandradelete" width="300" height="167" class="alignnone size-medium wp-image-1332" /></a>
    
    4.  Click **OK** to confirm your deletion.

3.  Clear your data directories. By default the Cassandra DCOS Service data and log directories are written into the Mesos task sandbox. You can change this by setting the `cassandra.data-directory` option when you install the Cassandra DCOS Service.

For more information:

*   <a href="http://mesosphere.github.io/cassandra-mesos/" target="_blank">Cassandra Mesos documentation</a>
*   [Deploying a Containerized App on a Public Node][4]

 [1]: /usage/cli/install/
 [2]: /administration/sshcluster/
 [3]: /administration/installing/awscluster#launchdcos
 [4]: /usage/tutorials/containerized-app/